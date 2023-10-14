#include<stdlib.h>
#include<stdint.h>

#include<fstream>
#include<filesystem>
#include<iostream>
#include<string.h>

#include"/home/totan/Desktop/CrocodileOS/OS_functions/general/shrek.h"
#define ADD_OFFSET_TO_PTR(PTR, OFFSET)	( (typeof(PTR)) ( ( (char*) (PTR) ) + ((unsigned long int)(OFFSET)) ) )

int main(int argn, char** argv){
    std::fstream file;
    char* shrek;
    Shrek_main_header* shrek_header;
    Shrek_eb_header* eb_header;
    Shrek_eb_section_entry* eb_entries;
    Shrek_eb_function_entry* func_entries;
    char* string_table;

    shrek = (char*) new uint8_t[std::filesystem::file_size(argv[1])];

    file.open(argv[1], std::fstream::in | std::fstream::binary);

    if(!(file.is_open() && shrek != NULL)){
        if(file.is_open())file.close();
        if(shrek != NULL) delete[] shrek;
    }

    file.read(shrek, std::filesystem::file_size(argv[1]));

    shrek_header = (Shrek_main_header*) shrek;
    eb_header = (Shrek_eb_header*)ADD_OFFSET_TO_PTR(shrek, shrek_header->eb_entry_offset);
    eb_entries = (Shrek_eb_section_entry*)ADD_OFFSET_TO_PTR(eb_header, sizeof(Shrek_eb_header));
    func_entries = (Shrek_eb_function_entry*)ADD_OFFSET_TO_PTR(shrek, shrek_header->func_entry_offset);
    string_table = (char*)ADD_OFFSET_TO_PTR(shrek, shrek_header->string_table_offset);

    std::cout << "Filename: " << argv[1] << std::endl;
    std::cout << "SHREK verison: " << (uint32_t)shrek_header->version[0] << "." <<
        (uint32_t)shrek_header->version[1] << "." << (uint32_t)shrek_header->version[2] << "." << (uint32_t)shrek_header->version[3] << std::endl;
    std::cout << "Number of EBs: " << shrek_header->num_of_eb << std::endl;
    std::cout << "Number of Functions: " << shrek_header->num_of_func << std::endl;
    std::cout << "Check_sum: " << shrek_header->check_sum << std::endl;

    for(uint32_t i_eb = 0;i_eb < shrek_header->num_of_eb; i_eb++){
        std::cout << "\n\n\t__EB" << i_eb << "__\n" << std::endl;
        std::cout << "\tName: " << &string_table[eb_header->name_offset] << std::endl;
        std::cout << "\tType: " << SHREK_GET_TYPE_STRING(eb_header->type) << std::endl;
        std::cout << "\tVaddr: " << eb_header->vaddr << std::endl;
        std::cout << "\tSize: " << eb_header->size << std::endl;
        std::cout << "\tNumber of Functions: " << eb_header->num_of_func << std::endl;
        std::cout << "\tNumber of Sections: " << eb_header->num_of_section << std::endl;

        if(eb_header->type == SHREK_SHARED){
            if(eb_header->unlock_func_index == -1){
                std::cout << "\tUnlock Function: " << "NA (purely public)" << std::endl;
            }else{
                std::cout << "\tUnlock Function: " << &string_table[func_entries[eb_header->unlock_func_index].name] << std::endl;
            }
        }

        for(uint16_t i_sect = 0; i_sect < eb_header->num_of_section; i_sect++){
            std::cout << "\n\t\t__SECTION" << i_sect << "__" << std::endl;
            std::cout << "\t\ttype: " << SHREK_GET_SECTION_TYPE_STRING(eb_entries[i_sect].type) << std::endl;
            std::cout << "\t\tsize: " << eb_entries[i_sect].size << std::endl;
            if(eb_header->type == SHREK_DYNAMIC){
                if(eb_entries[i_sect].section_key == -1){
                    std::cout << "\t\tSection Key: " << "NA" << std::endl;
                }else{
                    std::cout << "\t\tSection Key: " << &string_table[eb_entries[i_sect].section_key] << std::endl;
                }
            }
        }

        for(uint16_t i_func = 0; i_func < eb_header->num_of_func; i_func++){
            std::cout << "\t\t__Func" << i_func << "__" << std::endl;
            std::cout << "\t\tName: " << &string_table[func_entries[eb_header->first_func_index + i_func].name] << std::endl;
            std::cout << "\t\tVaddr: " << eb_header->vaddr + func_entries[eb_header->first_func_index + i_func].EB_offset << std::endl;
        }

        eb_entries = (Shrek_eb_section_entry*)ADD_OFFSET_TO_PTR(eb_entries, sizeof(Shrek_eb_header) + sizeof(Shrek_eb_section_entry) * eb_header->num_of_section);
        eb_header = (Shrek_eb_header*)ADD_OFFSET_TO_PTR(eb_header, sizeof(Shrek_eb_header) + sizeof(Shrek_eb_section_entry) * eb_header->num_of_section);

    }

    file.close();
}
