#include<iostream>
#include<fstream>
#include<string.h>
#define VERSION "1.0.0.0"
#define IDENTIFIER ".SHREK\xef\x5d"
int main(int argn, char** argv){
	std::string str(".SHREK");
	std::fstream inFile;
    int in_int,cursor;
	inFile.open(argv[1],std::fstream::binary|std::fstream::in);
    inFile.seekg(0,std::fstream::end);
    in_int = inFile.tellg();
    char* bin_data = new char[in_int];
    inFile.seekg(0,std::fstream::beg);
    inFile.read(bin_data,in_int);
    inFile.close();
    if(strncmp(bin_data,IDENTIFIER,8)!=0){
        std::cout << "illegal identifier in file:" << argv[1] <<in_int <<std::endl;
        delete[] bin_data;
        return 0;
    }
    std::cout << "SHREK VERSION:" << +bin_data[8] << "." << +bin_data[9] << "." << +bin_data[10] << "." << +bin_data[11] << std::endl;
    std::cout << "SHREK HEADER SIZE:" << *((unsigned short*)(bin_data+12)) << std::endl;
    std::cout << "NUMBER OF EXECUTABLE BLOCKS:" << *((unsigned short*)(bin_data+14)) << std::endl;
    std::cout << "NUMBER OF FUNCTIONS:" << *((unsigned short*)(bin_data+16)) << std::endl;
    std::cout << "CHECH SUM:" << *((unsigned short*)(bin_data+18)) << std::endl;
    std::cout << "EB START ENTRY OFFSET::" << *((unsigned int*)(bin_data+20)) << std::endl;
    std::cout << "FUNCTION START ENTRY OFFSET::" << *((unsigned int*)(bin_data+24)) << std::endl;

    std::cout << "\n\n\n" << std::endl;
    unsigned int func_off = *((unsigned int*)(bin_data+24));
    unsigned int eb_off = *((unsigned int*)(bin_data+20));
    unsigned short num_of_eb = *((unsigned short*)(bin_data+14));
    unsigned short num_of_func = *((unsigned short*)(bin_data+16));
    unsigned short string_table_off = *((unsigned short*)(bin_data+12));
    unsigned short num_of_sect,eb_header_size,j,EB_func_num,first_EB_func;


    for(short i=0;i<num_of_eb;i++){
        std::cout << "EB NAME:" << bin_data+ string_table_off + *((unsigned int*)(bin_data+eb_off)) << std::endl;
        std::cout << "EB TYPE:" << bin_data + string_table_off + *((unsigned int*)(bin_data+eb_off+4)) << std::endl;
        std::cout << "EB VADDR:" << *((unsigned int*)(bin_data+eb_off+8)) << std::endl;
        std::cout << "EB SIZE:" << *((unsigned int*)(bin_data+eb_off+12)) << std::endl;
        num_of_sect = *((unsigned short*)(bin_data+eb_off+22));
        std::cout << "EB NUM OF SECTION:" << num_of_sect << std::endl;
        if(strcmp(bin_data + string_table_off + *((unsigned int*)(bin_data+eb_off+4)),".shared")==0){
            if(*((unsigned int*)(bin_data+eb_off+24)) == 0){
                std::cout << "EB LOCK FUNCTION: NA(purely public)" <<std::endl;
            }else{
                std::cout << "EB LOCK FUNCTION:" << bin_data +string_table_off+ *((unsigned int*)(bin_data+func_off + 12*(*((unsigned int*)(bin_data+eb_off+24))))) <<std::endl;
            }
        }
        eb_header_size = *((unsigned short*)(bin_data+eb_off+20));
        for(j=0;j<num_of_sect;j++){
            std::cout << std::endl;
            std::cout << "EB SECTION" << j << " TYPE:" << bin_data+string_table_off+ *((unsigned int*)(bin_data+eb_off+eb_header_size+16*j)) <<std::endl;
            std::cout << "EB SECTION" << j << " SIZE:" << *((unsigned int*)(bin_data+eb_off+eb_header_size+16*j+4)) <<std::endl;
            std::cout << "EB SECTION" << j << " DATA OFFSET:" << *((unsigned int*)(bin_data+eb_off+eb_header_size+16*j+8)) <<std::endl;
            if(strcmp(bin_data + string_table_off + *((unsigned int*)(bin_data+eb_off+4)),".dynamic")==0){
                std::cout << "EB SECTION" << j << " DYNAMIC KEY:" << bin_data+string_table_off+ *((unsigned int*)(bin_data+eb_off+eb_header_size+16*j+12)) <<std::endl;
            }else{
                std::cout << "EB SECTION" << j << " WRITE PERMISION:" << ((bin_data[eb_off+eb_header_size+16*j+12]==-1)?"TRUE":((bin_data[eb_off+eb_header_size+16*j+12]==0)?"FALSE":"UNDEFINED")) << std::endl;
                std::cout << "EB SECTION" << j << " EXECUTE PERMISION:" << ((bin_data[eb_off+eb_header_size+16*j+13]==-1)?"TRUE":((bin_data[eb_off+eb_header_size+16*j+13]==0)?"FALSE":"UNDEFINED")) << std::endl;
                std::cout << "EB SECTION" << j << " SHARE PERMISION:" << ((bin_data[eb_off+eb_header_size+16*j+14]==-1)?"TRUE":((bin_data[eb_off+eb_header_size+16*j+14]==0)?"FALSE":"UNDEFINED")) << std::endl;
                std::cout << "EB SECTION" << j << " SHARE MAIN PERMISION:" << ((bin_data[eb_off+eb_header_size+16*j+15]==-1)?"TRUE":((bin_data[eb_off+eb_header_size+16*j+15]==0)?"FALSE":"UNDEFINED")) << std::endl;
            }  
        }
        EB_func_num = *((short int*)(bin_data+eb_off+18));
        first_EB_func = *((short int*)(bin_data+eb_off+16));
        for(int i=first_EB_func;i<EB_func_num+first_EB_func;i++){
            std::cout << "FUNC NAME:" << bin_data+ string_table_off + *((unsigned int*)(bin_data+func_off+12*i)) << std::endl;
            std::cout << "FUNC EB OFFSET:" << *((unsigned int*)(bin_data+func_off+8+12*i)) << std::endl;
        }
        eb_off+=eb_header_size+j*16;
        std::cout << std::endl << "__Functions__" << func_off <<std::endl;
    }
    delete[] bin_data;
}
