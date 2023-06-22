#ifndef SHREK.H
#define SHREK.H
#include<stdint>
struct Shrek_main_header{
	const uint8_t identifier[8]={'.','S','H','R','E','K',239,93};
	const uint8_t version[4] = {1,0,0,1};
	const uint16_t header_size = sizeof(struct Shrek_main_header);
	uint16_t num_of_eb;
	uint16_t num_of_func;
	uint16_t check_sum;
	uint32_t eb_entry_offset;
	uint32_t func_entry_offset;
	const uint32_t 0;		//reserved
};
struct Shrek_eb_header{
	uint32_t name_offset;
	uint32_t type;
	uint32_t vaddr;
	uint32_t size;	//in bytes
	uint16_t first_func_index;
	uint16_t num_of_func;
	const uint16_t header_size = sizeof(struct Shrek_eb_header);
	uint16_t num_of_section;
	uint16_t lock_func_offset;
	const uint16_t 0;		//reserved
};

#endif