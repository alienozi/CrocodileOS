#ifndef BIOS_MMAP_H
#define BIOS_MMAP_H

typedef struct{
	union{
		struct{
			uint64_t base;
			uint64_t length;
		};
		struct{
			uint32_t base_l;
			uint32_t base_h;
			uint32_t length_l;
			uint32_t length_h;
		};
	};
	uint32_t type;
	uint32_t :32;
}bios_mmap_entry;

#define BIOS_MEM_TYPE_USABLE_RAM	1
#define BIOS_MEM_TYPE_UNUSABLE		2
#define BIOS_MEM_TYPE_ACPI_RECLAIMABLE	3
#define BIOS_MEM_TYPE_ACPI_NVS		4
#define BIOS_MEM_TYPE_BAD		5

#endif