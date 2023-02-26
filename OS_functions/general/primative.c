void COS_sprintf(char* out_str, const char* format_str, ...){
	int* arg_ptr = (int*)format_str;
	int i_out=0;
	for(int i_format=0;format_str[i_format]!=0;i_format++){
		if(format_str[i_format]=='%'){
			i_format++;
			arg_ptr++;
			switch(format_str[i_format]){
				case'c':
					out_str[i_out] = *((char*)arg_ptr);i_out++;break;
				case'u':
				case'p':
					asm inline volatile("push 10\n");
					while(*arg_ptr){
						asm volatile("push %0\n"::"r"(*arg_ptr % 10));
						 *arg_ptr /=10;
					}
					do{
						asm volatile("pop %0\nadd %0,'0'":"r"(out_str[i_out]):);
					}while(out_str[i_out++]<='9');
					break;
				case'x':
				case'X':
				
					
			}
			i_format++;
		}

	}
	
}