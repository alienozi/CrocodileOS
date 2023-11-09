#ifndef TASK_SEG_H
#define TASK_SEG_H

#include<stdint.h>

//#define SHADOW_STACK

typedef struct{
	uint16_t prev_task_link;
	uint16_t :16;
	void*	sp0;
	uint16_t ss0;
	uint16_t :16;
	void*	sp1;
	uint16_t ss1;
	uint16_t :16;
	void*	sp2;
	uint16_t ss2;
	uint16_t :16;
	union{				//has to be in first 4GB memory
		void* Pdpt_ptr;
		uint32_t cr3;
	};
	uint32_t eip;
	uint32_t eflags;
	uint32_t eax;
	uint32_t ecx;
	uint32_t edx;
	uint32_t ebx;
	uint32_t esp;
	uint32_t ebp;
	uint32_t esi;
	uint32_t edi;
	uint16_t es;
	uint16_t :16;
	uint16_t cs;
	uint16_t :16;
	uint16_t ss;
	uint16_t :16;
	uint16_t ds;
	uint16_t :16;
	uint16_t fs;
	uint16_t :16;
	uint16_t gs;
	uint16_t :16;
	uint16_t ldt_s;
	uint16_t :16;
	uint16_t T:1;
	uint16_t :15;
	uint16_t io_map_base;

#ifdef SHADOW_STACK
	void* ssp;
#endif

}Tss;

#endif