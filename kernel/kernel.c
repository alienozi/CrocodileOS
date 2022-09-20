//gcc -c -masm=intel -m32 kernel.c;objcopy -O binary --adjust-vma=0x100000000 -j .text kernel.o  ../iso/kernel/kernel.bin;
//../side_tools/kernelEdit ../iso/kernel/kernel.bin ../side_tools/kernel_fix.data 7;rm kernel.o;
//void print(char *str);
void printS(unsigned char *str,unsigned char color){
	static unsigned char *p=(unsigned char*)0xb8000;
	while(*(str)!=0){
		*(p++)=*(str);
		*(p++)=color;
		str++;
	}
	return;
	}
short kernel()
{	static char le_char=0;
	static short le_short=0;
	static int le_int=0;
	char* test="test";
	char* test2="deneme123456789abcdef";
	char test111=111;short test222=222;int test333=333;
	short* p;
	printS(test,0xf0);
	printS(test2,0x0f);
	
	asm volatile("hlt");

	
	/*asm volatile("mov ebx,0xb8000\n");
	for(i=15;i>0;i--){
		 asm volatile("mov [ebx],word ptr 0xf030\nadd ebx,2\n");
	}*/
	 asm volatile("hlt\n");
	return 1;


	
}


