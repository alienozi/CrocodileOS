; Compile: nasm __16nbit.asm -f bin -o test.bin
; function for simple math function for unsigned large numbers in 16 bit mode(little endian)
; size of the operation defined with cx (cx=5 means 5*16=80 bits)
; destination is ax and the target is bx (valid for "add" and "sub")
; ax and bx are input start addresses and dx is the result output start address(valid for "mul" and "div")
; shl1 and shr1 are subfunctions used during "mul" and "div". They are out of my purpose
; you can use "shl1" and "shr1" if you desire but I wont bother to explain them
; Author: Oguz/Totan
; see od -t x1 -A n test.bin

	mov ax, 0x7c0
	mov ds, ax
	mov bp, 0x7000
	mov sp, 0x7000

	mov ax, value1
	mov bx, value2
	mov cx, 8 ; 16*8=120 bit values
	
	
	call __16nbit_shl1
	loop1:
	mov ax,[bx]
	call __binaryToDecimal16
	add bx,2
	loop loop1
	jmp $
%include "__binaryToDecimal16.asm"
value1: dw 0,45,17,55,47,39,22,98
value2: dw 0x8000, 7, 7, 7, 7, 0x800a, 23, 94
	
__16nbit_add:
	push ax
	push bx
	push cx
	push dx
	test cx, cx
__16nbit_add_loop1:
	mov dx, [bx]
	xchg bx, ax
	adc [bx], dx
	inc ax
	inc bx
	inc ax
	inc bx
	xchg bx, ax
	loop __16nbit_add_loop1
	pop dx
	pop cx
	pop bx
	pop ax
	ret
	
__16nbit_sub:
	push ax
	push bx
	push cx
	push dx
	test cx, cx
__16nbit_sub_loop1:
	mov dx, [bx]
	xchg bx, ax
	sbb [bx], dx
	inc ax
	inc bx
	inc ax
	inc bx
	xchg bx, ax
	loop __16nbit_sub_loop1
	pop dx
	pop cx
	pop bx
	pop ax
	ret
__16nbit_shr1:
	push ax
	push bx
	push cx
	push dx
	dec cx
__16nbit_shr1_loop1:
	mov ax, [bx]
	mov dx,[bx+2]
	shrd ax, dx,1
	mov [bx],ax
	add bx,2
	loop __16nbit_shr1_loop1
	mov ax, [bx]
	shr ax, 1
	mov [bx], ax
	pop dx
	pop cx
	pop bx
	pop ax
	ret
	__16nbit_shl1:
	push ax
	push bx
	push cx
	push dx
	dec cx
	add bx, cx
	add bx, cx
__16nbit_shl1_loop1:
	mov ax, [bx]
	mov dx,[bx-2]
	shld ax, dx, 1
	mov [bx],ax
	sub bx,2
	loop __16nbit_shl1_loop1
	mov ax, [bx]
	shl ax, 1
	mov [bx], ax
	pop dx
	pop cx
	pop bx
	pop ax
	ret
__16nbit_mul:
	push ax
	push bx
	push cx
	push dx
	mov [__16nbit_mul_control], cx
__16nbit_mul_loop1:
	push cx
__16nbit_mul_loop2:
	pop dx
	push dx
	add dx, cx
	cmp dx, [__16nbit_mul_control]
	jbe __16nbit_mul_loop2_end
	push ax
	push bx 
	push dx 
__16nbit_mul_loop2_end:	
	loop __16nbit_mul_loop2
	pop cx
	loop __16nbit_mul_loop1
	pop dx
	pop cx
	pop bx
	pop ax
	ret
__16nbit_mul_control: dw 0	
times 510 -( $ - $$ ) db 0 
dw 0xaa55
