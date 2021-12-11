; Compile: nasm __binaryToDecimal16.asm -f bin -o test.bin
; function to print binary value as decimal in ax(uses stack)
; Author: Oguz/Totan
; see od -t x1 -A n test.bin
%ifndef __binaryToDecimal16_def
%define __binaryToDecimal16_def 0
%include "__printString16.asm"
__binaryToDecimal16_mem: 
	times 6 db 0
__binaryToDecimal16:

	push ax
	push bx		;pushes the registers of our use
	push cx
	push dx
	mov bx,__binaryToDecimal16_mem+4
	mov cx,10
__binaryToDecimal16_loop1:
	xor dx,dx
	div cx		;division
	add dl, "0"
	mov [bx],dl
	dec bx
	cmp ax, 0
	jne __binaryToDecimal16_loop1
	inc bx
	mov si,bx
	call __printString16
	pop dx
	pop cx
	pop bx		;restores previous values
	pop ax
	ret
%endif	
