; Compile: nasm __printString16.asm -f bin -o test.bin
; function to print a string saved in bx
; Author: Totan
; see od -t x1 -A n test.bin
;set the start of the address in si
;write 13 for enter
;write 10 for clear screen
;write 0 to stop writing
%ifndef __printStringx86_def
%define __printStringx86_def 0
__printStringx86:
	push eax			;uses si register for input address (only 16 bit)
	push ebx			;pushing necessary registers
	push esi
	mov bx, es
	push bx
	mov bx, [__printStringx86_cursor]	;get cursor
	mov ax, 0xb800
	mov es, ax
	mov ah, 0x0f
__printStringx86_main_loop:
	mov al,[si]
	cmp al,13			;compaire if its 13 which means enter
	je __printStringx86_enter
	cmp al,10			;compaire if its 10 which means clear screen
	je __printStringx86_cls
__printStringx86_write:
	cmp al,0
	je __printStringx86_end
	mov [es:bx],ax			;characters are written in DMA address for display
	inc bx
	inc bx
	inc si
	jmp __printStringx86_main_loop
__printStringx86_end:
	dec bx
	dec bx
	mov [__printStringx86_cursor],bx
	pop bx
	mov es, bx
	pop esi				;pops back used registers
	pop ebx
	pop eax
	ret
__printStringx86_enter:	
	mov ax, bx
	mov bl, 160
	div bl				;finds next rows first entry and sets cursor
	inc al
	mul bl
	mov bx, ax
	inc bx
	inc bx
	mov ah, 0x0f
	inc si
	jmp __printStringx86_main_loop
__printStringx86_cls:
	push cx
	mov bx,80*25*2-2
	xor cx,cx
__printStringx86_loop1:
	mov [es:bx],  cx		;clears screen
	dec bx
	dec bx
	jnz __printStringx86_loop1
	mov  [__printStringx86_cursor],cx
	xor bx,bx
	pop cx
	inc si
	jmp __printStringx86_main_loop
		;continues as if nothing happend from where it is left

	__printStringx86_cursor: dw 0
%endif
