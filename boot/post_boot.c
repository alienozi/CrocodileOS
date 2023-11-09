#include<stdint.h>
#include<stdbool.h>

#include<general/cosdef.h>
#include<general/shrek.h>
#include<general/cosstr.h>

#include<kernel/pci.h>

#include<primative/biosMMap.h>
#include<primative/primative.h>
#include<primative/iso9660_primative.h>

#define TEMP_CMMD_LIST_ADDR	0x1000
#define TEMP_FIS_BASE_ADDR	0x2000
#define TEMP_CMMD_TABLE_ADDR	0x3000

static uint16_t dev_info[256];
static uint16_t file_buffer[2*ISO9660_SECTOR_SIZE/sizeof(uint16_t)];
static Cmmd_header* cmmd_list = (Cmmd_header*)TEMP_CMMD_LIST_ADDR;
static uint32_t* fis_base = (uint32_t*) TEMP_FIS_BASE_ADDR;
static Cmmd_table* cmmd_table = (Cmmd_table*)TEMP_CMMD_TABLE_ADDR;
int main(char* cos_sig, bios_mmap_entry* bios_mmap, uint32_t bios_mmap_length){
	Pci_config_addr pci_config_addr = {0,0,0,0,0,0};
	Ahci_dev_ctrl sata_dev;
	Prdt_entry prdt;
	Fis_reg_h2d fis;
	Atapi_cmmd12 atapi_cmmd;
	uint32_t *ui32p_ahci_base_ptr;
	bool is_device_found;
	uint32_t file_size = 0;
	void* vaddr;
	uint32_t random;

	Shrek_main_header *shrek_header;
	Shrek_eb_header *eb_header;
	Shrek_eb_section_entry *eb_entry;
	Shrek_eb_function_entry *func_entry;
	char*	string_table;

	int (*kernel_main)(bios_mmap_entry*, uint32_t) = NULL;

	pri_print(0x0f,"executing: boot loader\n");

	pci_search_dev(&pci_config_addr, AHCI_PCI_SIG, AHCI_PCI_SIG_MASK);
	pci_config_addr.reg_off = PCI_BUS_BAR5_OFFSET;
	pci_set_conf_addr(&pci_config_addr);
	ui32p_ahci_base_ptr = (uint32_t*)pci_read_config();

	pri_print(0x0f, "abar addr:0x%X\n",ui32p_ahci_base_ptr);	
	is_device_found = ahci_scan_port((Ahci_ctrl*)ui32p_ahci_base_ptr, &sata_dev,0, ATAPI_SIGNATURE);

	pri_fill(cmmd_list, 0, sizeof(Cmmd_header)*32);
	pri_fill(fis_base, 0, 256);
	pri_fill(cmmd_table, 0, sizeof(Cmmd_table));
	cmmd_list[0].cmmd_table = cmmd_table;

	
	while(is_device_found){
		pri_print(0x0f,"ATAPI device found in port%d\n",sata_dev.port_id);

		ahci_stop_cmd(&sata_dev);
		ahci_stop_fr(&sata_dev);

		ahci_rebase_cmd_slot(&sata_dev, cmmd_list, fis_base);
	
		ahci_start_fr(&sata_dev);

		pri_identify_atapi_dev(&sata_dev, dev_info);
		pri_dev_info_print(0x0F, dev_info);

		file_size = pri_iso9660_file_read(&sata_dev, file_buffer, "/BOOT/COS_SIGNATURE.TXT;1");
		pri_print(0x0f,"fsize:%d\n",file_size);
		if(pri_cmp(cos_sig,file_buffer,file_size)){
			pri_print(0x0f,"COS_SIGNATURE match%d\n",file_size);
			break;
		}
		pri_print(0x0f,"COS_SIGNATURE do not match\n");
		ahci_stop_cmd(&sata_dev);
		ahci_stop_fr(&sata_dev);
		is_device_found = ahci_scan_port((Ahci_ctrl*)ui32p_ahci_base_ptr, &sata_dev,sata_dev.port_id + 1, ATAPI_SIGNATURE);
	}

	if(!is_device_found){
		pri_print(0x8f, "failed to locate boot storage drive");
		while(1);
	}
	file_size = pri_iso9660_file_read(&sata_dev, file_buffer, "/HOME/_ICONS/ICON.STR;1");
	pri_cpy(TEXT_MODE_VGA_VIDEO_MEM_ADDR, file_buffer, file_size);
	pri_print(0x0f,"\b");
	pri_print(0x0f,cos_sig);

	file_size = pri_iso9660_file_read(&sata_dev, file_buffer, "/KERNEL/KERNEL.SHREK;1");

	shrek_header = (Shrek_main_header*)file_buffer;
	eb_header = (Shrek_eb_header*) ADD_OFFSET_TO_PTR(shrek_header, shrek_header->eb_entry_offset);
	func_entry = (Shrek_eb_function_entry*) ADD_OFFSET_TO_PTR(shrek_header, shrek_header->func_entry_offset);
	string_table = (char*)ADD_OFFSET_TO_PTR(shrek_header, shrek_header->string_table_offset);
	
	for(int i_eb = 0; i_eb < shrek_header->num_of_eb; i_eb++){
		
		eb_entry = (Shrek_eb_section_entry*) ADD_OFFSET_TO_PTR(eb_header, eb_header->header_size);
		vaddr = (void*) eb_header->vaddr;

		for(int i_sect = 0; i_sect < eb_header->num_of_section; i_sect++){
			if(shrek_header,eb_entry[i_sect].type == SHREK_DATA){
				//pri_print(0x0f, "section%d vaddr: 0x%X", i_sect, vaddr);
				pri_cpy(vaddr, ADD_OFFSET_TO_PTR(shrek_header, eb_entry[i_sect].data_offset), eb_entry[i_sect].size);
				vaddr = ADD_OFFSET_TO_PTR(vaddr, eb_entry[i_sect].size);
				vaddr = ALLIGN_PTR(vaddr, 16);
			}else if(shrek_header,eb_entry[i_sect].type == SHREK_BSS){
				//pri_print(0x0f, "section%d vaddr: 0x%X", i_sect, vaddr);
				pri_fill(vaddr, 0x0, eb_entry[i_sect].size);
				vaddr = ADD_OFFSET_TO_PTR(vaddr, eb_entry[i_sect].size);
				vaddr = ADD_OFFSET_TO_PTR(ALLIGN_PTR(vaddr, PAGE_SIZE), PAGE_SIZE);
			}else if(shrek_header,eb_entry[i_sect].type == SHREK_RODATA){
				if(shrek_header,eb_entry[i_sect-1].type == SHREK_DATA) vaddr = ADD_OFFSET_TO_PTR(ALLIGN_PTR(vaddr, PAGE_SIZE), PAGE_SIZE);
				//pri_print(0x0f, "section%d vaddr: 0x%X", i_sect, vaddr);
				pri_cpy(vaddr, ADD_OFFSET_TO_PTR(shrek_header, eb_entry[i_sect].data_offset), eb_entry[i_sect].size);
				vaddr = ADD_OFFSET_TO_PTR(ALLIGN_PTR(vaddr, PAGE_SIZE), PAGE_SIZE);
				
			}else{
				//pri_print(0x0f, "section%d vaddr: 0x%X", i_sect, vaddr);
				pri_cpy(vaddr, ADD_OFFSET_TO_PTR(shrek_header,eb_entry[i_sect].data_offset), eb_entry[i_sect].size);
				vaddr = ADD_OFFSET_TO_PTR(vaddr, eb_entry[i_sect].size);
				vaddr = ADD_OFFSET_TO_PTR(ALLIGN_PTR(vaddr, PAGE_SIZE), PAGE_SIZE);
			}
		}
		for(int i_func = eb_header->first_func_index; i_func < eb_header->first_func_index+eb_header->num_of_func; i_func++){
			if(strcmp(&string_table[func_entry[i_func].name], "kernel_bsp_init") == 0){
				kernel_main = ADD_OFFSET_TO_PTR( eb_header->vaddr, func_entry[i_func].EB_offset);
				//pri_print(0x0f, "main found at kernel.shrek 0x%X\n",ADD_OFFSET_TO_PTR( eb_header->vaddr, func_entry[i_func].EB_offset));
			}
		}
		eb_header = (Shrek_eb_header*) ADD_OFFSET_TO_PTR(eb_entry, eb_header->num_of_section * sizeof(Shrek_eb_section_entry));
	}

	if(kernel_main == NULL){
		asm volatile inline ("hlt\n");
	}else{
		kernel_main(bios_mmap, bios_mmap_length);
	}
	
	
	
	asm volatile inline ("hlt\n");

}