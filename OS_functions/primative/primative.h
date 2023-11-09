//a primative 32-bit library for COS bootloader
//author:Totan
#ifndef PRIMATIVE_H
#define PRIMATIVE_H
#include<stdint.h>
#include<stdbool.h>

#define TEXT_MODE_VGA_VIDEO_MEM_ADDR	((char*)0xb8000)
#define TEXT_MODE_VGA_ROW_NUMBER		80
#define TEXT_MODE_VGA_COLUMN_NUMBER		24
#define TEXT_MODE_VGA_VIDEO_MEM_SIZE			(TEXT_MODE_VGA_ROW_NUMBER * TEXT_MODE_VGA_COLUMN_NUMBER * sizeof(uint16_t))

//Following functions are very primative and can cause unintended behaviour in many cases
//These funtions are intended to be used only pre kernel stage of the OS
void pri_print(char font, const char* format_str, ...){
	static char* cursor=(char*)TEXT_MODE_VGA_VIDEO_MEM_ADDR;
	unsigned int* arg_ptr = (int*)(&format_str);
	char temp;
	while(*format_str){
		if(*format_str == '%'){
			format_str++;
			arg_ptr++;
			switch(*format_str){
				case'c':
					*(cursor++) = *((char*)arg_ptr);
					*(cursor++)=font;
					break;
				case'd':
				case'i':
					if(*arg_ptr >= 0x80000000){
						*(cursor++) = '-';
						*(cursor++)=font;
						*arg_ptr = - *arg_ptr;
					}
				case'u':
				case'p':
					asm inline volatile("push 10\n");
					do{
						asm volatile("push %0\n"::"r"(*arg_ptr % 10));
						 *arg_ptr /=10;
					}while(*arg_ptr);
					asm inline volatile("pop edx\nadd dl,'0'\n":"=d"(temp):);
					while(temp <= '9'){
						*cursor = temp;
						cursor++;
						*(cursor++)=font;
						asm inline volatile("pop edx\nadd dl,'0'\n":"=d"(temp):);
					}
					break;
				case'x':
				case'X':
					asm inline volatile("push 127\n");
					do{
						asm volatile("push %0\n"::"r"(*arg_ptr % 16 > 9 ?(*arg_ptr % 16) + *format_str -('x'-'a')-10:(*arg_ptr % 16)+'0'));
						 *arg_ptr /=16;
					}while(*arg_ptr);
					asm inline volatile("pop edx\n":"=d"(temp):);
					while(temp <= 'f'){
						*cursor = temp;
						cursor++;
						*(cursor++)=font;
						asm inline volatile("pop edx\n":"=d"(temp):);
					}
					break;
				case's':
					for(int i=0;((char*)*arg_ptr)[i];i++){
						*(cursor++) = ((char*)*arg_ptr)[i];
						*(cursor++)=font;
					}
					break;
				case'o':
					asm inline volatile("push 10\n");
					while(*arg_ptr){
						asm volatile("push %0\n"::"r"(*arg_ptr % 8));
						 *arg_ptr /=8;
					}
					asm inline volatile("pop edx\nadd dl,'0'\n":"=d"(temp):);
					while(temp <= '7'){
						*cursor = temp;
						cursor++;
						*(cursor++)=font;
						asm inline volatile("pop edx\nadd dl,'0'\n":"=d"(temp):);
					}
					break;
			}
		}else if(*format_str == '\n'){
			do{
				*(cursor++)=' ';
				*(cursor++)=font;
			}while(((unsigned int)cursor - 0xb8000)%160);
			if(cursor > TEXT_MODE_VGA_VIDEO_MEM_SIZE + TEXT_MODE_VGA_VIDEO_MEM_ADDR) cursor = TEXT_MODE_VGA_VIDEO_MEM_ADDR;
		}else if(*format_str == '\t'){
			for(int i=8;i>0 && ((unsigned int)cursor - 0xb8000)%160 != 0;i--){
				*(cursor++)=' ';
				*(cursor++)=font;
			}
		}else if(*format_str == '\b'){
			cursor=TEXT_MODE_VGA_VIDEO_MEM_ADDR;
		}else{
			*cursor = *format_str;
			cursor++;
			*cursor = font;
			cursor++;
		}
		format_str++;
	}
}
void pri_fill(void* dest, uint8_t u8_filler, uint32_t u32_size){
	uint8_t* u8p_dest;
	u8p_dest = dest;
	for(int i=0;i<u32_size;i++) u8p_dest[i] = u8_filler;
}
void pri_cpy(void* dest, const void* src, uint32_t u32_size){
	asm inline volatile("rep movsb\n"::"D"(dest), "S"(src), "c"(u32_size));
}
bool pri_cmp(const void* dest, const void* src, uint32_t u32_size){
	bool ret;
	asm inline volatile("repe cmpsb\nsete al\n":"=a"(ret):"D"(dest), "S"(src), "c"(u32_size));
	return ret;
}
#endif