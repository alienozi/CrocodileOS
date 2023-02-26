#include<stdlib.h>
#include<string.h>
#include<stdio.h>
int main(int argn,char **argv){
	FILE *INPUT;
	FILE *TEXT,*RODATA,*DATA,*FUNC,*CURRENT;
	INPUT=fopen(argv[1],"r");
	static char string[256];
	strcpy(string,argv[1]);
	strcpy(strchr(string,'.'),".text");
	TEXT=fopen(string,"w+");
	strcpy(strchr(string,'.'),".data");
	DATA=fopen(string,"w+");
	strcpy(strchr(string,'.'),".rodata");
	RODATA=fopen(string,"w+");
	strcpy(strchr(string,'.'),".func");
	FUNC=fopen(string,"w+");
	fseek(INPUT,0,SEEK_END);
	unsigned long int size=ftell(INPUT);
	fseek(INPUT,0,SEEK_SET);
	char *data_in=(char*) malloc(size+1);
	char *data_out=(char*) malloc(size+1);
	data_out[size]=0;
	data_in[size]=0;
	int data_size,data_g;
	data_in[size]=0;data_out[size]=0;
	char *data_ref=data_in;
	fread(data_in,1,size,INPUT);
	fclose(INPUT);
	while(strchr(data_ref,'@')){
		if(!strncmp(strchr(data_ref,'@'),"@function\n",strlen("@function\n"))){
			//printf("function\n");
			data_ref=strchr(data_ref,'@')+strlen("@function\n");
			fwrite(data_ref,1,strchr(data_ref,':')-data_ref+1,FUNC);

		}else if(!strncmp(strchr(data_ref,'@'),"@object\n",strlen("@object\n"))){
			data_ref=strchr(data_ref,'@');
			int i=0;
			while(*(data_ref-i)!=':')	i++;
			
			if(strstr(data_ref-i,"\t.data\n")!=0&&strstr(data_ref-i,"\t.data\n")<data_ref){
				CURRENT=DATA;
				
			}else if(strstr(data_ref-i,"\t.rodata\n")!=0&&strstr(data_ref-i,"\t.rodata\n")<data_ref){
				CURRENT=RODATA;
			}
			data_ref=strchr(strchr(data_ref,'\n')+1,'\n')+1;
			fwrite(data_ref,1,strchr(data_ref,':')-data_ref+1,CURRENT);
			data_ref=strchr(data_ref,'\t')+1;
			while(!(strcmp(data_ref,".long")&strcmp(data_ref,".value")&strcmp(data_ref,".byte"))){
				printf("test\n");
				if(!strncmp(data_ref,".long",strlen(".long"))){
					fprintf(CURRENT,"\n\tDD");
				}else if(!strncmp(data_ref,".value",strlen(".value"))){
					fprintf(CURRENT,"\n\tDW");
				}else if(!strncmp(data_ref,".byte",strlen("byte"))){
					fprintf(CURRENT,"\n\tDB");
				}else{
					break;
				}
					fwrite(strchr(data_ref,'\t'),1,strchr(data_ref,'\n')-strchr(data_ref,'\t')+1,CURRENT);
					data_ref=strchr(data_ref,'\n')+2;
			}
		}else{
			data_ref=strchr(data_ref,'@')+1;
		}
	}
	fclose(TEXT);
	fclose(DATA);
	fclose(RODATA);
	fclose(FUNC);
	data_ref=data_in;
	return 0;
	/*while(strstr(data_ref,"\t.data")){
		//printf(".data\n");
		data_ref=strstr(strstr(data_ref,"\t.data"),"\t.size");
		fwrite(data_ref+7,1,strchr(data_ref,',')-(data_ref+7),DATA);
		fprintf(DATA,":\t");
		strncpy(string,strchr(data_ref,',')+2,strchr(data_ref,'\n')-(strchr(data_ref,',')+2));
		string[strchr(data_ref,'\n')-(strchr(data_ref,',')+2)]=0;
		data_size=atoi(string);
		data_ref=strchr(data_ref,':')+3;
		
		//fwrite(data_ref,1,strchr(data_ref,':')-data_ref+1,FUNC);
	}*/
}
