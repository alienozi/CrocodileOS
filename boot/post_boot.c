#include<stdint.h>
#include<stdbool.h>
#include<primative.h>
#include<le_pci.h>
#include<le_ahci.h>
#include<ahci_primative.h>
#include<iso9660_primative.h>

static uint16_t dev_info[256];
static uint16_t file_buffer[2*ISO9660_SECTOR_SIZE/sizeof(uint16_t)];
static Cmmd_header* cmmd_list = (Cmmd_header*)0x1000;
static uint32_t* fis_base = (uint32_t*) 0x2000;
static Cmmd_table* cmmd_table = (Cmmd_table*)0x4000;
int main(char* cos_sig){
	Pci_config_addr pci_config_addr = {0,0,0,0,0,0};
	Ahci_dev_ctrl sata_dev;
	Prdt_entry prdt;
	Fis_reg_h2d fis;
	Atapi_cmmd12 atapi_cmmd;
	uint32_t *ui32p_ahci_base_ptr;
	bool is_device_found;
	uint32_t file_size = 0;

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
	file_size = pri_iso9660_file_read(&sata_dev, file_buffer, "/HOME/CD_USER/ICON.STR;1");
	pri_cpy(TEXT_MODE_VGA_VIDEO_MEM_ADDR, file_buffer, file_size);
	pri_print(0x0f,"\b%s\n",cos_sig);

	pci_config_addr.device_num = 0;
	pci_config_addr.bus_num = 0;
	if(pci_search_dev(&pci_config_addr, 0x04010000, 0xFFFF0000)){
		pri_print(0x0f, "device found in bus:%d device:%d",pci_config_addr.bus_num,pci_config_addr.device_num);
	}

	asm volatile inline ("hlt\n");

}