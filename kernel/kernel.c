//gcc -c -masm=intel -m32 kernel.c;objcopy -O binary --adjust-vma=0x100000000 -j .text kernel.o  ../iso/kernel/kernel.bin;
//../side_tools/kernelEdit ../iso/kernel/kernel.bin ../side_tools/kernel_fix.data 7;rm kernel.o;
//void print(char *str);
void print(char *str);
void tprint(char *str);
short kernel()
{	
	char* test="denem";
	char* test2="deneme55555555555";
	static char vara=32;
	static int varb=88;
	static short varx=77;
	char test111=111;short test222=222;int test333=333;
	short* p;
	tprint(test);
	print(test2);
	asm volatile("hlt");

	
	varx++;
	/*asm volatile("mov ebx,0xb8000\n");
	for(i=15;i>0;i--){
		 asm volatile("mov [ebx],word ptr 0xf030\nadd ebx,2\n");
	}*/
	 asm volatile("hlt\n");
	return varx;


	
}
void print(char *str){
	static char vara=32;
	static int varb=88;
	static short varx=77;
	short *p;
	p=(short*)0xb8000;
	while(*(str)!=0){
		*(p)=0xf000+(*(str));
		str++;
		p++;
	}
	return;
	}
void tprint(char *str){
	static char vara=32;
	static int varb=88;
	static short varx=77;
	short *p;
	p=(short*)0xb8032;
	while(*(str)!=0){
		*(p)=0xf000+(*(str));
		str++;
		p++;
	}
	return;
	}
