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
int kernel(){

	printS("test",0xf0);
	
	/*asm volatile("mov ebx,0xb8000\n");
	for(i=15;i>0;i--){
		 asm volatile("mov [ebx],word ptr 0xf030\nadd ebx,2\n");
	}*/
	 asm volatile("hlt\n");
	return 1;


	
}


