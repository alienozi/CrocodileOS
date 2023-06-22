//a 32-bit kernel for COS
//author:Totan
#include<primative.h>
int test(){
	pri_print(0x0f,"test");
	return 0;
}
int main(int argn,char** argv, char** env){
	pri_print(0x0f,"deneme deneme 1 2 3");
	pri_print(0x0f,"deneme d443");
	asm volatile inline("hlt\n");
}