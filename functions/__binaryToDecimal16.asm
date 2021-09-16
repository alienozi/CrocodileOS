; Compile: nasm x.asm -f bin -o test.bin
; function to print a string saved in bx
; Author: Totan
; see od -t x1 -A n xx.bin
[bits 16]
mov ax, 0x7c0
mov ds, ax
mov bx,msg
mov cx,10
loop:
call __printString16
loop loop

jmp $
%include "__printString16.asm"
msg: "deneme" ,10 , 13 ,0

times 510 - ($-$$) db 0
dw 0xaa55 
