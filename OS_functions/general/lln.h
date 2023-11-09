#ifndef LLN.H
#define LLN.H

#include<stdint.h>
#include<general/cosdef.h>
typedef struct{
	uint32_t u32_size;	//in double words
	uint32_t* u32p_num;
}Lln;

uint32_t lln_add(Lln* dest, Lln* src1, Lln* src2){

	bool carry = false;

	if(dest == NULL || src1 == NULL || src2 == NULL) return -1;

	if(dest->u32_size != src1->u32_size || dest->u32_size != src2->u32_size) return -1;

	for(int i=0;i<dest->u32_size;i++){
		dest->u32p_num[i] = carry ? src1->u32p_num[i] + src2->u32p_num[i] + 1 : src1->u32p_num[i] + src2->u32p_num[i] ;
		carry = dest->u32p_num[i] < src1->u32p_num[i];
	}
	return 0;
}
uint32_t lln_sub(Lln* dest, Lln* src1, Lln* src2){

	bool borrow = false;

	if(dest == NULL || src1 == NULL || src2 == NULL) return -1;

	if(dest->u32_size != src1->u32_size || dest->u32_size != src2->u32_size) return -1;

	for(int i=0;i<dest->u32_size;i++){
		dest->u32p_num[i] = carry ? src1->u32p_num[i] - src2->u32p_num[i] - 1 : src1->u32p_num[i] - src2->u32p_num[i] ;
		carry = dest->u32p_num[i] > src1->u32p_num[i];
	}
	return 0;
}
#endif