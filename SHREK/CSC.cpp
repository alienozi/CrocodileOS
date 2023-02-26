#include<iostream>
#include<fstream>
#include<string>
#include<stdio.h>
#include<stdlib.h>
#define VERSION "1.0.0.0"
int main(int argn,char** argv){
    std::fstream Input,Text,Data,Rodata,Func,Local,Extern,Main,Pre,Output;
    std::string Input_filename(argv[1]),Temp_str,Temp_str2,Input_str,cmd;
    int cursor = 0,cursor2 = 0,cursor3 = 0,cursor4 = 0;
    int temp = 0,funcNum = 0,sectNum=0,Vaddr=4096;
    unsigned short shrek_func_num;
    bool textValid=false,dataValid=false,rodataValid=false,localValid=false;
    for(cursor=1;cursor<argn;cursor++){
        Temp_str2 = std::string(argv[cursor]);
        if(Temp_str2.compare("-v") == 0)break;
    }
    if(Temp_str2.compare("-v")==0){
        std::cout << "COS SHREK Compiler version: " << VERSION << std::endl;
        return 0;
    }
    cursor=0;
    Temp_str2.clear();
    for(cursor=1;cursor<argn;cursor++){
        Temp_str2 = std::string(argv[cursor]);
        if(Temp_str2.compare("-Vaddr") == 0)break;
    }
    if(Temp_str2.compare("-Vaddr")==0){
        Vaddr = std::atoi(argv[cursor+1]);
        return 0;
    }
    cursor=0;
    Temp_str2.clear();
	Temp_str = Input_filename;
    cmd = "gcc ";
    cmd.append(Input_filename);
    cmd.append(" -m32 -masm=intel -S -o ");
    Input_filename.replace(Input_filename.begin()+Input_filename.find_last_of("."),Input_filename.end(),".s");
    cmd.append(Input_filename);
    system(cmd.c_str());
	Input.open(Input_filename,std::fstream::binary|std::fstream::in);

	Temp_str.replace(Temp_str.begin()+Temp_str.find_last_of("."),Temp_str.end(),".text");
	Text.open(Temp_str,std::fstream::out|std::fstream::trunc);
	Temp_str.replace(Temp_str.begin()+Temp_str.find_last_of("."),Temp_str.end(),".data");
	Data.open(Temp_str,std::fstream::out|std::fstream::trunc);
	Temp_str.replace(Temp_str.begin()+Temp_str.find_last_of("."),Temp_str.end(),".rodata");
	Rodata.open(Temp_str,std::fstream::out|std::fstream::trunc);
	Temp_str.replace(Temp_str.begin()+Temp_str.find_last_of("."),Temp_str.end(),".func");
	Func.open(Temp_str,std::fstream::out|std::fstream::trunc);
	Temp_str.replace(Temp_str.begin()+Temp_str.find_last_of("."),Temp_str.end(),".local");
	Local.open(Temp_str,std::fstream::out|std::fstream::trunc);
    Temp_str.replace(Temp_str.begin()+Temp_str.find_last_of("."),Temp_str.end(),".extern");
    Extern.open(Temp_str,std::fstream::out|std::fstream::trunc);
	Input << "\0";
    Temp_str.replace(Temp_str.begin()+Temp_str.find_last_of("."),Temp_str.end(),".main");
    Main.open(Temp_str,std::fstream::out|std::fstream::trunc);
	std::getline(Input,Input_str,'\0');
	Input.close();
    Temp_str.replace(Temp_str.begin()+Temp_str.find_last_of("."),Temp_str.end(),".s");
    remove(Temp_str.c_str());
    Temp_str.clear();

    while((cursor = Input_str.find("@function",cursor))!=std::string::npos){//stores the functions in .func file
        cursor = Input_str.find_first_of("\n",cursor)+1;
        Func << "SHREK.func" << funcNum <<"_name_off: db \"" << Input_str.substr(cursor,Input_str.find_first_of(":",cursor)-cursor) << "\",0\n";
        Temp_str.append(Input_str.substr(cursor,Input_str.find(".LFE",cursor)-cursor));
        funcNum++;
    }
    cursor=0;
    while((cursor = Temp_str.find_first_of("\n",cursor)) != std::string::npos){//prepares .test file
        while(Temp_str[++cursor] == '\t');
        if(Temp_str[cursor] == '.')Temp_str[cursor] = ';';

    }
    cursor=0;
    while((cursor = Temp_str.find("@PLT",cursor))!=std::string::npos){
        Extern << Temp_str.substr(Temp_str.find_last_of(" \t",cursor)-1,cursor-(Temp_str.find_last_of(" \t",cursor)-1)) << "\n";
        Temp_str.erase(cursor,4);
        cursor++;
    }
    cursor=0;
    while((cursor = Temp_str.find("@GOTOFF",cursor))!=std::string::npos){
        Temp_str.replace(cursor,Temp_str.find_first_of("[",cursor)-cursor+1,"+");
        cursor = Temp_str.find_last_of(" \t",cursor)+1;
        if(Temp_str.substr(cursor,sizeof(".LC")-1) == ".LC")Temp_str.insert(cursor,Input_filename.substr(0,Input_filename.find_first_of(" \t.")));
        Temp_str.insert(cursor,"[");
    }
    cursor=0;
    while((cursor = Temp_str.find(" PTR ",cursor))!=std::string::npos){
        Temp_str.erase(cursor,sizeof("PTR ")-1);
    }
    cursor=0;
    while((cursor = Temp_str.find("OFFSET FLAT:_GLOBAL_OFFSET_TABLE_\n",cursor))!=std::string::npos){
        Temp_str.replace(cursor,sizeof("OFFSET FLAT:_GLOBAL_OFFSET_TABLE_")-1,"$$-$");
    }
    Text << Temp_str << std::endl;
	cursor = 0;
	Temp_str.clear();
    while((cursor = Input_str.find("\t.local\t",cursor))!=std::string::npos){//stores the local variables in .local file
			cursor = Input_str.find(".comm",cursor)+6;
			Temp_str.append("\n"+Input_str.substr(cursor,Input_str.find_first_of("\n",cursor)-cursor));
            //std::cout << Temp_str << std::endl;
	}
	cursor = 0;
    while((cursor = Temp_str.find_first_of("\n",cursor))!=std::string::npos){
		cursor2 = Temp_str.find_first_of(",",cursor)+1;
		Local << "align " << Temp_str.substr(Temp_str.find_first_of(",",cursor2)+1,Temp_str.find_first_of("\n",cursor2)-1-Temp_str.find_first_of(",",cursor2));
		Local << Temp_str.substr(cursor,cursor2-1-cursor) << ": times ";
		Local << Temp_str.substr(cursor2,Temp_str.find_first_of(",",cursor2)-cursor2) << " db 0"<<std::endl;
		cursor = cursor2;		
	}
	Temp_str.clear();
	cursor = 0;cursor2=0;
	if(Input_str.find("\t.data\n",cursor)<Input_str.find("\t.rodata\n",cursor) && Input_str.find("\t.data\n",cursor)!=std::string::npos){
		cursor2 = Input_str.find("\t.data\n")+1;
		Temp_str = "data";
	}else if(Input_str.find("\t.rodata\n",cursor)!=std::string::npos){
		cursor2 = Input_str.find("\t.rodata\n")+1;
        Temp_str = "rodata";
	}else{
		cursor2 = Input_str.length();
	}
	cursor = cursor2;
	if(Input_str.find("\t.data\n",cursor2)<Input_str.find("\t.rodata\n",cursor2) && Input_str.find("\t.data\n",cursor2)!=std::string::npos)
		cursor2 = Input_str.find("\t.data\n",cursor2)+1;
	else if(Input_str.find("\t.rodata\n",cursor2)!=std::string::npos)
		cursor2 = Input_str.find("\t.rodata\n",cursor2)+1;
	else
		cursor2 = Input_str.length();
    while((cursor = Input_str.find("@object",cursor))!=std::string::npos){//stores static and constant static variables in .rodata and .data files
		if(cursor >= cursor2){
			Temp_str = Input_str.substr(cursor2+1,Input_str.find_first_of("\n",cursor2)-cursor2-1);
			if(Input_str.find("\t.data\n",cursor2)<Input_str.find("\t.rodata\n",cursor2) && Input_str.find("\t.data\n",cursor2)!=std::string::npos)
				cursor2 = Input_str.find("\t.data\n",cursor2)+1;
			else if(Input_str.find("\t.rodata\n",cursor2)!=std::string::npos)
				cursor2 = Input_str.find("\t.rodata\n",cursor2)+1;

			else	cursor2 = Input_str.length();
		}
		cursor4 = Input_str.find_first_of(":",cursor);
		cursor3 = Input_str.find_last_of("\n",cursor4)+1;
		cursor = Input_str.find_last_of("\n",cursor);
		cursor = Input_str.find_last_of(".",cursor)+1;
		if(Temp_str.compare("data")==0){
			if(Input_str.compare(cursor,sizeof("align")-1,"align")==0)Data << Input_str.substr(cursor,Input_str.find_first_of("\n",cursor)+1-cursor);
			Data << Input_str.substr(cursor3,cursor4-cursor3) <<":\n";
			cursor = cursor4+4;
			Temp_str2 = Input_str.substr(cursor,Input_str.find_first_of("\t ",cursor)-cursor);
			if(Temp_str2.compare("byte")==0){
				while(Temp_str2.compare(Input_str.substr(cursor,Input_str.find_first_of("\t ",cursor)-cursor))==0){
					cursor = Input_str.find_first_of("\t ",cursor)+1;
					Data << "db\t" << Input_str.substr(cursor,Input_str.find_first_of("\n",cursor)-cursor) <<"\n";
					cursor = Input_str.find_first_of("\t ",cursor)+2;
				}
				Temp_str2 = Input_str.substr(cursor,Input_str.find_first_of("\t ",cursor)-cursor);
				if(Temp_str2.compare("zero")==0){
					cursor = Input_str.find_first_of("\t ",cursor)+1;
					Data << "times\t" << Input_str.substr(cursor,Input_str.find_first_of("\n",cursor)-cursor) <<"\tdb 0\n";
					cursor = Input_str.find_first_of("\t ",cursor)+2;
				}	
			}else if(Temp_str2.compare("value")==0){
				while(Temp_str2.compare(Input_str.substr(cursor,Input_str.find_first_of("\t ",cursor)-cursor))==0){
					cursor = Input_str.find_first_of("\t ",cursor)+1;
					Data << "dw\t" << Input_str.substr(cursor,Input_str.find_first_of("\n",cursor)-cursor) <<"\n";
					cursor = Input_str.find_first_of("\t ",cursor)+2;
				}
				Temp_str2 = Input_str.substr(cursor,Input_str.find_first_of("\t ",cursor)-cursor);
				if(Temp_str2.compare("zero")==0){
					cursor = Input_str.find_first_of("\t ",cursor)+1;
					Data << "times\t" << Input_str.substr(cursor,Input_str.find_first_of("\n",cursor)-cursor) <<"\tdb 0\n";
					cursor = Input_str.find_first_of("\t ",cursor)+2;
				}	
			}else if(Temp_str2.compare("long")==0){
				while(Temp_str2.compare(Input_str.substr(cursor,Input_str.find_first_of("\t ",cursor)-cursor))==0){
					cursor = Input_str.find_first_of("\t ",cursor)+1;
					Data << "dd\t" << Input_str.substr(cursor,Input_str.find_first_of("\n",cursor)-cursor) <<"\n";
					cursor = Input_str.find_first_of("\t ",cursor)+2;
				}
				Temp_str2 = Input_str.substr(cursor,Input_str.find_first_of("\t ",cursor)-cursor);
				if(Temp_str2.compare("zero")==0){
					cursor = Input_str.find_first_of("\t ",cursor)+1;
					Data << "times\t" << Input_str.substr(cursor,Input_str.find_first_of("\n",cursor)-cursor) <<"\tdb 0\n";
					cursor = Input_str.find_first_of("\t ",cursor)+2;
				}	
			}else if(Temp_str2.compare("zero")==0){
				cursor = Input_str.find_first_of("\t ",cursor)+1;
				Data << "times\t" << Input_str.substr(cursor,Input_str.find_first_of("\n",cursor)-cursor) <<"\tdb 0\n";
				cursor = Input_str.find_first_of("\t ",cursor)+2;			
			}else if(Temp_str2.compare("string")==0 || Temp_str2.compare("ascii")==0){
				while(Temp_str2.compare("string")==0 || Temp_str2.compare("ascii")==0){
					cursor = Input_str.find_first_of("\t ",cursor)+1;
						//if(Temp_str2.compare("string")==0)Data << "db\t" << Input_str.substr(cursor,Input_str.find_first_of("\"",cursor+1)-cursor+1) <<",0\n";
					Temp_str2 = Input_str.substr(cursor,Input_str.find_first_of("\"",cursor+1)-cursor+1);
					for(int i=0;i<Temp_str2.length();i++){
						if(Temp_str2[i]=='\\'){
							Temp_str2.replace(i,1,"\",");
							switch(Temp_str2[i+2]){
								case 'n':Temp_str2.replace(i+2,1,"10,\"");i+=2;break;
								case 't':Temp_str2.replace(i+2,1,"9,\"");i+=2;break;
								default:Temp_str2.insert(i+5,",\"");i+=5;break;
							}
						}
					}
					Data << "db\t" << Temp_str2 <<",0\n";
					cursor = Input_str.find_first_of("\t ",cursor)+2;
					Temp_str2 = Input_str.substr(cursor,Input_str.find_first_of("\t ",cursor)-cursor);
				}
				if(Temp_str2.compare("zero")==0){
					cursor = Input_str.find_first_of("\t ",cursor)+1;
					Data << "times\t" << Input_str.substr(cursor,Input_str.find_first_of("\n",cursor)-cursor) <<"\tdb 0\n";
					cursor = Input_str.find_first_of("\t ",cursor)+2;
				}
			}else{

			}

		}else if(Temp_str.compare("rodata")==0){
			if(Input_str.compare(cursor,sizeof("align")-1,"align")==0)Rodata << Input_str.substr(cursor,Input_str.find_first_of("\n",cursor)+1-cursor);
			Rodata << Input_str.substr(cursor3,cursor4-cursor3)<<":\n";
			cursor = cursor4+4;
			Temp_str2 = Input_str.substr(cursor,Input_str.find_first_of("\t ",cursor)-cursor);
			if(Temp_str2.compare("byte")==0){
				while(Temp_str2.compare(Input_str.substr(cursor,Input_str.find_first_of("\t ",cursor)-cursor))==0){
					cursor = Input_str.find_first_of("\t ",cursor)+1;
					Rodata << "db\t" << Input_str.substr(cursor,Input_str.find_first_of("\n",cursor)-cursor) <<"\n";
					cursor = Input_str.find_first_of("\t ",cursor)+2;
				}
				Temp_str2 = Input_str.substr(cursor,Input_str.find_first_of("\t ",cursor)-cursor);
				if(Temp_str2.compare("zero")==0){
					cursor = Input_str.find_first_of("\t ",cursor)+1;
					Rodata << "times\t" << Input_str.substr(cursor,Input_str.find_first_of("\n",cursor)-cursor) <<"\tdb 0\n";
					cursor = Input_str.find_first_of("\t ",cursor)+2;
				}	
			}else if(Temp_str2.compare("value")==0){
				while(Temp_str2.compare(Input_str.substr(cursor,Input_str.find_first_of("\t ",cursor)-cursor))==0){
					cursor = Input_str.find_first_of("\t ",cursor)+1;
					Rodata << "dw\t" << Input_str.substr(cursor,Input_str.find_first_of("\n",cursor)-cursor) <<"\n";
					cursor = Input_str.find_first_of("\t ",cursor)+2;
				}
				Temp_str2 = Input_str.substr(cursor,Input_str.find_first_of("\t ",cursor)-cursor);
				if(Temp_str2.compare("zero")==0){
					cursor = Input_str.find_first_of("\t ",cursor)+1;
					Rodata << "times\t" << Input_str.substr(cursor,Input_str.find_first_of("\n",cursor)-cursor) <<"\tdb 0\n";
					cursor = Input_str.find_first_of("\t ",cursor)+2;
				}	
			}else if(Temp_str2.compare("long")==0){
				while(Temp_str2.compare(Input_str.substr(cursor,Input_str.find_first_of("\t ",cursor)-cursor))==0){
					cursor = Input_str.find_first_of("\t ",cursor)+1;
					Rodata << "dd\t" << Input_str.substr(cursor,Input_str.find_first_of("\n",cursor)-cursor) <<"\n";
					cursor = Input_str.find_first_of("\t ",cursor)+2;
				}
				Temp_str2 = Input_str.substr(cursor,Input_str.find_first_of("\t ",cursor)-cursor);
				if(Temp_str2.compare("zero")==0){
					cursor = Input_str.find_first_of("\t ",cursor)+1;
					Rodata << "times\t" << Input_str.substr(cursor,Input_str.find_first_of("\n",cursor)-cursor) <<"\tdb 0\n";
					cursor = Input_str.find_first_of("\t ",cursor)+2;
				}	
			}else if(Temp_str2.compare("zero")==0){
				cursor = Input_str.find_first_of("\t ",cursor)+1;
				Rodata << "times\t" << Input_str.substr(cursor,Input_str.find_first_of("\n",cursor)-cursor) <<"\tdb 0\n";
				cursor = Input_str.find_first_of("\t ",cursor)+2;			
			}else if(Temp_str2.compare("string")==0 || Temp_str2.compare("ascii")==0){
				while(Temp_str2.compare("string")==0 || Temp_str2.compare("ascii")==0){
					cursor = Input_str.find_first_of("\t ",cursor)+1;
					//if(Temp_str2.compare("string")==0)Data << "db\t" << Input_str.substr(cursor,Input_str.find_first_of("\"",cursor+1)-cursor+1) <<",0\n";
					Temp_str2 = Input_str.substr(cursor,Input_str.find_first_of("\"",cursor+1)-cursor+1);
					for(int i=0;i<Temp_str2.length();i++){
						if(Temp_str2[i]=='\\'){
							Temp_str2.replace(i,1,"\",");
							switch(Temp_str2[i+2]){
								case 'n':Temp_str2.replace(i+2,1,"10,\"");i+=2;break;
								case 't':Temp_str2.replace(i+2,1,"9,\"");i+=2;break;
								default:Temp_str2.insert(i+5,",\"");i+=5;break;
							}
						}
					}
					Rodata << "db\t" << Temp_str2 <<",0\n";
					cursor = Input_str.find_first_of("\t ",cursor)+2;
					Temp_str2 = Input_str.substr(cursor,Input_str.find_first_of("\t ",cursor)-cursor);
				}
				if(Temp_str2.compare("zero")==0){
					cursor = Input_str.find_first_of("\t ",cursor)+1;
					Rodata << "times\t" << Input_str.substr(cursor,Input_str.find_first_of("\n",cursor)-cursor) <<"\tdb 0\n";
					cursor = Input_str.find_first_of("\t ",cursor)+2;
				}
			}else{
			}
				
		}
		cursor = cursor4;
			
	}
	cursor=0;
	cursor2=0;
	cursor3=0;
	cursor4=0;
	while((cursor = Input_str.find("\n.LC",cursor))!=std::string::npos){		//adds local constants mainly used in function calls to Rodata
		cursor4 = Input_str.find_first_of(":",cursor);
		cursor3 = Input_str.find_last_of(".",cursor4)+1;
        Rodata << "align 4\n" << Input_filename.substr(0,Input_filename.find_first_of(" \t.")) << "." << Input_str.substr(cursor3,cursor4-cursor3) <<":\n";
		cursor = cursor4+4;
		Temp_str2 = Input_str.substr(cursor,Input_str.find_first_of("\t ",cursor)-cursor);
		if(Temp_str2.compare("string")==0 || Temp_str2.compare("ascii")==0){
			cursor = Input_str.find_first_of("\t ",cursor)+1;
			//if(Temp_str2.compare("string")==0)Data << "db\t" << Input_str.substr(cursor,Input_str.find_first_of("\"",cursor+1)-cursor+1) <<",0\n";
			Temp_str2 = Input_str.substr(cursor,Input_str.find_first_of("\"",cursor+1)-cursor+1);
			for(int i=0;i<Temp_str2.length();i++){
				if(Temp_str2[i]=='\\'){
					Temp_str2.replace(i,1,"\",");
					switch(Temp_str2[i+2]){
						case 'n':Temp_str2.replace(i+2,1,"10,\"");i+=2;break;
						case 't':Temp_str2.replace(i+2,1,"9,\"");i+=2;break;
						default:Temp_str2.insert(i+5,",\"");i+=5;break;
					}
				}
			}
			Rodata << "db\t" << Temp_str2 <<",0\n"<<std::endl;
			
		}
		cursor = Input_str.find_first_of("\n",cursor);
	}

    cursor=0;
    cursor2=0;
    cursor3=0;
    cursor4=0;
    if(Data.tellp()>0){dataValid=true;sectNum++;}
    if(Rodata.tellp()>0){rodataValid=true;sectNum++;}
    if(Local.tellp()>0){localValid=true;sectNum++;}
    if(Text.tellp()>0){textValid=true;sectNum++;}
	Data.close();
    Func.close();
	Local.close();
	Rodata.close();
    Text.close();
    Extern.close();

    Temp_str = Input_filename;
    Input_filename.erase(Input_filename.find_last_of("."));

    Main << "SHREK.header_start:\n";
    Main << "DB \".SHREK\",239,93\n";
    Main << "SHREK.version: DB 1, 0, 0, 0\n";
    Main << "SHREK.size: DW SHREK.header_end-SHREK.header_start\n";
    Main << "SHREK.numOfEB: DW 1\n";
    Main << "SHREK.numOfFunc: DW " << funcNum << "\n";
    Main << "SHREK.checkSum: DW 0\n";
    Main << "SHREK.EB_entry_off: DD SHREK.EB_entry_start\n";
    Main << "SHREK.Func_entry_off: DD SHREK.func_entry_start\n";
    Main << "DD 0\t;reserved\n";
    Main << "SHREK.header_end:\n";

    Main << "SHREK.String_Table:\n";

    Main << "SHREK.EB_types:\n";
    Main << "SHREK.EB_type_local: DB \".local\",0\n";
    Main << "SHREK.EB_type_shared: DB \".shared\",0\n";
    Main << "SHREK.EB_type_dynamic: DB \".dynamic\",0\n";

    Main << "SHREK.Section_types:\n";
    Main << "SHREK_section_type_data: DB \".data\",0\n";
    Main << "SHREK_section_type_rodata: DB \".rodata\",0\n";
    Main << "SHREK_section_type_local: DB \".local\",0\n";
    Main << "SHREK_section_type_text: DB \".text\",0\n";

    Main << "SHREK.EB_names:\n";
    Main << "SHREK.EB_0_name: DB \"" << Input_filename << "\",0\n";

    Temp_str.replace(Temp_str.begin()+Temp_str.find_last_of("."),Temp_str.end(),".func");
    Main << "SHREK.Func_names:\n%include \"" << Temp_str << "\"\n" <<"Func_end:\n";
    Main << "align 8\n";

    Main << "SHREK.EB_entry_start:\n";
    Main << "SHREK.EB_0:\n";

    Main << "SHREK.EB_0_header_begin:\n";

    Main << "SHREK.EB_name: DD SHREK.EB_0_name-SHREK.String_Table\n";
    Main << "SHREK.EB_type: DD SHREK.EB_type_local-SHREK.String_Table\n";
    Main << "SHREK.EB_vaddr: DD 4096\n";//burayı değiştir
    Main << "SHREK.EB_size: DD SHREK.EB_section_data_end-SHREK.EB_section_data_start\n";
    Main << "SHREK.EB_First_function_entry_index: DW 0\n";
    Main << "SHREK.EB_num_of_func: DW " << funcNum << "\n";
    Main << "SHREK.EB_header_size:DW SHREK.EB_0_header_end-SHREK.EB_0_header_begin\n";
    Main << "SHREK.EB_numner_of_sections:DW " << sectNum << std::endl;
    Main << "DD 0\t;reserved\n";

    Main << "SHREK.EB_0_header_end:\n";

    if(textValid){
        Main << "SHREK.text_section_entry:\n";
        Main << "SHREK.text_section_type: DD SHREK_section_type_text - SHREK.String_Table\n";
        Main << "SHREK.text_section_size: DD SHREK.Text_end-SHREK.Text_begin\n";
        Main << "SHREK.text_section_data_offset: DD SHREK.Text_begin\n";
        Main << "SHREK.text_section_permisions: DB 0x00, 0xff, 0x00, 0x00\n";

    }
    if(dataValid){
        Main << "SHREK.data_section_entry:\n";
        Main << "SHREK.data_section_type: DD SHREK_section_type_data - SHREK.String_Table\n";
        Main << "SHREK.data_section_size: DD SHREK.Data_end-SHREK.Data_begin\n";
        Main << "SHREK.data_section_data_offset: DD SHREK.Data_begin\n";
        Main << "SHREK.data_section_permisions: DB 0xff, 0x00, 0x00, 0x00\n";

    }
    if(rodataValid){
        Main << "SHREK.rodata_section_entry:\n";
        Main << "SHREK.rodata_section_type: DD SHREK_section_type_rodata - SHREK.String_Table\n";
        Main << "SHREK.rodata_section_size: DD SHREK.Rodata_end-SHREK.Rodata_begin\n";
        Main << "SHREK.rodata_section_data_offset: DD SHREK.Rodata_begin\n";
        Main << "SHREK.rodata_section_permisions: DB 0x00, 0x00, 0x00, 0x00\n";

    }
    if(localValid){
        Main << "SHREK.local_section_entry:\n";
        Main << "SHREK.local_section_type: DD SHREK_section_type_local-SHREK.String_Table\n";
        Main << "SHREK.local_section_size: DD SHREK.Local_end-SHREK.Local_begin\n";
        Main << "SHREK.local_section_data_offset: DD SHREK.Local_begin\n";
        Main << "SHREK.local_section_permisions: DB 0xff, 0x00, 0x00, 0x00\n";

    }
    cursor=0;
    funcNum=0;
    Main << "SHREK.func_entry_start:\n";
    while((cursor = Input_str.find("@function",cursor))!=std::string::npos){//stores the functions in .func file
        cursor = Input_str.find_first_of("\n",cursor)+1;
        Main << "SHREK.func" << funcNum <<":\n";
        Main << "SHREK.func" << funcNum << "_name: dd " << "SHREK.func" << funcNum <<"_name_off - SHREK.String_Table\n";
        Main << "SHREK.func" << funcNum <<"_EB_num:dd 0\n";
        Main << "SHREK.func" << funcNum <<"_EB_off: dd " << Input_str.substr(cursor,Input_str.find_first_of(":",cursor)-cursor) << "\n";
        funcNum++;
    }
    Main << "SHREK.section_data_dump:";
    Main << "align 4096\n";
    Main << "SHREK.EB_section_data_start:\n";
    if(textValid){
        Temp_str.replace(Temp_str.begin()+Temp_str.find_last_of("."),Temp_str.end(),".text");
        Main << "SHREK.Text_begin:\n%include \"" << Temp_str << "\"\n" <<"SHREK.Text_end:\n";
        Main << "align 4096\n";
        Main << "times 4096 db 0\n";
    }
    if(dataValid){
        Temp_str.replace(Temp_str.begin()+Temp_str.find_last_of("."),Temp_str.end(),".data");
        Main << "SHREK.Data_begin:\n%include \"" << Temp_str << "\"\n" <<"SHREK.Data_end:\n";
        Main << "align 4096\n";
        Main << "times 4096 db 0\n";
    }
    if(rodataValid){
        Temp_str.replace(Temp_str.begin()+Temp_str.find_last_of("."),Temp_str.end(),".rodata");
        Main << "SHREK.Rodata_begin:\n%include \"" << Temp_str << "\"\n" <<"SHREK.Rodata_end:\n";
        Main << "align 4096\n";
        Main << "times 4096 db 0\n";
    }
    if(localValid){
        Temp_str.replace(Temp_str.begin()+Temp_str.find_last_of("."),Temp_str.end(),".local");
        Main << "SHREK.Local_begin:\n%include \"" << Temp_str << "\"\n" <<"SHREK.Local_end:\n";
        Main << "align 4096\n";
    }
    Main << "SHREK.EB_section_data_end:\n";
    Temp_str.replace(Temp_str.begin()+Temp_str.find_last_of("."),Temp_str.end(),".main");
    Main.close();
    for(cursor=1;cursor<argn;cursor++){
        Temp_str2 = std::string(argv[cursor]);
        if(Temp_str2.compare("-S") == 0)break;
    }
    if(Temp_str2.compare("-S") == 0)return 0;
    cmd.clear();
    cmd = "nasm ";
    cmd.append(Temp_str);
    cmd.append(" -f bin -o ");
    cmd.append(Input_filename);
    cmd.append(".pre");
    system(cmd.c_str());

    Temp_str.replace(Temp_str.begin()+Temp_str.find_last_of("."),Temp_str.end(),".main");
    remove(Temp_str.c_str());
    Temp_str.replace(Temp_str.begin()+Temp_str.find_last_of("."),Temp_str.end(),".text");
    remove(Temp_str.c_str());
    Temp_str.replace(Temp_str.begin()+Temp_str.find_last_of("."),Temp_str.end(),".data");
    remove(Temp_str.c_str());
    Temp_str.replace(Temp_str.begin()+Temp_str.find_last_of("."),Temp_str.end(),".rodata");
    remove(Temp_str.c_str());
    Temp_str.replace(Temp_str.begin()+Temp_str.find_last_of("."),Temp_str.end(),".local");
    remove(Temp_str.c_str());
    Temp_str.replace(Temp_str.begin()+Temp_str.find_last_of("."),Temp_str.end(),".func");
    remove(Temp_str.c_str());
    Temp_str.replace(Temp_str.begin()+Temp_str.find_last_of("."),Temp_str.end(),".extern");
    remove(Temp_str.c_str());
    Temp_str.replace(Temp_str.begin()+Temp_str.find_last_of("."),Temp_str.end(),".pre");
    Pre.open(Temp_str,std::fstream::binary|std::fstream::in);
    Temp_str.replace(Temp_str.begin()+Temp_str.find_last_of("."),Temp_str.end(),".shrek");
    Output.open(Temp_str,std::fstream::binary|std::fstream::out|std::fstream::trunc);

    Pre.seekg(0,std::fstream::end);
    cursor = Pre.tellg();

    char* bin_out = new char[cursor];
    Pre.seekg(0,std::fstream::beg);
    Pre.read(bin_out,cursor);
    Pre.close();

    Temp_str.replace(Temp_str.begin()+Temp_str.find_last_of("."),Temp_str.end(),".pre");
    remove(Temp_str.c_str());
    unsigned int func_off = *((unsigned int*)(bin_out+24));
    unsigned int eb_off = *((unsigned int*)(bin_out+20));
    unsigned short string_table_off = *((unsigned short*)(bin_out+12));
    unsigned int shift=0,sect_data[4],sect_size[4];
    cursor = func_off+funcNum*12;
    if(cursor%8!=0)cursor = (cursor|7)+1;
    unsigned short eb_header_size = *((unsigned short*)(bin_out+eb_off+20));

    for(int i=0;i<sectNum;i++){
        sect_size[i] = ((unsigned int*)(bin_out+eb_off+eb_header_size))[4*i+1];
        sect_data[i] = ((unsigned int*)(bin_out+eb_off+eb_header_size))[4*i+2];
        //std::cout << "sec size:" << sect_size[i] << std::endl;
        //std::cout << "sec data:" << sect_data[i] << std::endl;
        //std::cout << i << std::endl;
        ((unsigned int*)(bin_out+eb_off+eb_header_size))[4*i+2]=shift+cursor;
        shift+=sect_size[i];
        if(shift%8!=0)shift = (shift|7)+1;
    }
    Output.write(bin_out,cursor);
    for(int i=0;i<sectNum;i++){
        if(sect_size[i]%8!=0)sect_size[i] = (sect_size[i]|7)+1;
        Output.write(bin_out+sect_data[i],sect_size[i]);

    }
    Output.close();
    delete[] bin_out;
}
