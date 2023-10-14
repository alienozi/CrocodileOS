#ifndef LE_AHCI
#define LE_AHCI
#include<stdint.h>
#include<stdbool.h>
#include<stdatomic.h>

#include<le_pci.h>
#include<le_sata.h>
#include<cosdef.h>
#define FIS_TYPE_REG_H2D 0x27
#define FIS_TYPE_REG_D2H 0x34
#define FIS_TYPE_DMA_D2H 0x39
#define FIS_TYPE_DMA_SETUP 0x41
#define FIS_TYPE_DATA 0x46


#define AHCI_PCI_SIG 0x01060100
#define AHCI_PCI_SIG_MASK 0xFFFFFF00

#define AHCI_PORT_CMD_CR_MASK			(1 << 15)
#define AHCI_PORT_CMD_FR_MASK			(1 << 14)
#define AHCI_PORT_CMD_FRE_MASK			(1 << 4)
#define AHCI_PORT_CMD_ST_MASK			(1 << 0)

#define AHCI_CMMD_OPTION_ATAPI			(1 << 0)
#define AHCI_CMMD_OPTION_WRITE			(1 << 1)
#define AHCI_CMMD_OPTION_PREFETCHABLE		(1 << 2)
#define AHCI_CMMD_OPTION_RESET			(1 << 3)
#define AHCI_CMMD_OPTION_BIST			(1 << 4)
#define AHCI_CMMD_OPTION_CLEAR_BUSY		(1 << 5)

#define AHCI_CMMD_OPTION_MASK			0x7BF

#define CPD_INT					(1 << 31)
#define TFE_INT					(1 << 30)
#define HBFE_INT				(1 << 29)
#define HBDE_INT				(1 << 28)
#define IFE_INT					(1 << 27)
#define INFE_INT				(1 << 26)
#define OFE_INT					(1 << 24)
#define IPM_INT					(1 << 23)
#define PRC_INT					(1 << 22)
#define DMP_INT					(1 << 7)
#define PC_INT					(1 << 6)
#define DP_INT					(1 << 5)
#define UF_INT					(1 << 4)
#define SDB_INT					(1 << 3)
#define DS_INT					(1 << 2)
#define PS_INT					(1 << 1)
#define DHR_INT					(1 << 0)

#define ALL_INT		0xFFC000FF

#define AHCI_NUM_OF_MAX_DEVICE 32

#define IDENTIFY_PACKET_DEVICE 0xA1

#define PORT_REG_OFFSET (0x100/4)
typedef struct{
	uint32_t type:8;
	uint32_t pm:4;
	uint32_t :3;
	uint32_t c:1;
	uint32_t command:8;
	uint32_t lower_features:8;
	uint32_t lower_lba:24;
	uint32_t device:8;
	uint32_t upper_lba:24;
	uint32_t upper_features:8;
	uint32_t count:16;
	uint32_t icc:8;
	uint32_t control:8;
	uint32_t auxiliary:16;
	uint32_t :16;

}Fis_reg_h2d;

typedef struct{
	uint16_t*	dba;		//data base address
	uint32_t	:32;		//not used in 32 bits
	uint32_t	:32;		//ahci reserved
	uint32_t	dbc:22;		//data byte count
	uint32_t	:9;		//ahci reserved
	uint32_t	i:1;		//interrupt on completion
}Prdt_entry;
typedef struct{
	
	union{
		uint32_t fis[16];
		struct{
			Fis_reg_h2d h2d_fis;
			uint32_t Reserved[11];
		 };
	};
	union{
		Atapi_cmmd16 atapi_cmmd16;
		struct{
			Atapi_cmmd12 atapi_cmmd12;
			uint32_t :32;
		};
	};
	uint8_t RESERVED[0x30];				//ahci reserved
	Prdt_entry prdt[1];
}Cmmd_table;
typedef struct{
	union{
		struct{
			uint32_t cfl:5;			//command fis length
			uint32_t a:1;			//atapi
			uint32_t w:1;			//write
			uint32_t p:1;			//prefetchable
			uint32_t r:1;			//reset
			uint32_t b:1;			//bist
			uint32_t c:1;			//makes hba clear the busy bit after revieve of the r_ok
			uint32_t :1;			//ahci reserved
			uint32_t pmp:4;			//for port multiplier
			uint32_t prdt_length:16;	//prdt length in prdt entries
		};
		struct{
			uint32_t :5;
			uint32_t options:6;
			uint32_t :21;
		};
	};


	uint32_t prdbc;			//prd byte count
	Cmmd_table* cmmd_table;		//128 byte alligned

	uint32_t :32;			//not used in 32 bit
	uint32_t RESERVED[4];		//ahci reserved
}Cmmd_header;
typedef struct{
	Cmmd_header* 		clb;
	uint32_t 		:32;		//not used in 32 bit
	void*			fb;
	uint32_t 		:32;		//not used in 32 bit
	uint32_t		is;
	uint32_t		ie;
	uint32_t		cmd;
	uint32_t		:32;		//ahci reserved
	uint32_t		tfd;
	uint32_t		sig;
	uint32_t		ssts;
	uint32_t		sctl;
	uint32_t		serr;
	uint32_t		sact;
	uint32_t		ci;
	uint32_t		sntf;
	uint8_t			RESERVED[0x40];
}Ahci_port_ctrl;
typedef struct{
	uint32_t cap;
	uint32_t ghc;
	uint32_t is;
	uint32_t pi;
	uint32_t vr;
	uint32_t ccc_ctrl;
	uint32_t ccc_ports;
	uint32_t em_loc;
	uint32_t em_ctrl;
	uint8_t	RESERVED[0xDC];
	Ahci_port_ctrl port[1];
}Ahci_ctrl;
typedef struct{
	Ahci_ctrl* ahci_base;
	uint8_t port_id;
	uint8_t cmmd_slot_count;
	bool atapi;	
}Ahci_dev_ctrl;

