; Compile: nasm __16nbit.asm -f bin -o test.bin
; function for simple math function for large numbers in 16 bit mode(little endian)
; size of the operation defined with cx (cx=5 means 5*16=80 bits)
; destination is ax and the target is bx
; Author: Oguz/Totan
; see od -t x1 -A n test.bin

	mov ax, 0x7c0
	mov ds, ax
	mov bp, 0x7000
	mov sp, 0x7000

	
	mov ax, value1
	mov bx, value2
	mov cx, 8 ; 16*8=120 bit values
	
	
	call __16nbit_add
	mov bx, value1
	loop1:
	mov ax,[bx]
	call __binaryToDecimal16
	add bx,2
	loop loop1
	jmp $
%include "__binaryToDecimal16.asm"
value1: dw 53,45,17,55,47,39,22,98
value2: dw 48, 896, 842, 68, 44, 27, 78, 99
	
__16nbit_add:
	push ax
	push bx
	push cx
	push dx
	add dx,0
__16nbit_add_loop1:
	mov dx, [bx]
	xchg bx, ax
	adc [bx], dx
	inc ax
	inc ax
	inc bx
	inc bx
	xchg bx, ax
	loop __16nbit_add_loop1
	pop dx
	pop cx
	pop bx
	pop ax
	ret
times 510 -( $ - $$ ) db 0 
dw 0xaa55
