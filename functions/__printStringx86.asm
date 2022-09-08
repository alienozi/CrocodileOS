; Compile: nasm __printString16.asm -f bin -o test.bin
; function to print a string starting from [ds:si]
; Author: Totan
; see od -t x1 -A n test.bin
;set the start of the address in si
;write 13 for enter
;write 10 for clear screen
;write 0 to stop writing
%ifndef __printStringx86_def
%define __printStringx86_def 0
__printStringx86:
	mov ax,0xb800
	mov gs,ax
	mov bx,[__printStringx86_cursor]
	mov ah,0x0f
__printStringx86_loop:
	mov al,[ds:si]
	inc si
	cmp al,10
	jne __printStringx86_clear_screen_skip
	mov bx,80*25*2
	mov al," "
__printStringx86_clear_screen_loop:
	mov [gs:bx-2],ax
	sub bx,2
	jnz __printStringx86_clear_screen_loop
	jmp __printStringx86_loop	
__printStringx86_clear_screen_skip:
	
	cmp al,13
	jne __printStringx86_enter_skip
	mov ax,bx
	mov bl,160
	div bl
	inc al
	mul bl
	mov bx,ax
	jmp __printStringx86_loop
__printStringx86_enter_skip:
	test al,al
	jz __printStringx86_end
	mov ah,0x0f
	mov [gs:bx],ax
	add bx,2
	jmp __printStringx86_loop
	__printStringx86_end:
	mov [__printStringx86_cursor],bx
	ret
	
	__printStringx86_cursor: dw 0
%endif
