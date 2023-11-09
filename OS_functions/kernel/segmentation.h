#ifndef SEGMENTATION_H
#define SEGMENTATION_H

#include<stdint.h>
#include<stdatomic.h>

typedef struct{
	uint16_t rpl:2;
	uint16_t ti:1;	// 0:GDT 1:LDT
	uint16_t index:13;
}Seg_sel;

typedef struct{
	void* base;
	uint16_t limit; //8N-1
}Desc_reg;

typedef union{
		uint32_t desc[2];
	struct{
		uint8_t base_hilo:8;
		union{
			struct{
				uint8_t type:4;
				uint8_t s:1;
				uint8_t dpl:2;
				uint8_t p:1;
			}
			struct{
				uint8_t :1;
				uint8_t B:1;
				uint8_t :6;
			};
		};
		uint16_t limit_hi:4;
		uint16_t ignored:1;	//cpu ignores this bit os uses as lock	0:unlocked 1:locked
		uint16_t :1;
		uint16_t db:1;		//always set to 1 in 32 bit
		uint16_t g:1;
		uint16_t base_hihi:8;
		uint32_t limit_lo:16;
		uint32_t base_lo:16;
	};
}Seg_desc;

typedef union{
	uint8_t seg_type;
	struct{
		uint8_t type:4;
		uint8_t s:1;
		uint8_t dpl:2;
		uint8_t g:1;
	};
	struct{
		uint8_t :1;
		uint8_t B:1;
		uint8_t :6;
	};
}Seg_type;

void volatile load_seg_descriptor(Seg_desc* sd, void* base, uint32_t limit, Seg_type type){
	while(rare( atomic_fetch_or(&sd->desc[0], 1 << 20) & (1 << 20) ));	//try locking the seg descriptor
	sd->p = 0;

	atomic_thread_fence(memory_order_seq_cst);

	sd->base_lo = ((unsigned long int)base) & 0xFFFF;
	sd->base_hilo = (((unsigned long int)base) >> 16) & 0xFF;
	sd->base_hihi = (((unsigned long int)base) >> 24) & 0xFF;

	sd->limit_lo = limit & 0xFFFF;
	sd->limit_hi = (limit >> 16) & 0xF;

	sd->db = 1;
	sd->s = type.s;
	sd->dpl = type.dpl;
	sd->g = type.g;
	sd->type = type.type;

	atomic_thread_fence(memory_order_seq_cst);
	
	sd->p = 1;
}

#endif