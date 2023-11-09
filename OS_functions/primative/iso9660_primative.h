//a primative iso9660 file system library for COS bootloader
//author:Totan
#ifndef ISO9660_PRIMATIVE_H
#define ISO9660_PRIMATIVE_H

#include<general/cosdef.h>
#include<kernel/iso9660.h>

#include<primative/ahci_primative.h>
//dest must have a size of multiple of 2k
//note: this is a very primative function so it does not support all likely possible
//	extreme cases, such as a directory larger than one sector
//		so user should keep that in mind
static uint16_t temp_dir_data[2 * ISO9660_SECTOR_SIZE / sizeof(uint16_t)];
int32_t pri_iso9660_file_read(Ahci_dev_ctrl* sata_dev, void* dest, const char* file_path){
	uint32_t lba = 16;
	uint32_t sector_count = 1;
	bool name_match;
	Iso9660_primary_volume_descriptor* pri_des = (Iso9660_primary_volume_descriptor*) temp_dir_data;
	Iso9660_directory_record* dir_record = &pri_des->root_record;
	while(pri_des->header.type != 0xFF && pri_des->header.type != 0x01){
		pri_read_atapi_dev(sata_dev, temp_dir_data, lba, sector_count);
		lba++;
	}
	if(pri_des->header.type == 0xFF){
		return -1;
	}
	while(*file_path){
		file_path = ADD_OFFSET_TO_PTR(file_path, 1);
		lba = (((uint32_t)dir_record->ext_lba_high) << 16) + dir_record->ext_lba_low;
		sector_count = (((uint32_t)dir_record->ext_data_length_high) << 16) + dir_record->ext_data_length_low;
		sector_count /= ISO9660_SECTOR_SIZE;

		pri_read_atapi_dev(sata_dev, temp_dir_data, lba, sector_count);

		dir_record = (Iso9660_directory_record*) temp_dir_data;
		dir_record = ADD_OFFSET_TO_PTR(dir_record, dir_record->length);
		dir_record = ADD_OFFSET_TO_PTR(dir_record, dir_record->length);

		while(dir_record->length){

			name_match = pri_cmp(file_path, dir_record->file_identifier, dir_record->file_identifier_length);
			if(name_match){
				name_match = (file_path[dir_record->file_identifier_length] == '/' || file_path[dir_record->file_identifier_length] == 0);
			}
			if(name_match){
				file_path = ADD_OFFSET_TO_PTR(file_path, dir_record->file_identifier_length);
				break;
			}
			dir_record = ADD_OFFSET_TO_PTR(dir_record, dir_record->length);
		}
		if(dir_record->length == 0) return -1;
	}

	lba = (((uint32_t)dir_record->ext_lba_high) << 16) + dir_record->ext_lba_low;
	sector_count = (((uint32_t)dir_record->ext_data_length_high) << 16) + dir_record->ext_data_length_low;
	sector_count += (sector_count % ISO9660_SECTOR_SIZE) ? ISO9660_SECTOR_SIZE : 0 ;

	sector_count /= ISO9660_SECTOR_SIZE;
	pri_read_atapi_dev(sata_dev, dest, lba, sector_count);
	return (((uint32_t)dir_record->ext_data_length_high) << 16) + dir_record->ext_data_length_low;
}

#endif