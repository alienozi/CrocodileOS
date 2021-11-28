; Compile: nasm x.asm -f bin -o test.bin
; function to print a string saved in bx
; Author: Totan
; see od -t x1 -A n xx.bin
[bits 16]
mov bp,0x7000
mov sp,0x7000
mov ax,0x7c0
mov ds,ax
xor ax,ax
mov si,txt
call __printString16
cli
hlt
txt: db 0,0,"anan",13,"anan",0
%include "__printString16.asm"
times 510 -( $ - $$ ) db 0 
dw 0xaa55
