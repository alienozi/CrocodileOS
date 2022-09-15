; function to print a string starting from [ds:si]
; Author: Totan
;set the start address of the string in si
;write 13 for enter
;write 10 for clear screen
;write 0 to stop writing
;following registers will be altered by this function ax,bx,si,gs
%ifndef __printString_16_def
%define __printString_16_def 0
__printString_16:
	mov ax,0xb800
	mov gs,ax					;sets gs to start address of vga text mode dma
	mov bx,[__printString_16_cursor]		;loads the cursor to bx
	mov ah,0x0f					;sets ah for color select
__printString_16_loop:
	mov al,[ds:si]
	inc si						;reads a character from the string and skip clear_screen part unless it is equal to 10
	cmp al,10
	jne __printString_16_clear_screen_skip
	mov bx,80*25*2
	mov al," "					;performs a screen clear by filling the screen by spaces
__printString_16_clear_screen_loop:
	mov [gs:bx-2],ax
	sub bx,2
	jnz __printString_16_clear_screen_loop
	jmp __printString_16_loop	
__printString_16_clear_screen_skip:
	
	cmp al,13
	jne __printString_16_enter_skip
	mov ax,bx					;moves the curcor to the start of next line
	mov bl,160
	div bl
	inc al
	mul bl
	mov bx,ax
	jmp __printString_16_loop
__printString_16_enter_skip:
	test al,al
	jz __printString_16_end				;if character equals to 0 end the printing proccess
	mov ah,0x0f
	mov [gs:bx],ax
	add bx,2
	jmp __printString_16_loop
	__printString_16_end:
	mov [__printString_16_cursor],bx		;saves the current cursor for future uses
	ret
	
	__printString_16_cursor: dw 0
%endif
