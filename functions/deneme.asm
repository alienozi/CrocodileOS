; Compile: nasm x.asm -f bin -o test.bin
; function to print a string saved in bx
; Author: Totan
; see od -t x1 -A n xx.bin
[bits 16]
mov ax,0x7c0
mov ds,ax
mov bp,0x7000
mov sp,bp
mov si,data2
call __printStringx86
mov al, 0xdd
out 0x64, al
mov eax, 0x80000000|0x10|0b0001100000000000
mov dx,0xcf8
out dx,eax
mov dx,0xcfc
mov cx,10000
loop:
loop loop
in eax,dx
call __binaryToDecimalx86
mov si,data
call __printStringx86
shr eax,16
call __binaryToDecimalx86
mov si,data
call __printStringx86
mov ebx,eax
xor cx,cx
mov eax,[0x28]
call __binaryToDecimalx86
mov si,data
call __printStringx86
shr eax,16
call __binaryToDecimalx86
cli
hlt
%include "__binaryToDecimalx86.asm"
%include "__printStringx86.asm"
data2:
	db 10,"aanan"
data:
	db 13,0

times 510-($-$$) db 0
dw 0xaa55
