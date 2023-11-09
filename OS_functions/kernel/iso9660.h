//a 32-bit iso9660 data structure library for COS
//author:Totan

#ifndef ISO9660_H
#define ISO9660_H

#include<stdint.h>

typedef struct{
	char	year[4];
	char	month[4];
	char	day[4];
	char	hour[4];
	char	minute[4];
	char	second[4];
	char	fraction_of_second[2];
	uint8_t time_zone;	//resolution: 15 min	offset: -48
}Iso9660_descriptor_date_format;

typedef struct{
	uint8_t	year;
	uint8_t	month;
	uint8_t	day;
	uint8_t	hour;
	uint8_t	minute;
	uint8_t	second;
	uint8_t time_zone;	//resolution: 15 min	offset: -48
}Iso9660_directory_date_format;
typedef struct{
	uint8_t type;
	char	identifier[5];
	uint8_t version;
}Iso9660_volume_descriptor_header;

typedef struct{
	uint8_t length;
	uint8_t ext_attr_length;
	uint16_t ext_lba_low;
	uint16_t ext_lba_high;
	uint16_t :16;
	uint16_t :16;
	uint16_t ext_data_length_low;
	uint16_t ext_data_length_high;
	uint16_t :16;
	uint16_t :16;
	Iso9660_directory_date_format date;
	uint8_t flags;
	uint8_t :8;
	uint8_t :8;
	uint16_t volume_sequence_number;
	uint16_t :16;
	uint8_t file_identifier_length;
	char	file_identifier[1];
}Iso9660_directory_record;

typedef struct{
	Iso9660_volume_descriptor_header header;
	char boot_system_identiﬁer[32];
	char boot_identiﬁer[32];
}Iso9660_boot_record;

typedef struct{
	Iso9660_volume_descriptor_header header;
	uint8_t :8;
	char system_identiﬁer[32];
	char volume_identiﬁer[32];
	uint32_t :32;
	uint32_t :32;
	uint32_t volume_space_size;
	uint32_t :32;
	uint8_t RESERVED[32];
	uint16_t volume_set_size;
	uint16_t :16;
	uint16_t volume_sequence_number;
	uint16_t :16;
	uint16_t logical_block_size;
	uint16_t :16;
	uint32_t path_table_size;
	uint32_t :32;
	uint32_t path_table_location;
	uint32_t optimal_path_table_location;
	uint32_t :32;
	uint32_t :32;
	Iso9660_directory_record root_record;
	uint8_t	:8;
	char	volume_set_identiﬁer[128];
	char	publisher_identiﬁer[128];
	char	data_preparer_identiﬁer[128];
	char	application_identiﬁer[128];
	char	copyright_file_identiﬁer[37];
	char	abstract_file_identiﬁer[37];
	char	bibliographic_file_identiﬁer[37];
	Iso9660_descriptor_date_format creation_date;
	Iso9660_descriptor_date_format modification_date;
	Iso9660_descriptor_date_format expiration_date;
	Iso9660_descriptor_date_format effective_date;
	uint8_t	file_structure_version;
}Iso9660_primary_volume_descriptor;

#define ISO9660_SECTOR_SIZE			2048

#define BOOT_RECORD				0
#define PRIMARY_VOLUME_DESCRIPTOR		1
#define	SUPPLEMENTARY_VOLUME_DESCRIPTOR		2
#define VOLUME_PARTITION_DESCRIPTOR		3
#define VOLUME_DESCRIPTOR_SET_TERMINATOR	255

#endif