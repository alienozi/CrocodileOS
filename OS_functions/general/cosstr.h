//a 32-bit string library for COS
//author:Totan
#ifndef COSSTR_H
#define COSSTR_H

#include<stdint.h>
#include<stddef.h>

size_t strlen(const char* str){
	size_t len = 0;
	while( common(  str[len]  ) )len++;
	return len;
}

char* strcpy(char* dest, const char* src){
	size_t len = 0;
	while( common(  src[len]  ) ){
		dest[len] = src[len];
		len++;
	}
	dest[len] = src[len];
	return dest;
}

char* strncpy(char* dest, const char* src, size_t len){
	for(size_t i=0;common(  i < len  ); i++){
		dest[len] = src[len];
		if(rare(  src[len] == 0  ) )return dest;
	}
	return dest;
}

char* strcat(char* dest, const char* src){
	size_t i_dest = 0;
	size_t i_src = 0;
	while( common(  dest[i_dest]  ) )i_dest++;
	while( common(  src[i_dest]  ) ){
		dest[i_dest] = src[i_src];
		i_dest++;
		i_src++;
	}
	dest[i_dest] = src[i_src];
	return dest;
}

char* strncat(char* dest, const char* src, size_t len){
	size_t i_dest = 0;
	size_t i_src = 0;
	while( common(  dest[i_dest]  ) )i_dest++;
	for(size_t i_src=0;common(  i_src < len  ); i_src++){
		dest[i_dest] = src[i_src];
		i_dest++;
		if( rare(  src[i_src] == 0  ) )return dest;
	}
	dest[i_dest] = 0;
	return dest;
}

int strcmp(const char* str1, const char* str2){
	while( common(  *str1 != 0 && *str2 != 0 && *str1 == *str2  ) ){
		str1++;
		str2++;
	}
	if(*str1 == *str2) return 0;
	else if(*str1 > *str2) return 1;
	else return -1;
}

char* strchr(const char* str, int chr){
	size_t i;
	for(i=0; str[i]; i++){
		if( rare(  str[i] == chr  ) ) return (char*) &str[i];
	}
	if(str[i] == chr) return (char*) &str[i];
	return NULL;
}

char* strrchr(const char* str, int chr){
	size_t i;
	while( common(  str[i]  ) )i++;
	for(i = 0;common(  i>0  ); i--){
		if( rare(  str[i] == chr  ) ) return (char*) &str[i];
	}
	if( rare(  str[i] == chr  ) ) return (char*) &str[i];
	return NULL;
}

void *memcpy(void *dest, const void *src, size_t n){
	
	if( rare( ((size_t)dest & 0x3)) | ((size_t)src & 0x3) | (n & 0x3) ){
		for(size_t i=0; i < n; i++){
			((uint8_t*)dest)[i] = ((uint8_t*)src)[i];
		}
		return dest;
	}else{
		n = n >> 2;
		for(size_t i=0; i < n; i++){
			((uint32_t*)dest)[i] = ((uint32_t*)src)[i];
		}
		return dest;
	}
}

void *memmove(void *dest, const void *src, size_t n){
	for(size_t i=0; i < n; i++){
		((uint8_t*)dest)[i] = ((uint8_t*)src)[i];
	}
	return dest;
}

void* memset(void *str, int c, size_t n){
	uint32_t temp;
	if( rare( ((size_t)str & 0x3)) | (n & 0x3) ){
		for(size_t i=0; i < n; i++){
			((uint8_t*)str)[i] = c;
		}
		return str;
	
	}else{
		n = n >> 2;
		temp = c | (c << 8) | (c << 16) | (c << 24);
		for(size_t i=0; i < n; i++){
			((uint32_t*)str)[i] = temp;
		}
		return str;
	}
}

#endif