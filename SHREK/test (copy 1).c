static int f=55;
static short g=44;
static char t=88;
static char ff[10];
static short s5s[10];
static int ii[10];
static const char jj[11];
static char grr[16]="kure\t\x7\1\4t";
	static const short grr2[7]={0,0,0,3,4,6};
	//static const int grr3[7]={0,1,2,3,4,5,6};
	static char gqrr[7]={0,0,0,3,4,5};
	static short gqrr2[7]={1,2,3,4};
	//static int gqrr3[7]={0,1,2,3,4,5,6};
void func(const char* ptr){
	ptr++;
}
void fcall(void f(const char* chr)){
	f("kolpa");
}
//void fun(int kk);
//void ffff();
int test(){
	static char gg[10];
	static const char rr[7]="test2\n";
	static const short rr2[7]={0,1,2,3,4,5,6};
	static const int rr3[7]={0,1,2,3,4,5,6};
	static char qrr[7]={0,1,2,3,4,5,6};
	static short qrr2[7]={0,1,2,3,4,5,6};
	//static int qrr3[7]={0,1,2,3,4,5,6};
	char a;
	//ffff();
	static char b;
	static const char c;
	short a1;
	static short b1;
	static const short c1;
	int a2;
	static int b2;
	static const int c2;
	fcall(func);
	func("denemel-kolpa ");
	func("kolpa");
	//fun(33);
	ff[5]=88;
	b=77;
	b1=88;
	b2=99;
	a1=44;
	b++;
	b1++;
}