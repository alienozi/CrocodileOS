; function to print a string starting from [ds:esi]
; Author: Totan
;set the start address of the string in esi
;write 13 for enter
;write 10 for clear screen
;write 0 to stop writing
;following register will be altered by this function eax,ebx,ecx,edi,esi
%ifndef __printString_32_def
%define __printString_32_def 0
__printString_32:
	call __printString_32_get_eip
__printString_32_get_eip:
	pop edi							;effective address of curcor is calculated with the help of eip
	add edi,__printString_32_cursor-__printString_32_get_eip
	mov ebx,0xb8000						;ebx is set to start address of text mode dma vga and used as base address in memory addressing
	mov ecx,[edi]						;cursor is loaded in ecx
__printString_32_loop:
	mov al,[ds:esi]
	inc esi							;character is read
	cmp al,10
	jne __printString_32_clear_screen_skip			;if character equal 10 screen is cleared otherwise this part of the code is skipped
	mov al," "
	mov ecx,80*25
__printString_32_clear_screen_loop:
	mov [ds:ebx+2*ecx-2],ax
	loop __printString_32_clear_screen_loop			;entire screen is filled by spaces
	jmp __printString_32_loop	
__printString_32_clear_screen_skip:
	
	cmp al,13
	jne __printString_32_enter_skip				;if character equal 13 cursor is moved to start of the next line 
	shl eax,8						;otherwise this part of the code is skipped
	mov ax,cx
	mov cl,80
	div cl
	inc al
	mul cl
	mov cx,ax
	shr eax,8
	jmp __printString_32_loop
__printString_32_enter_skip:
	test al,al
	jz __printString_32_end					;if character equals 0 function returns
	mov [ds:ebx+ecx*2],ax					;otherwise it prints the character and continous the printing loop
	inc ecx
	jmp __printString_32_loop
	__printString_32_end:
	mov [edi],ecx						;saves the current cursor for future uses
	ret
	
	__printString_32_cursor: dd 0
%endif
