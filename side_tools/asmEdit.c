//This code revieves 2 arguments as shown in below.
//This code translates a regular assembly file generated by gcc with -S -Mintel and -m32 options
//to raw assembly. The output file can bu compiled by nasm with -f bin option
//./asmEdit source.s raw.asm
//Author: Totan
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

int main(int argn,char **argv){
	FILE *INPUT,*OUTPUT;
	INPUT=fopen(*(argv+1),"r");
	OUTPUT=fopen(*(argv+2),"w");
	fseek(INPUT,0,SEEK_END);
	unsigned long int size=ftell(INPUT);
	fseek(INPUT,0,SEEK_SET);
	char *data_in=malloc(size+1);
	char *data_out=malloc(size+1);
	char char_ref;
	char *data_ref, *data_ref2;
	char *data_ref3=malloc(100);
	fread(data_in,1,size,INPUT);
	fclose(INPUT);
	*(data_out)=0;
	strcat(data_out,"bits 32\njmp kernel\n");
	*(data_out+size)=0;
	*(data_in+size)=0;
	strncat(data_out,data_in,strchr(data_in,'@')-data_in);
	data_ref=data_in;
	data_ref2=strchr(data_in,'@')+1;
	while(1){
		data_in=data_ref2;
		data_ref2=strchr(data_in,'@')+1;
		if((long int)data_ref2!=1){
			if(strncmp(data_in,"function\n",strlen("function\n"))==0){
				//printf("function\n");
				data_in+=strlen("function");
				strncat(data_out,data_in,data_ref2-data_in-1);
			}else if(strncmp(data_in,"GOTOFF",strlen("GOTOFF"))==0){
				//printf("gotoff\n");
				data_in+=strlen("GOTOFF");
				strncat(data_out,data_in,data_ref2-data_in-1);
			}else if(strncmp(data_in,"object\n",strlen("object\n"))==0){
				//printf("object\n");
				data_in=strchr(data_in,',')+2;
				char_ref=*(data_in);
				data_in++;
				strncat(data_out,data_in,strchr(data_in,':')-data_in+1);
				switch(char_ref){
					case '1':strcat(data_out," db ");break;
					case '2':strcat(data_out," dw ");break;
					case '4':strcat(data_out," dd ");break;
					case '8':strcat(data_out," dq ");break;
				}
				data_in=strchr(strchr(data_in,'\t')+1,'\t')+1;
				strncat(data_out,data_in,data_ref2-data_in-1);
				
				
			}else if(strncmp(data_in,"progbits",strlen("progbits"))==0){
				//printf("progbits\n");
				data_in+=strlen("progbits");
			}else{
				printf("an exception has occured in first stage\n");
			}
		}else{
			break;		
		}
	}	
	
	data_in=data_out;
	data_out=data_ref;
	data_ref2=data_in;
	data_ref=data_in;
	*(data_out)=0;
	while(1){
		data_in=data_ref2;
		data_ref2=strchr(data_in,10)+1;
		if((long int)(data_ref2)!=1){
			if(strncmp(data_in,"\t.string",strlen("\t.string"))==0){
				//printf("string\n");
				data_in+=strlen("\t.string");
				strcat(data_out,"\t db");
				strncat(data_out,data_in,data_ref2-data_in-1);
				strcat(data_out,",0\n");
			}else if(strncmp(data_in,"\t.comm\t",strlen("\t.comm\t"))==0){
				data_in+=strlen("\t.comm\t");
				strcat(data_out,"\talign ");
				strncat(data_out,strchr(strchr(data_in,',')+1,',')+1,strchr(data_in,10)-strchr(strchr(data_in,',')+1,','));
				strncat(data_out,data_in,strchr(data_in,',')-data_in);
				strcat(data_out,":\t");
				switch(*(strchr(data_in,',')+1)){
					case '1':strcat(data_out," db 0\n");break;
					case '2':strcat(data_out," dw 0\n");break;
					case '4':strcat(data_out," dd 0\n");break;
					case '8':strcat(data_out," dq 0\n");break;
				}
			}else if(*(data_in)=='#'||('0'<=*(data_in)&&'9'>=*(data_in))){
				//printf("dummy_label\n");
			}else if(strncmp(data_in,"\t.",2)==0){
				//printf("dummy lines\n");
			}else{
				//printf("label\n");
				strncat(data_out,data_in,data_ref2-data_in);
			}
		}else{
			break;		
		}
	}
	
	data_in=data_out;
	data_out=data_ref;
	data_ref2=data_in;
	data_ref=data_in;
	*(data_out)=0;
	while(1){
		data_in=data_ref2;
		data_ref2=strstr(data_in," PTR ")+4;
		if((long int)(data_ref2)!=4){
			if(data_in==data_ref||(strncmp(data_in-strlen("BYTE PTR"),"BYTE PTR",strlen("BYTE PTR"))==0)||(strncmp(data_in-strlen("WORD PTR"),"WORD PTR",strlen("WORD PTR"))==0)||(strncmp(data_in-strlen("DWORD PTR"),"DWORD PTR",strlen("DWORD PTR"))==0)||(strncmp(data_in-strlen("QWORD PTR"),"QWORD PTR",strlen("QWORD PTR"))==0)){
				//printf("string\n");
			}else{
				printf("unexpected \"PTR\"\n");
			}
			strncat(data_out,data_in,data_ref2-data_in-4);
		}else{
			break;		
		}
	}
	if(!((strncmp(data_in-strlen("BYTE PTR"),"BYTE PTR",strlen("BYTE PTR"))==0)||(strncmp(data_in-strlen("WORD PTR"),"WORD PTR",strlen("WORD PTR"))==0)||(strncmp(data_in-strlen("DWORD PTR"),"DWORD PTR",strlen("DWORD PTR"))==0)||(strncmp(data_in-strlen("QWORD PTR"),"QWORD PTR",strlen("QWORD PTR"))==0))){
				printf("unexpected \"PTR\"\n");
			}
	strcat(data_out,data_in);
	
	data_in=data_out;
	data_out=data_ref;
	data_ref2=data_in;
	data_ref=data_in;
	*(data_out)=0;
	int offset_count=0;
	while(1){
		data_in=data_ref2;
		data_ref2=strstr(data_in,"OFFSET FLAT:_GLOBAL_OFFSET_TABLE_\n");
		if((long int)(data_ref2)!=0){
			while(*(data_ref2)!=10){
				data_ref2--;
			}
			strncat(data_out,data_in,data_ref2-data_in);
			sprintf(data_ref3,"\n OFFSET_LABEL%d:",offset_count);
			strcat(data_out,data_ref3);
			strncat(data_out,data_ref2,strstr(data_in,"OFFSET FLAT:_GLOBAL_OFFSET_TABLE_\n")-data_ref2);
			data_ref2=strstr(data_in,"OFFSET FLAT:_GLOBAL_OFFSET_TABLE_\n");
			sprintf(data_ref3," -OFFSET_LABEL%d\n",offset_count);
			strcat(data_out,data_ref3);
			data_ref2+=strlen("OFFSET FLAT:_GLOBAL_OFFSET_TABLE_\n");
			offset_count++;
		}else{
			break;		
		}
	}
	strcat(data_out,data_in);
		
	while(strstr(data_out,"\n.")!=0){
		size=strchr(strstr(data_out,"\n."),':')-strstr(data_out,"\n.")-1;
		strncpy(data_ref3,strstr(data_out,"\n.")+1,size);
		*(data_ref3+size)=0;
		//printf("%s\n",data_ref3);
		while(strstr(data_out,data_ref3)!=0){
			*(strstr(data_out,data_ref3))='_';
		}
	}
	strcpy(data_ref3,"       ");
	while(strstr(data_out,"endbr32")!=0){
	strncpy(strstr(data_out,"endbr32"),data_ref3,7);
	}
	
	
	data_in=data_out;
	data_out=data_ref;
	data_ref2=data_in;
	data_ref=data_in;
	*(data_out)=0;
	
	while(strchr(data_in,'[')!=0){
		data_ref2=strchr(data_in,'[');
		while(*(data_ref2)!=' '){
			data_ref2--;
		}
		strncat(data_out,data_in,data_ref2-data_in+1);
		size=strchr(data_in,'[')-data_ref2-1;
		strcat(data_out,"[");
		if(size>0){
			strncat(data_out,data_ref2+1,size);
			strcat(data_out,"+");
		}else{
		
		}
		data_in=strchr(data_in,'[')+1;	
	}
	strcat(data_out,data_in);
	
	fwrite(data_out,1,strlen(data_out),OUTPUT);
	fclose(OUTPUT);
	free(data_ref);
	free(data_out);
	free(data_ref3);
	return 1;
}
