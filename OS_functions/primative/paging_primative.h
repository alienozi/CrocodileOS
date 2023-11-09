#ifndef PAGING_PRIMATIVE_H
#define PAGING_PRIMATIVE_H

#define PAGE_STRUCTURE_BASE	0x1000000
#define PAGE_STRUCTURE_VBASE	0x100000

#include<stdint.h>

#include<cosdef.h>
#include<cosstr.h>
#include<paging.h>
#include<limit.h>
#include<segmentation.h>
#include<primative/biosMMap.h>

bool init_paging_tables(bios_mmap_entry* bios_mmap, uint32_t bios_mmap_length){
	uint16_t page_status;
	uint32_t random;
	uint32_t max_page_index = 0;		//assuming system has a memory space less than 16TB
	page_entry* page_list;
	void*	page_list_vaddr;
	asm volatile inline("rdtsc\n":"=a"(random)::"edx");
	random = (random << 12) & 0x000FFFFF;

	page_list = (page_entry*) (random + PAGE_STRUCTURE_BASE);

	//finding the page list size

	for(uint32_t i_map  = 0; i_map < bios_mmap_length; i_map ++){

		if(max_page_index < PHY_ADDR_TO_PAGE_INDEX(bios_mmap[i_map].base) + PHY_ADDR_TO_PAGE_INDEX(bios_mmap[i_map].length) ){

			max_page_index = PHY_ADDR_TO_PAGE_INDEX(bios_mmap[i_map].base) + PHY_ADDR_TO_PAGE_INDEX(bios_mmap[i_map].length);

		}

	}

	memset(page_list, 0, max_page_index * sizeof(page_entry));

	//marking ram and illegal memories

	for(uint32_t i_map  = 0; i_map  < bios_mmap_length; i_map++){

		for(uint32_t  = 0; i_page < PHY_ADDR_TO_PAGE_INDEX(bios_mmap[i_map].length); i_page++){

			switch(bios_mmap[i_map].type){

				case BIOS_MEM_TYPE_USABLE_RAM:

					page_status = MEM_MAPED_PAGE;
					break;

				case BIOS_MEM_TYPE_UNUSABLE:

					page_status = NULL_PAGE;
					break;

				case BIOS_MEM_TYPE_ACPI_RECLAIMABLE:
				case BIOS_MEM_TYPE_ACPI_NVS:
				case BIOS_MEM_TYPE_BAD:
					
					page_status = ILLEGAL_PAGE;
					break;
			};

			page_list[PHY_ADDR_TO_PAGE_INDEX(bios_mmap[i_map].base) + i_page].status = page_status;
		}
	}

	page_list[max_page_index-1].eom = 1;

	//updating the page list with itself

	for(  uint32_t  = 0; i_page < (uint64_t)ALLIGN_PTR(max_page_index * sizeof(page_entry) , PAGE_SIZE) / PAGE_SIZE  ); i_page++   ){

		page_list[PHY_ADDR_TO_PAGE_INDEX(page_list) + i_page].count++;
		//checking the page type just in case
		if(rare(page_list[PHY_ADDR_TO_PAGE_INDEX(page_list) + i_page].status != BIOS_MEM_TYPE_USABLE_RAM)){
			return false;
		}
	}

	asm volatile inline("rdtsc\n":"=a"(random)::"edx");
	random = (random << 12) & 0x000FFFFF;
	page_list_vaddr = PAGE_STRUCTURE_VBASE + random;

	
}

#endif