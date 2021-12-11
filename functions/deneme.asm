; Compile: nasm x.asm -f bin -o test.bin
; function to print a string saved in bx
; Author: Totan
; see od -t x1 -A n xx.bin
[bits 16]
mov ax,0x7c0
mov ds,ax
mov bp,0x7000
mov sp,bp
mov si,data
mov ax,52069
call __printString16
call __binaryToDecimal16
mov si,data2
call __printString16
cli
hlt
%include "__binaryToDecimal16.asm"
%include "__printString16.asm"
data:
	db 0,0,0
data2:
	db "aanan",13,0,10
times 510-($-$$) db 0
dw 0xaa55
