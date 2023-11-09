//a 32-bit standard macro library for COS
//author:Totan

#ifndef COSDEF_H
#define COSDEF_H

#define NULL ((void*) 0x0)

#ifndef PAGE_SIZE

#define PAGE_SIZE 4096

#endif

#ifndef CLS
//cache line size
#define CLS 32

#endif

#define ADD_OFFSET_TO_PTR(PTR, OFFSET)	(( (typeof(PTR)) ( ( (char*) PTR ) + ((unsigned long int)OFFSET) ) ))
//ALIGNMENT SIZE  MUST BE POWER OF 2
#define ALLIGN_PTR(PTR, SIZE)	(( typeof(PTR) ) ( ( (long) PTR ) + (( -( (long) PTR ) ) & (SIZE - 1))) )

#define COS_switch(a,b) asm volatile("xchg %0, %1\n":"+r"(a), "+r"(b))

#define rare(cond) __builtin_expect( (cond), 0)
#define common(cond) __builtin_expect( (cond), 1)

#endif