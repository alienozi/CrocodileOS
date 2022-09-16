#include<stdlib.h>
#include<stdio.h>
int main(int argn,char **argv){
	FILE *INPUT,*OUTPUT;
	INPUT=fopen(*(argv+1),"r");
	OUTPUT=fopen("image.asm","w+");
	int width=atoi(*(argv+2));
	int height=atoi(*(argv+3));
	unsigned char* data_in=malloc(3*width*height);
	unsigned char* data_out=malloc(((width*height)>>1)+width);
	unsigned int data_len=0;
	fread(data_in,1,3*width*height,INPUT);
	for(int h=0;h<height;h+=2){
		for(int w=0;w<width;w++){
			if(h%2==0){
				if(*(data_in+(h*width+w)*3)<127){
				
					if(*(data_in+((1+h)*width+w)*3)<127){
						*(data_out+data_len)=219;
					}else{
						*(data_out+data_len)=223;
					}
				}else{
					if(*(data_in+((1+h)*width+w)*3)<127){
						*(data_out+data_len)=220;
					}else{
						*(data_out+data_len)=32;
					}
				}
			}else{
				if(*(data_in+(h*width+w)*3)<127){
					*(data_out+data_len)=223;
				}else{
					*(data_out+data_len)=32;
				}
			}
			data_len++;
		}
	}
	fclose(INPUT);
	free(data_in);
	fprintf(OUTPUT,"%s",*(argv+1));
	fseek(OUTPUT,-5,SEEK_CUR);
	fprintf(OUTPUT,":\n");
	for(int h=0;h<data_len/width;h++){
		fprintf(OUTPUT,"db ");
		for(int w=0;w<width;w++){
			fprintf(OUTPUT,"%u, ",*(data_out+h*width+w));
		}
		fprintf(OUTPUT,"13\n");
	}
	fprintf(OUTPUT,"db 0");
	fclose(OUTPUT);
	free(data_out);
	return 1;
	
	
	
	
	
}
