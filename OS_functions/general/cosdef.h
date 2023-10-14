#ifndef COSDEF
#define COSDEF

#define NULL ((void*) 0x0)
#define ADD_OFFSET_TO_PTR(PTR, OFFSET)	( (typeof(PTR)) ( ( (char*) PTR ) + ((unsigned long int)OFFSET) ) )

#endif