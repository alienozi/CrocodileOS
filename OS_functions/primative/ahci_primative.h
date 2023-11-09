//a primative ahci library for COS bootloader
//author:Totan
#ifndef AHCI_PRIMATIVE_H
#define AHCI_PRIMATIVE_H

#include<stdbool.h>
#include<kernel/sata.h>
#include<kernel/ahci.h>
#include<primative/primative.h>
void pri_identify_atapi_dev(Ahci_dev_ctrl* sata_dev, uint16_t* ui16_dev_info){
	Fis_reg_h2d fis;
	Prdt_entry prdt;
	uint32_t cmmd_options = 0;
	uint32_t busy_count = 0;
	ahci_stop_cmd(sata_dev);

	pri_fill(&fis, 0, sizeof(Fis_reg_h2d));
	fis.type = FIS_TYPE_REG_H2D;
	fis.command = 0xa1;
	fis.device = 0;
	fis.c = 1;
	fis.lower_features = 1;

	ahci_set_fis(sata_dev, 0, &fis);

	pri_fill(&prdt, 0, sizeof(Prdt_entry));
	prdt.dba = ui16_dev_info;
	prdt.dbc = 512 - 1;
	prdt.i = 1;

	ahci_set_prdt(sata_dev, 0, &prdt, 1);

	cmmd_options |= AHCI_CMMD_OPTION_CLEAR_BUSY;

	ahci_set_cmmd_options(sata_dev, 0, cmmd_options);

	ahci_start_cmd(sata_dev);
	ahci_issue_cmmd(sata_dev, 0);

	while(ahci_is_cmmd_running(sata_dev)){
		busy_count++;
	}
}
void pri_read_atapi_dev(Ahci_dev_ctrl* sata_dev, uint16_t* ui16p_dev_data, uint32_t ui32_lba, uint32_t ui32_sector_count){
	Fis_reg_h2d fis;
	Prdt_entry prdt;
	Atapi_cmmd12 atapi_cmmd;

	uint32_t cmmd_options = 0;
	ahci_stop_cmd(sata_dev);

	pri_fill(&fis, 0, sizeof(Fis_reg_h2d));
	fis.type = FIS_TYPE_REG_H2D;
	fis.command = 0xa0;
	fis.device = 0;
	fis.c = 1;
	fis.lower_features = 1;			//Transfer is a DMA transfer to host
	fis.lower_lba = 2 << 8;			//Transfer size is larger than 2 bytes

	ahci_set_fis(sata_dev, 0, &fis);

	pri_fill(&prdt, 0, sizeof(Prdt_entry));
	prdt.dba = ui16p_dev_data;
	prdt.dbc = (ui32_sector_count << 11) - 1;
	prdt.i = 1;

	ahci_set_prdt(sata_dev, 0, &prdt, 1);

	pri_fill(&atapi_cmmd, 0, sizeof(Atapi_cmmd12));
	atapi_cmmd.opcode = 0xA8;
	atapi_cmmd.lba31_24 = ui32_lba >> 24;
	atapi_cmmd.lba23_16 = (ui32_lba >> 16) & 0xFF;
	atapi_cmmd.lba15_8 = (ui32_lba >> 8) & 0xFF;
	atapi_cmmd.lba7_0 = ui32_lba & 0xFF;

	atapi_cmmd.length31_24 = ui32_sector_count >> 24;
	atapi_cmmd.length23_16 = (ui32_sector_count >> 16) & 0xFF;
	atapi_cmmd.length15_8 = (ui32_sector_count >> 8) & 0xFF;
	atapi_cmmd.length7_0 = ui32_sector_count & 0xFF;

	ahci_set_atapi(sata_dev, 0, &atapi_cmmd);

	cmmd_options |= AHCI_CMMD_OPTION_CLEAR_BUSY;
	cmmd_options |= AHCI_CMMD_OPTION_ATAPI;

	ahci_set_cmmd_options(sata_dev, 0, cmmd_options);

	
	ahci_start_cmd(sata_dev);
	ahci_issue_cmmd(sata_dev, 0);
	//for(uint32_t i=0xFFFFFFFF;i>0;i--)asm inline volatile("nop\n");
	while(ahci_is_cmmd_running(sata_dev));
}
void pri_dev_info_print(char c_font, uint16_t* ui16p_dev_info){
	pri_print(c_font, "Mass Storage Device Serial Number:");
	for(uint32_t i = ATAPI_IDENTIFY_SERIAL_NUMBER_WOFFSET; i < ATAPI_IDENTIFY_SERIAL_NUMBER_WOFFSET + ATAPI_IDENTIFY_SERIAL_NUMBER_LENGTH; i++){
		pri_print(c_font,"%c%c", ui16p_dev_info[i]>>8, ui16p_dev_info[i]&0xFF);
	}
	pri_print(c_font, "\nMass Storage Device Firmware Version:");
	for(uint32_t i = ATAPI_IDENTIFY_FIRMWARE_VERSION_WOFFSET; i < ATAPI_IDENTIFY_FIRMWARE_VERSION_WOFFSET + ATAPI_IDENTIFY_FIRMWARE_VERSION_LENGTH; i++){
		pri_print(c_font,"%c%c", ui16p_dev_info[i]>>8, ui16p_dev_info[i]&0xFF);
	}
	pri_print(c_font, "\nMass Storage Device Model Number:");
	for(uint32_t i = ATAPI_IDENTIFY_MODEL_NUMBER_WOFFSET; i < ATAPI_IDENTIFY_MODEL_NUMBER_WOFFSET + ATAPI_IDENTIFY_MODEL_NUMBER_LENGTH; i++){
		pri_print(c_font,"%c%c", ui16p_dev_info[i]>>8, ui16p_dev_info[i]&0xFF);
	}
	pri_print(c_font,"\n");
}
#endif