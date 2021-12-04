; Compile: nasm x.asm -f bin -o test.bin
; function to print a string saved in bx
; Author: Totan
; see od -t x1 -A n xx.bin
[bits 16]
mov ax,0x7c0
mov ds,ax
mov si,data
mov cx,5
loop:
call __printString16
loop loop
cli
hlt
data:
db "anaan",0
%include "__printString16.asm"
times 510-($-$$) db 0
dw 0xaa55
