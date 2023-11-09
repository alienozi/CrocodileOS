//a 32-bit kernel for COS
//author:Totan
#include<primative/primative.h>
#include<primative/biosMMap.h>
int kernel_bsp_init(bios_mmap_entry* bios_mmap, uint32_t bios_mmap_len){
	uint32_t coreId;
	asm volatile inline("rdpid eax\n":"=a"(coreId):);
	pri_print(0x0f,"coreId: %u\n", coreId);

	for(uint32_t i=0; i < bios_mmap_len; i++){
		pri_print(0x0f, "base_h: 0x%X base_l: 0x%X\t", bios_mmap[i].base_h, bios_mmap[i].base_l);
		pri_print(0x0f, "len_h: 0x%X len_l: 0x%X\n", bios_mmap[i].length_h, bios_mmap[i].length_l);
		pri_print(0x0f, "type: %d\n", bios_mmap[i].type);
	}

	asm volatile inline("hlt\n");
}