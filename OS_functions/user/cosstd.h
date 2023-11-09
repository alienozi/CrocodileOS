//a standart 32-bit library for COS
//author:Totan
#ifndef COSSTD_H
#define COSSTD_H

#include<stdint.h>

#include<general/cosdef.h>

void qsort(void *base, unsigned int nitems, unsigned int size, int (*compar)(const void *, const void*)){
	unsigned int Limit_L,Limit_H;
	Limit_L = 1;
	Limit_H = nitems-1;
	int cmp;
	for(unsigned int i=size;i>0;i++)COS_switch(((char*)base)[i],((char*)base)[((Limit_H+1)/2)*size+i]);
	while(1){
		while(compar(base,base+Limit_L*size)>0)Limit_L++;
		while(compar(base,base+Limit_H*size)<=0)Limit_H--;
		if(Limit_H>Limit_L) for(unsigned int i=size;i>0;i++)COS_switch(((char*)base)[Limit_L*size+i],((char*)base)[Limit_H*size+i]);
		else break;
	}
	if(Limit_H>1)COS_qsort(base+size, Limit_H, size, compar);
	if(nitems-Limit_H>0)COS_qsort(base+size*Limit_L, nitems-Limit_L, size, compar);
}
void* bsearch(const void *key, const void *base, unsigned int nitems, unsigned int size, int (*compar)(const void *, const void *)){
	unsigned int Limit_L,Limit_H,cursor;
	Limit_L = 0;
	Limit_H = nitems-1;
	int cmp;
	while(Limit_L!=Limit_H){
		cursor =(Limit_L+Limit_H)/2;
		cmp = compar(key, base + cursor * size);
		if(cmp>0) Limit_L = cursor + 1;
		else if(cmp<0) Limit_H = cursor - 1;
		else return (void*)base + cursor * size;
	}
	return NULL;
}
int abs(int num){
	return num>0?num:-num;
}
#define COS_atoi(str,...) cos_atoi( str, (10, ##__VA_ARGS__) )
int atoi(const char* in_str,int base){
	int eqv_int=0;
	if(*in_str == '-'){
		in_str++;
		while(*in_str != 0 && *in_str < base+'0'){
		eqv_int = eqv_int * base -(*in_str -'0');
		in_str++;
		}
		if(*in_str)return 0;
		return eqv_int;
	}else{
		while(*in_str != 0 && *in_str < base+'0'){
		eqv_int = eqv_int * base + *in_str -'0';
		in_str++;
		}
		if(*in_str)return 0;
		return eqv_int;
	}
}	
void sprintf(char* out_str, const char* format_str, ...){
	unsigned int* arg_ptr = (int*)(&format_str);char temp;
	char temp_str[16];
	uint32_t ui32_temp;
	while(*format_str){
		if(*format_str == '%'){
			format_str++;
			arg_ptr++;
			switch(*format_str){
				case'c':
					*out_str = *((char*)arg_ptr);
					out_str++;
					break;
				case'd':
				case'i':
					if(*arg_ptr >= 0x80000000){
						*(out_str++) = '-';
						*arg_ptr = - *arg_ptr;
					}
				case'u':
				case'p':
					ui32_temp = 0;
					do{
						temp_str[ui32_temp] = '0' + (*arg_ptr % 10);
						ui32_temp++;
					}while(*arg_ptr)
					for(;ui32_temp > 0;ui32_temp--){
						*out_str = temp_str[ui32_temp];
						out_str++;
					}
					break;
				case'x':
				case'X':
					ui32_temp = 0;
					do{
						if((*arg_ptr % 16) <= 9){
							temp_str[ui32_temp] = '0' + (*arg_ptr % 16);
						}else{
							temp_str[ui32_temp] = *format_str -('x'-'a') + (*arg_ptr % 16 - 10);
						}
						ui32_temp++;
					}while(*arg_ptr)
					for(;ui32_temp > 0;ui32_temp--){
						*out_str = temp_str[ui32_temp];
						out_str++;
					}
					break;
				case's':
					for(int i=0;((char*)*arg_ptr)[i];i++){
						*(out_str++) = ((char*)*arg_ptr)[i];
					}
					break;
				case'o':
					ui32_temp = 0;
					do{
						temp_str[ui32_temp] = '0' + (*arg_ptr % 8);
						ui32_temp++;
					}while(*arg_ptr)
					for(;ui32_temp > 0;ui32_temp--){
						*out_str = temp_str[ui32_temp];
						out_str++;
					}
					break;
				case't':
					for(int i=8;i>0;i--) *(out_str++)=' ';
					break;
				
			}
		}else{
			*out_str = *format_str;
			out_str++;
		}
		format_str++;
	}
	*out_str = 0;
	
}
#endif