#include<stdlib.h>
#include<stdio.h>
#include<string.h>
int main(int argn,char **argv){
	FILE *INPUT,*OUTPUT;
	INPUT=fopen(*(argv+1),"r");
	OUTPUT=fopen(*(argv+2),"w+");
	int width=atoi(*(argv+3));
	int height=atoi(*(argv+4));
	unsigned char* data_in=malloc(4*width*height);
	unsigned char* data_out=malloc(width*height+width);
	unsigned int data_len=0;char condition;
	fread(data_in,1,4*width*height,INPUT);
	fclose(INPUT);
	for(int h=0;h<height;h+=2){
		for(int w=0;w<width;w++){
			if(height-h>1){
				condition=(*(4*(h*width+w)+data_in))>127?2:(*(4*(h*width+w)+data_in+1))>127?3:(*(4*(h*width+w)+data_in+2))>127?4:1;
				switch(condition){
					case 1:
					*(data_out++)=0xdc;
					condition=(*(4*((1+h)*width+w)+data_in))>127?2:(*(4*((1+h)*width+w)+data_in+1))>127?3:(*(4*((1+h)*width+w)+data_in+2))>127?4:1;
					switch(condition){
					case 1:*(data_out++)=0x00;break;
					case 2:*(data_out++)=0x0f;break;
					case 3:*(data_out++)=0x02;break;
					case 4:*(data_out++)=0x01;break;
					}
					
					break;
					case 2:
					condition=(*(4*((1+h)*width+w)+data_in))>127?2:(*(4*((1+h)*width+w)+data_in+1))>127?3:(*(4*((1+h)*width+w)+data_in+2))>127?4:1;
					switch(condition){
					case 1:*(data_out++)=0xdf;*(data_out++)=0x0f;break;
					case 2:*(data_out++)=0xdb;*(data_out++)=0x0f;break;
					case 3:*(data_out++)=0xdf;*(data_out++)=0x2f;break;
					case 4:*(data_out++)=0xdf;*(data_out++)=0x1f;break;
					}
					break;
					case 3:
					*(data_out++)=0xdc;
					condition=(*(4*((1+h)*width+w)+data_in))>127?2:(*(4*((1+h)*width+w)+data_in+1))>127?3:(*(4*((1+h)*width+w)+data_in+2))>127?4:1;
					switch(condition){
					case 1:*(data_out++)=0x20;break;
					case 2:*(data_out++)=0x2f;break;
					case 3:*(data_out++)=0x22;break;
					case 4:*(data_out++)=0x21;break;
					}
					break;
					case 4:
					*(data_out++)=0xdc;
					condition=(*(4*((1+h)*width+w)+data_in))>127?2:(*(4*((1+h)*width+w)+data_in+1))>127?3:(*(4*((1+h)*width+w)+data_in+2))>127?4:1;
					switch(condition){
					case 1:*(data_out++)=0x10;break;
					case 2:*(data_out++)=0x1f;break;
					case 3:*(data_out++)=0x12;break;
					case 4:*(data_out++)=0x11;break;
					}
				}
			}else{
				condition=(*(4*(h*width+w)+data_in))>127?2:(*(4*(h*width+w)+data_in+1))>127?3:(*(4*(h*width+w)+data_in+2))>127?4:1;
				switch(condition){
					case 1:
					*(data_out++)=0xdc;
					*(data_out++)=0x10;
					break;
					case 2:
					*(data_out++)=0xdb;
					*(data_out++)=0x1f;
					break;
					case 3:
					*(data_out++)=0xdc;
					*(data_out++)=0x12;
					break;
					case 4:
					*(data_out++)=0xdf;
					*(data_out++)=0x11;
					break;
				}
			}
			data_len+=2;
		}
	}
	
	*(data_out+data_len)=0;
	data_out-=data_len;
	free(data_in);
	
	if(argn<6||strcmp(*(argv+5),"-C")!=0){
	//fprintf(OUTPUT,"%s",*(argv+1));
	//fseek(OUTPUT,-5,SEEK_CUR);
	//fprintf(OUTPUT,":\n");
		for(int h=0;h<data_len/width/2;h++){
			fprintf(OUTPUT,"dw ");
			for(int w=0;w<width*2;w+=2){
				fprintf(OUTPUT,"%u, ",*((unsigned short*)(data_out+h*width*2+w)));
			}
			fseek(OUTPUT,-2,SEEK_CUR);
			fprintf(OUTPUT," \n");
		}
	}else{
		fprintf(OUTPUT,"{ ");
		for(int h=0;h<data_len/width/2;h++){
			for(int w=0;w<width*2;w+=2){
				fprintf(OUTPUT,"%u, ",*((unsigned short*)(data_out+h*width*2+w)));
			}
		}
		fprintf(OUTPUT,"0 } ");
	}
	
	fclose(OUTPUT);
	free(data_out);
	return 1;
	
	
	
	
	
}
