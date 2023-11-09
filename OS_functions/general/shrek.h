//a 32-bit shrek data structure library for COS
//author:Totan
#ifndef SHREK_H
#define SHREK_H

#define SHREK_PERMISSION_ALLOWED	0xFF
#define SHREK_PERMISSION_NOTALLOWED	0xFF

#define SHREK_LOCAL 0
#define SHREK_SHARED 0x00FF
#define SHREK_DYNAMIC 0xFF00

#define SHREK_TEXT	1
#define SHREK_DATA	2
#define SHREK_BSS	3
#define SHREK_RODATA	4

#define SHREK_TYPE_STRING_LOCAL		"LOCAL"
#define SHREK_TYPE_STRING_DYNAMIC	"DYNAMIC"
#define SHREK_TYPE_STRING_SHARED	"SHARED"

#define SHREK_GET_TYPE_STRING(TYPE)   ( (TYPE == SHREK_LOCAL) ? SHREK_TYPE_STRING_LOCAL : ( (TYPE == SHREK_DYNAMIC) ? SHREK_TYPE_STRING_DYNAMIC : (SHREK_TYPE_STRING_SHARED) ))

static const char* SHREK_SECTION_TYPE_STRING_ARRAY[] = {"UNDEFINED", "TEXT", "DATA", "BSS", "RODATA"};
#define SHREK_GET_SECTION_TYPE_STRING(TYPE) SHREK_SECTION_TYPE_STRING_ARRAY[TYPE]
 
#include<stdint.h>
typedef struct{
	uint8_t identifier[8];;
	uint8_t version[4];
	uint16_t header_size;
	uint16_t num_of_eb;
	uint32_t num_of_func;
	uint32_t eb_entry_offset;
	uint32_t func_entry_offset;
	uint32_t string_table_offset;
	uint32_t check_sum;
	uint32_t RESERVED;		//reserved
}Shrek_main_header;
#define NULL_SHREAK_HEADER {{'.','S','H','R','E','K',239,93}, {1,0,0,1}, sizeof(Shrek_main_header),  0, 0, 0, 0, 0, 0,0}
typedef struct{
	uint32_t name_offset;
	uint32_t type;
	uint32_t vaddr;
	uint32_t size;	//in bytes
	uint32_t first_func_index;
	uint32_t num_of_func;
	uint16_t header_size;
	uint16_t num_of_section;
	uint32_t unlock_func_index;
	uint32_t RESERVED;		//reserved
}Shrek_eb_header;
#define NULL_EB_HEADER {0,0,0,0,0,0,sizeof(Shrek_eb_header),0,0,0};
typedef struct{
	uint32_t type;
	uint32_t size;
	uint32_t data_offset;
	union{
		uint32_t section_key;
		struct{
		uint8_t write_permision;
		uint8_t execute_permision;
		uint8_t share_permision;
		uint8_t share_main_permisions;
	};
};
}Shrek_eb_section_entry;
typedef struct{
	uint32_t name;
	uint32_t EB_ID;
	uint32_t EB_offset;
}Shrek_eb_function_entry;
#endif
