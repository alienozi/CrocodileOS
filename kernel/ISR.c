

void INT89(){
asm volatile("mov [0xb8000+160],word 0xf0db\n");
return;
}
void INT5(){
return;
}
void INT7(){
return;
}
