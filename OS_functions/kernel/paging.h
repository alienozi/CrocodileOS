//32 bit paging data structure library for COS
//author:Totan
#ifndef PAGING_H
#define PAGING_H

#ifndef PAGE_SIZE

#define PAGE_SIZE 4096

#endif

#define PHY_ADDR_TO_PAGE_INDEX(ADDR)	( (ADDR) / PAGE_SIZE )
#define PAGE_INDEX_TO_PHY_ADDR(PAGE_INDEX)	( (PAGE_INDEX) * PAGE_SIZE )

#include<stdint.h>
#include<spinlock.h>

//x86 structures for paging

typedef union{
	struct{
		uint32_t P:1;
		uint32_t :2;
		uint32_t PWT:1;
		uint32_t PCD:1;
		uint32_t :4;
		uint32_t p_ignored:3;
		uint32_t :20;
		uint32_t :32;
	};
	struct{
		uint64_t :12;
		uint64_t page_index:40;		//4KB
		uint64_t :12;
	};
	struct{
		uint64_t :1;
		uint64_t np_ignored:63;
	};
	uint64_t entry;
}Pdpt_entry;

typedef union{
	struct{
		uint32_t P:1;
		uint32_t W:1;
		uint32_t U:1;
		uint32_t PWT:1;
		uint32_t PCD:1;
		uint32_t A:1;
		uint32_t D:1;
		uint32_t PS:1;
		uint32_t G:1;
		uint32_t p_ignored:3;
		uint32_t :20;
		uint32_t :31;
		uint32_t XD:1;
	};
	struct{
		uint64_t :12;
		uint64_t :1;
		uint64_t :8;
		uint64_t long_page_index:31;	//2MB
		uint64_t :12;
	};
	struct{
		uint64_t :12;
		uint64_t page_index:40;
		uint64_t :12;
	};
	struct{
		uint64_t :1;
		uint64_t np_ignored:63;
	};
	uint64_t entry;
}Pd_entry;

typedef union{
	struct{
		uint32_t P:1;
		uint32_t W:1;
		uint32_t U:1;
		uint32_t PWT:1;
		uint32_t PCD:1;
		uint32_t A:1;
		uint32_t D:1;
		uint32_t :1;
		uint32_t G:1;
		uint32_t p_ignored:3;
		uint32_t :20;
		uint32_t :31;
		uint32_t XD:1;
	};
	struct{
		uint64_t :12;
		uint64_t page_index:40;		//4KB
		uint64_t :12;
	};
	struct{
		uint64_t :1;
		uint64_t np_ignored:63;
	};
	uint64_t entry;
}Pt_entry;

//COS structures for paging

#define NULL_PAGE	0	//not specified yet
#define MEM_MAPED_PAGE	1	//ram
#define REG_MAPED_PAGE	2	//pci device, apic, etc.
#define RESERVED_PAGE	3	//not maped yet but reserved for later use (dma, etc.)

#define ILLEGAL_PAGE	0xFF	//not available

typedef struct{
	spinlock_t lock;
	uint32_t count;		//number of processes that holds an entry
	void*	vaddr;			//vaddr if its kernel mapped
	uint16_t status:15;
	uint16_t eom:1;
	uint16_t :16;		//not used yet
}page_entry;

#endif