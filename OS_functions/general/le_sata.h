#ifndef LE_SATA
#define LE_SATA

#include<stdint.h>
#define ATAPI_SIGNATURE 0xEB140101

#define ATAPI_12BYTE_GROUP_CODE 5
#define ATAPI_16BYTE_GROUP_CODE 4

#define IS_16BYTE_ATAPI_CMMD(OPCODE) (ATAPI_16BYTE_GROUP_CODE == ((OPCODE >> 5 )& 0x4))
#define IS_12BYTE_ATAPI_CMMD(OPCODE) (ATAPI_12BYTE_GROUP_CODE == ((OPCODE >> 5)& 0x5))

#define ATAPI_IDENTIFY_SERIAL_NUMBER_WOFFSET		10
#define ATAPI_IDENTIFY_SERIAL_NUMBER_LENGTH		10
#define ATAPI_IDENTIFY_FIRMWARE_VERSION_WOFFSET		23
#define ATAPI_IDENTIFY_FIRMWARE_VERSION_LENGTH		4
#define ATAPI_IDENTIFY_MODEL_NUMBER_WOFFSET		27
#define ATAPI_IDENTIFY_MODEL_NUMBER_LENGTH		20

typedef struct{
	uint8_t opcode;
	uint8_t service_action:5;
	uint8_t misc_info1:3;
	uint8_t lba31_24;
	uint8_t lba23_16;
	uint8_t lba15_8;
	uint8_t lba7_0;
	uint8_t length31_24;
	uint8_t length23_16;
	uint8_t length15_8;
	uint8_t length7_0;
	uint8_t misc_info2;
	uint8_t ctrl;
}Atapi_cmmd12;

typedef struct{
	uint32_t opcode:8;
	uint32_t misc_info1:8;
	uint32_t lba49_56:8;
	uint32_t lba55_48:8;
	uint32_t lba47_40:8;
	uint32_t lba39_32:8;
	uint32_t lba31_24:8;
	uint32_t lba23_16:8;
	uint32_t lba15_8:8;
	uint32_t lba7_0:8;
	uint32_t length31_24:8;
	uint32_t length23_16:8;
	uint32_t length15_8:8;
	uint32_t length7_0:8;
	uint32_t misc_info2:8;
	uint32_t ctrl:8;
}Atapi_cmmd16;

#endif