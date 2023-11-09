//a 32-bit process library for COS kernel
//author:Totan

#ifndef PROCESS_H
#define PROCESS_H

#include<stdint.h>
#include<kernel/spinlock.h>
#include<kernel/segmentation.h>

typedef struct{
	Process* first;
	spinlock_t first_lock;
	Process* last;
	spinlock_t last_lock;
}Process_list_header;

typedef Process_list_header wait_queue;

typedef struct{		//TODO: add tss
	uint8_t state;
	Process* parent;
	Process_list_header relative_list;		//other childs of its parent
	Process_list_header eff_child_list;		//threads that cant run simultaniously (to reduce paging overhead)	#default
	Process_list_header perf_child_list;		//threads that can run simultaniously (for performance)
}Process


#endif