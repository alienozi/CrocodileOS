//a primative 32-bit library for COS
//author:Totan
#ifndef COS_PRIMATIVE
#define COS_PRIMATIVE 0
void pri_print(char font, const char* format_str, ...){
	static char* cursor=(char*)0xb8000;
	unsigned int* arg_ptr = (int*)(&format_str);char temp;
	while(*format_str){
		if(*format_str == '%'){
			format_str++;
			arg_ptr++;
			switch(*format_str){
				case'c':
					*(cursor++) = *((char*)arg_ptr);*(cursor++)=font;break;
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
				case'n':
					do{
						*(cursor++)=' ';
						*(cursor++)=font;
					}while((unsigned int)cursor%160);
					break;
				case't':
					for(int i=8;i>0;i--){
						*(cursor++)=' ';
						*(cursor++)=font;
					}
					break;
				case'R':
					cursor=0;
					break;
			}
		}else{
			*cursor = *format_str;
			cursor++;
			*(cursor++)=font;
		}
		format_str++;
	}
}
#endif