bool ahci_scan_port(Ahci_ctrl* ahci_base, Ahci_dev_ctrl* dev, uint8_t ui8_start_id, uint32_t ui32_sig){
	for(uint8_t i_id = ui8_start_id; i_id < AHCI_NUM_OF_MAX_DEVICE; i_id++){
		if(ahci_base->port[i_id].sig == ui32_sig){
			dev->ahci_base = ahci_base;
			dev->port_id = i_id;
			dev->atapi = (ui32_sig == ATAPI_SIGNATURE);
			dev->cmmd_slot_count = ( (ahci_base->cap >> 8) & 0x1F ) + 1;
			return true;
		}
	}
	return false;
}
#define BUSY_WAIT_COUNT		10000000
bool ahci_start_cmd(Ahci_dev_ctrl* dev){
	dev->ahci_base->port[dev->port_id].is = -1;

	while(dev->ahci_base->port[dev->port_id].cmd & AHCI_PORT_CMD_CR_MASK);

	dev->ahci_base->port[dev->port_id].cmd |= AHCI_PORT_CMD_ST_MASK;
		
	while((dev->ahci_base->port[dev->port_id].cmd & AHCI_PORT_CMD_CR_MASK) == 0);

	return true;
}

bool ahci_start_fr(Ahci_dev_ctrl* dev){

	dev->ahci_base->port[dev->port_id].cmd |= AHCI_PORT_CMD_FRE_MASK;

	while((dev->ahci_base->port[dev->port_id].cmd & AHCI_PORT_CMD_FR_MASK) == 0)

	return true;
}

bool ahci_stop_cmd(Ahci_dev_ctrl* dev){
	dev->ahci_base->port[dev->port_id].cmd &= ~AHCI_PORT_CMD_ST_MASK;
	while(dev->ahci_base->port[dev->port_id].cmd & AHCI_PORT_CMD_CR_MASK);
	return true;
}

bool ahci_stop_fr(Ahci_dev_ctrl* dev){
	dev->ahci_base->port[dev->port_id].cmd &= ~AHCI_PORT_CMD_FRE_MASK;
	while(dev->ahci_base->port[dev->port_id].cmd & AHCI_PORT_CMD_FRE_MASK);
	return true;
}
void ahci_set_fis(Ahci_dev_ctrl* dev, uint8_t ui8_cmmd_slot, Fis_reg_h2d* fis){
	Cmmd_header* cmmd_header;
	cmmd_header = &dev->ahci_base->port[dev->port_id].clb[ui8_cmmd_slot];
	
	asm inline volatile("rep movsd\n"::"D"(&cmmd_header->cmmd_table->h2d_fis), "S"(fis), "c"((uint32_t) (sizeof(Fis_reg_h2d)/sizeof(uint32_t))));
	cmmd_header->cfl = sizeof(Fis_reg_h2d)/sizeof(uint32_t);
	cmmd_header->prdbc = 0;
}
void ahci_set_prdt(Ahci_dev_ctrl* dev, uint8_t ui8_cmmd_slot, Prdt_entry* prdt_list, uint16_t ui16_prdt_len){
	Cmmd_header* cmmd_header;
	cmmd_header = &dev->ahci_base->port[dev->port_id].clb[ui8_cmmd_slot];

	asm inline volatile("rep movsd\n"::"D"(cmmd_header->cmmd_table->prdt), "S"(prdt_list), "c"((uint32_t) (sizeof(Prdt_entry)*ui16_prdt_len/sizeof(uint32_t))));
	cmmd_header->prdt_length = ui16_prdt_len;
	cmmd_header->prdbc = 0;
}
void ahci_set_atapi(Ahci_dev_ctrl* dev, uint8_t ui8_cmmd_slot, void* Atapi_cmmd){
	Cmmd_header* cmmd_header;
	cmmd_header = &dev->ahci_base->port[dev->port_id].clb[ui8_cmmd_slot];

	asm inline volatile("rep movsd\n"::"D"(&cmmd_header->cmmd_table->atapi_cmmd12), "S"(Atapi_cmmd), "c"((uint32_t) (sizeof(Atapi_cmmd12)/sizeof(uint32_t))));
}
void ahci_set_cmmd_options(Ahci_dev_ctrl* dev, uint8_t ui8_cmmd_slot, uint8_t ui8_options){
	Cmmd_header* cmmd_header;
	cmmd_header = &dev->ahci_base->port[dev->port_id].clb[ui8_cmmd_slot];
	
	cmmd_header->options = ui8_options;
}
void ahci_issue_cmmd(Ahci_dev_ctrl* dev, uint8_t ui8_cmmd_slot){
	dev->ahci_base->port[dev->port_id].ci |= (1 << ui8_cmmd_slot);
}
bool ahci_is_cmmd_running(Ahci_dev_ctrl* dev){
	return (dev->ahci_base->port[dev->port_id].ci != 0);
}
void ahci_rebase_cmd_slot(Ahci_dev_ctrl* dev, Cmmd_header* cmmd_list_base, void* fis_base){
	dev->ahci_base->port[dev->port_id].clb = cmmd_list_base;
	dev->ahci_base->port[dev->port_id].fb = fis_base;
}
#endif