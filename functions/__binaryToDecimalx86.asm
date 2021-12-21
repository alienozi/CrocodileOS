; Compile: nasm __binaryToDecimal16.asm -f bin -o test.bin
; function to print binary value as decimal in ax(uses stack)
; Author: Oguz/Totan
; see od -t x1 -A n test.bin
%ifndef __binaryToDecimalx86_def
%define __binaryToDecimalx86_def 0
%include "__printStringx86.asm"

__binaryToDecimalx86:

	push eax
	push ebx		;pushes the registers of our use
	push ecx
	push edx
	mov bx,sp
	sub sp,6
	mov cx,10
__binaryToDecimalx86_loop1:
	xor dx,dx
	div cx		;division
	add dl, "0"
	dec bx
	mov [bx],dl
	cmp ax, 0
	jne __binaryToDecimalx86_loop1
	push esi
	mov si,bx
	call __printStringx86	;	prints the stored data
	pop esi
	add sp,6
	pop edx
	pop ecx
	pop ebx		;restores previous values
	pop eax
	ret
%endif	
