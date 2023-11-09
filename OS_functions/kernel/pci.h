//a primative 32-bit pci library for COS
//author:Totan

#ifndef PCI_H
#define PCI_H

#include<stdint.h>
#include<stdbool.h>

#define CONFIG_ADDRESS 0xCF8
#define CONFIG_DATA 0xCFC

#define BASE_BAR_OFFSET 0x10

#define PCI_BUS_BAR5_OFFSET 0x24
typedef struct{
	uint32_t reg_off	: 8;
	uint32_t func_num	: 3;
	uint32_t device_num	: 5;
	uint32_t bus_num	: 8;
	uint32_t RESERVED	: 7;
	uint32_t enable		: 1;
}Pci_config_addr;

void static inline pci_set_conf_addr(Pci_config_addr* addr){
	asm inline volatile ("out dx, eax\n"::"a"( *((uint32_t*)addr) ),"d"(CONFIG_ADDRESS));
}
uint32_t static inline pci_read_config(){
	uint32_t u32_conf_reg_data;
	asm inline volatile ("in eax, dx\n":"=a"(u32_conf_reg_data):"d"(CONFIG_DATA));
	return u32_conf_reg_data;
}
void static inline pci_write_config(uint32_t u32_conf_reg_data){
	asm inline volatile ("out dx, eax\n"::"a"(u32_conf_reg_data),"d"(CONFIG_DATA));
}
uint32_t static inline pci_get_bar_size(Pci_config_addr* addr,uint32_t u32_bar_num){	//do not use for IO bars
	uint32_t u32_temp_bar,u32_mem_size;
	addr->reg_off = BASE_BAR_OFFSET + sizeof(uint32_t)*u32_bar_num;
	pci_set_conf_addr(addr);
	u32_temp_bar = pci_read_config();
	pci_write_config(0xFFFFFFFF);
	u32_mem_size = -(pci_read_config() & 0xFFFFFFF0);
	pci_write_config(u32_temp_bar);
	return u32_mem_size;
}
bool pci_search_dev(Pci_config_addr* conf_addr, uint32_t u32_signature, uint32_t u32_mask){

	conf_addr->func_num = 0;
	conf_addr->enable = 1;
	conf_addr->reg_off = 8;

	for(uint32_t i_bus=0; i_bus <= 0xFF; i_bus++){

		conf_addr->bus_num = i_bus;
		for(uint32_t i_dev=0; i_dev <= 0x1F; i_dev++){

			conf_addr->device_num = i_dev;
			pci_set_conf_addr(conf_addr);

			if( (pci_read_config()&u32_mask) == (u32_signature&u32_mask) ){
				return true;
			}

		}

	}
	return false;
}
typedef struct{
	uint16_t u16_device_ID;
	uint16_t u16_vendor_ID;
	uint16_t u16_status;
	uint16_t u16_command;
	uint8_t u8_class_code;
	uint8_t u8_subclass;
	uint8_t u8_prog_IF;
	uint8_t u8_revision_ID;
	uint8_t u8_bist;
	uint8_t u8_header_type;
	uint8_t u8_latency_timer;
	uint8_t u8_cache_line_size;
	uint32_t u32_BAR0;
	uint32_t u32_BAR1;
	uint32_t u32_BAR2;
	uint32_t u32_BAR3;
	uint32_t u32_BAR4;
	uint32_t u32_BAR5;
	uint32_t u32_cardbus_CIS_ptr;
	uint16_t u16_subsystem_ID;
	uint16_t u16_subsystem_vendor_ID;
	uint32_t u32_e_ROM_BA;
	uint8_t RESERVED[3];
	uint8_t u8_cap_ptr;
	uint32_t RESERVED2;
	uint8_t u8_max_latency;
	uint8_t u8_min_grant;
	uint8_t u8_interrupt_pin;
	uint8_t u8_interrupt_line;
} pci_header_type_0;
#endif