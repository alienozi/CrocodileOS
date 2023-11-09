//a 32-bit error code library for COS
//author:Totan

#ifndef COSERR_H
#define COSERR_H

#include<stdint.h>

typedef uint32_t Status;
typedef uint32_t Error;

enum general_status{
	OK=0x00,
	ERROR=-0x01,
	RETRY=-0x02,
	
};

enum mem_err{
	NULL_PTR=-0x10,
	INV_PTR=-0x11,
	MEM_PROT=-0x12,
	MEM_BOUNDRY=-0x13,
	
};

enum file_err{
	INV_FILE=-0x30,		//name or descriptor
	FILE_PERM=-0x31,
	FILE_LOCKED=-0x32,
	UNSUPPORTED_FILE_OPT=-0x33,
	FILE_BOUNDRY=-0x34,
	
};

#endif