#include<stdio.h>
#include<stdlib.h>

int main(int argn,char **argv){
	FILE *IN,*OUT;
	IN=fopen(*(argv+2),"r");
	OUT=fopen(*(argv+1),"r+");
	fseek(IN,0,SEEK_END);
	int size=ftell(IN);
	char *data=malloc(size);
	fseek(IN,0,SEEK_SET);
	fread(data,1,size,IN);
	fseek(OUT,atoi(*(argv+3)),SEEK_SET);
	fwrite(data,1,size,OUT);
	fclose(IN);
	fclose(OUT);
	free(data);
}
