; Compile: nasm __binaryToDecimal16.asm -f bin -o test.bin
; function to print binary value as decimal in eax(uses stack)
; Author: Totan
%ifndef __binaryToDecimal_32_def
%define __binaryToDecimal_32_def 0
%include "./functions32/__printString_32.asm"

__binaryToDecimal_32:

	push ebp
	push 0
	mov ebp,esp
	mov ebx,esp
	sub esp,12
	mov ecx,10
	
__binaryToDecimal_32_loop1:
	xor edx,edx
	div ecx		;division
	add dl, "0"
	dec ebx
	mov [ebx],dl
	test eax, eax
	jnz __binaryToDecimal_32_loop1
	mov esi,ebx
	mov ah,0x0f
	call __printString_32	;	prints the stored data
	add esp,16
	pop ebp
	ret
%endif	
