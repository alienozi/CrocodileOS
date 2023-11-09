#include<stdlib.h>
#include<stdint.h>

#include<fstream>
#include<filesystem>
#include<iostream>
#include<string.h>

#include<shrek.h>
static char filler[] = {0,0,0,0,0,0,0,0};
int main(int argn, char** argv){
    int rodata_size, data_size, text_size, func_size, bss_size, output_size;
    int section_count = 0;
    std::fstream func_file, rodata_file, data_file, text_file, output_file;
    std::string output_filename, func_name;

    uint8_t *output_binary, *section_buffer;
    uint32_t  vaddr,func_addr,func_offset,cursor,eb_cursor,section_buffer_size;

    Shrek_main_header* shrek_header;
    Shrek_eb_header* eb_header;
    Shrek_eb_section_entry* eb_entries;
    Shrek_eb_function_entry* func_entries;
    char* string_table;

    func_size = atoi(argv[1]);
    text_size = std::filesystem::file_size(argv[4]);
    data_size = std::filesystem::file_size(argv[5]);
    rodata_size = std::filesystem::file_size(argv[6]);
    bss_size = atoi(argv[2]);

    func_file.open(argv[3], std::fstream::in);
    text_file.open(argv[4], std::fstream::in | std::fstream::binary);
    data_file.open(argv[5], std::fstream::in | std::fstream::binary);
    rodata_file.open(argv[6], std::fstream::in | std::fstream::binary);
    output_file.open(argv[7], std::fstream::out | std::fstream::binary | std::fstream::trunc);

    output_filename = argv[7];

    vaddr = atoi(argv[8]);

    output_size = sizeof(Shrek_main_header) + sizeof(Shrek_eb_header);
    section_buffer_size = 0;
    if(text_size){
        output_size += sizeof(Shrek_eb_section_entry);
        section_count++;
        section_buffer_size = text_size;
    }
    if(data_size){
        output_size += sizeof(Shrek_eb_section_entry);
        section_count++;
        if(data_size > section_buffer_size)section_buffer_size = data_size;
    }
    if(bss_size){
        output_size += sizeof(Shrek_eb_section_entry);
        section_count++;
    }
    if(rodata_size){
        output_size += sizeof(Shrek_eb_section_entry);
        section_count++;
        if(rodata_size > section_buffer_size)section_buffer_size = rodata_size;
    }

    output_size += sizeof(Shrek_eb_function_entry)*func_size;

    output_binary = new uint8_t[output_size];
    section_buffer = new uint8_t[section_buffer_size];

    if(!(func_file.is_open() && text_file.is_open() && data_file.is_open() && rodata_file.is_open() && output_file.is_open() && output_binary != NULL && section_buffer != NULL)){
        if(func_file.is_open()) func_file.close();
        if(text_file.is_open()) text_file.close();
        if(data_file.is_open()) data_file.close();
        if(rodata_file.is_open()) rodata_file.close();
        if(output_file.is_open()) output_file.close();
        if(output_binary != NULL) delete[] output_binary;
        if(section_buffer != NULL) delete[] section_buffer;
        printf("missign file or incorrect argument\n");
        return -1;
    }
    shrek_header = (Shrek_main_header*) output_binary;
    eb_header =  (Shrek_eb_header*) &output_binary[sizeof(Shrek_main_header)];
    eb_entries = (Shrek_eb_section_entry*) &output_binary[sizeof(Shrek_main_header) + sizeof(Shrek_eb_header)];
    func_entries = (Shrek_eb_function_entry*) &output_binary[sizeof(Shrek_main_header) + sizeof(Shrek_eb_header) + sizeof(Shrek_eb_section_entry) * section_count];

    cursor = 0;

    *shrek_header = NULL_SHREAK_HEADER;
    shrek_header->num_of_eb = 1;
    shrek_header->num_of_func = func_size;
    shrek_header->eb_entry_offset = (long int) eb_header - (long int) output_binary;
    shrek_header->func_entry_offset = (long int) func_entries - (long int) output_binary;
    shrek_header->string_table_offset = output_size;

    *eb_header = NULL_EB_HEADER;
    eb_header->name_offset = cursor;
    eb_header->type = SHREK_LOCAL;
    eb_header->vaddr = vaddr;
    eb_header->size = (text_size&4095)?(text_size & ~4095) + 4096 :text_size;
    eb_header->size += ((bss_size + data_size)&4095)?((bss_size + data_size)& ~4095)+ 4096 :(bss_size + data_size);
    eb_header->size += (rodata_size&4095)?(rodata_size & ~4095)+ 4096 :rodata_size;
    eb_header->size += 4096 * (section_count - 1);
    eb_header->first_func_index =  0;
    eb_header->num_of_func = func_size;
    eb_header->header_size = sizeof(Shrek_eb_header);
    eb_header->num_of_section = section_count;

    cursor += output_filename.substr(output_filename.find_last_of('/')+1,output_filename.find_last_of('.')).length()+1;

    for(int i=0; i < func_size; i++){
        func_file >> func_name >> std::hex >> func_addr;
        func_offset = func_addr - vaddr;

        func_entries[i].name = cursor;
        func_entries[i].EB_ID = 0;
        func_entries[i].EB_offset = func_offset;

        cursor += func_name.length() + 1;
    }
    func_file.seekg(0,std::fstream::beg);
    cursor += shrek_header->string_table_offset;
    cursor = (cursor & 7)? (cursor & ~7) + 8: cursor;
    eb_cursor = 0;
    if(text_size){
        eb_entries[eb_cursor].type = SHREK_TEXT;
        eb_entries[eb_cursor].data_offset = cursor;
        eb_entries[eb_cursor].size = text_size;
        eb_entries[eb_cursor].write_permision = SHREK_PERMISSION_NOTALLOWED;
        eb_entries[eb_cursor].execute_permision = SHREK_PERMISSION_ALLOWED;
        eb_entries[eb_cursor].share_permision = SHREK_PERMISSION_NOTALLOWED;
        eb_entries[eb_cursor].share_main_permisions = SHREK_PERMISSION_NOTALLOWED;

        eb_cursor++;
        cursor += text_size;
        cursor = (cursor & 7)? (cursor & ~7) + 8: cursor;
    }
    if(data_size){
        eb_entries[eb_cursor].type = SHREK_DATA;
        eb_entries[eb_cursor].data_offset = cursor;
        eb_entries[eb_cursor].size = data_size;
        eb_entries[eb_cursor].write_permision = SHREK_PERMISSION_ALLOWED;
        eb_entries[eb_cursor].execute_permision = SHREK_PERMISSION_NOTALLOWED;
        eb_entries[eb_cursor].share_permision = SHREK_PERMISSION_NOTALLOWED;
        eb_entries[eb_cursor].share_main_permisions = SHREK_PERMISSION_NOTALLOWED;

        eb_cursor++;
        cursor += data_size;
        cursor = (cursor & 7)? (cursor & ~7) + 8: cursor;
    }
    if(bss_size){
        eb_entries[eb_cursor].type = SHREK_BSS;
        eb_entries[eb_cursor].data_offset = 0;
        eb_entries[eb_cursor].size = bss_size;
        eb_entries[eb_cursor].write_permision = SHREK_PERMISSION_ALLOWED;
        eb_entries[eb_cursor].execute_permision = SHREK_PERMISSION_NOTALLOWED;
        eb_entries[eb_cursor].share_permision = SHREK_PERMISSION_NOTALLOWED;
        eb_entries[eb_cursor].share_main_permisions = SHREK_PERMISSION_NOTALLOWED;

        eb_cursor++;
    }
    if(rodata_size){
        eb_entries[eb_cursor].type = SHREK_RODATA;
        eb_entries[eb_cursor].data_offset = cursor;
        eb_entries[eb_cursor].size = rodata_size;
        eb_entries[eb_cursor].write_permision = SHREK_PERMISSION_NOTALLOWED;
        eb_entries[eb_cursor].execute_permision = SHREK_PERMISSION_NOTALLOWED;
        eb_entries[eb_cursor].share_permision = SHREK_PERMISSION_NOTALLOWED;
        eb_entries[eb_cursor].share_main_permisions = SHREK_PERMISSION_NOTALLOWED;

        eb_cursor++;
        cursor += rodata_size;
        cursor = (cursor & 7)? (cursor & ~7) + 8: cursor;
    }
    output_file.write((char*)output_binary, output_size);
    cursor = output_size;

    output_file << output_filename.substr(output_filename.find_last_of('/')+1,output_filename.find_last_of('.')) << (char) 0;
    std::cout << output_filename.substr(output_filename.find_last_of('/')+1,output_filename.find_last_of('.')) << std::endl;
    cursor += output_filename.substr(output_filename.find_last_of('/')+1,output_filename.find_last_of('.')).length()+1;

    for(int i=0; i < func_size; i++){
        func_file >> func_name >> std::hex >> func_addr;
        output_file << func_name << (char) 0;
        cursor += func_name.length()+1;
    }
    output_file.write(filler, (-cursor) & 7);
    cursor += (-cursor) & 7;

    if(text_size){
        text_file.read((char*)section_buffer, text_size);
        output_file.write((char*)section_buffer, text_size);
        cursor += text_size;
        output_file.write(filler, (-cursor) & 7);
        cursor += (-cursor) & 7;
    }
    if(data_size){
        data_file.read((char*)section_buffer, data_size);
        output_file.write((char*)section_buffer, data_size);
        cursor += data_size;
        output_file.write(filler, (-cursor) & 7);
        cursor += (-cursor) & 7;
    }
    if(rodata_size){
        rodata_file.read((char*)section_buffer, rodata_size);
        output_file.write((char*)section_buffer, rodata_size);
        cursor += rodata_size;
        output_file.write(filler, (-cursor) & 7);
        cursor += (-cursor) & 7;
    }

    text_file.close();
    data_file.close();
    rodata_file.close();
    func_file.close();
    output_file.close();
    delete[] output_binary;
    delete[] section_buffer;
}
