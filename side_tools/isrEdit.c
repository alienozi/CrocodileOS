#include<stdio.h>
#include<stdlib.h>
#include<string.h>

int main(int argn,char **argv){
	FILE *ASM,*BIN,*ISR,*IDT;
	ASM=fopen(*(argv+1),"r");
	BIN=fopen(*(argv+2),"r");
	ISR=fopen(*(argv+3),"w");
	IDT=fopen(*(argv+4),"w");
	int int_n=0;
	fseek(ASM,0,SEEK_END);
	fseek(BIN,0,SEEK_END);
	unsigned long int size_asm=ftell(ASM);
	unsigned long int size_bin=ftell(BIN);
	fseek(ASM,0,SEEK_SET);
	fseek(BIN,0,SEEK_SET);
	char data_buf[100];
	char* data_asm=malloc(size_asm+1);
	char* data_bin=malloc(size_bin+1);
	char* data_idt=malloc(size_bin+1);
	char *ref_asm=data_asm,*ref_bin=data_bin;
	*(data_asm+size_asm)=0;
	*(data_bin+size_bin)=0;
	*(data_idt+size_bin)=0;
	*(data_idt)=0;
	fread(data_asm,1,size_asm,ASM);
	fread(data_bin,1,size_asm,BIN);
	fclose(ASM);
	fclose(BIN);
	
	strcat(data_idt,"bits 32");
	unsigned int entry;
	do{
		entry=(*((unsigned int*)data_bin));
		data_bin+=4;
		int_n++;
		data_asm=strstr(data_asm,"\nINT");
		strncat(data_idt,data_asm,strchr(data_asm,':')-data_asm);
		data_asm++;
		strcat(data_idt,"_OFFSET:");
		sprintf(data_buf," dd %u",entry);
		strcat(data_idt,data_buf);	
	}while((*((unsigned int*)data_bin))!=0);
	fwrite(data_idt,1,strlen(data_idt),IDT);
	fclose(IDT);
	free(data_idt);
	free(ref_asm);
	fwrite(data_bin,1,strlen(data_bin)-(int_n<<2),ISR);
	free(ref_bin);
	fclose(ISR);
	
	

}
