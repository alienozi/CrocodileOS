; Compile: nasm __binaryToDecimal16.asm -f bin -o test.bin
; function to print binary value as decimal in eax(uses stack)
; Author: Oguz/Totan
%ifndef __binaryToDecimal_16_def
%define __binaryToDecimal_16_def 0
%include "../functions16/__printString_16.asm"

__binaryToDecimal_16:

	push eax
	push ebx		;pushes the registers of our use
	push ecx
	push edx
	mov bx,sp
	sub sp,10
	mov ecx,10
__binaryToDecimal_16_loop1:
	xor edx,edx
	div ecx		;division
	add dl, "0"
	dec bx
	mov [bx],dl
	cmp eax, 0
	jne __binaryToDecimal_16_loop1
	push esi
	mov si,bx
	call __printString_16	;	prints the stored data
	pop esi
	add sp,10
	pop edx
	pop ecx
	pop ebx		;restores previous values
	pop eax
	ret
%endif	
