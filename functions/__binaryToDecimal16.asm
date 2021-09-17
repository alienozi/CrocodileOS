; Compile: nasm __binaryToDecimal16.asm -f bin -o __binaryToDecimal16.bin
; function to print binary value as decimal in ax(uses stack)
; Author: Oguz/Totan
; see od -t x1 -A n __binaryToDecimal16.bin

	
__binaryToDecimal16:

	push ax
	push bx		;pushes the registers of our use
	push dx
	push 0x0e00	;to distinguis end of string and also an null condition for teletype
	push 0x0e0d	;new line
	push 0x0e0a	;enter
	xor dx, dx
	mov bx, 10
__binaryToDecimal16_loop1:
	div bx		;division
	add dx, 0x0e30	;making the number writable for int 10h later
	push dx		;store
	xor dx, dx
	cmp ax, 0
	jne __binaryToDecimal16_loop1
__binaryToDecimal16_loop2:
	pop ax
	int 0x10		;print stuff
	cmp ax, 0x0e00		;search for the null end
	jne __binaryToDecimal16_loop2
	pop dx
	pop bx		;restores previous values
	pop ax
	ret

