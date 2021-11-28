; Compile: nasm __printString16.asm -f bin -o test.bin
; function to print a string saved in bx
; Author: Totan
; see od -t x1 -A n test.bin
;set the start of the address in si
;write 13 for enter
;write 0,0 for clear screen and continue to write
;write 0,0,0 for clear screen and stop writing
__printString16:
	push ax			;uses si register for input address (only 16 bit)
	push bx			;pushing necessary registers
	push si
	mov bx, es
	push bx
	mov bx, [__printString16_cursor]	;get cursor
	mov ax, 0xb800
	mov es, ax
	mov ah, 0x0f
__printString16_loop1:
	mov al,[si]
	cmp al,13			;compaire if its 13 which means enter
	jne __printString16_loop2
	mov ax, bx
	mov bl, 160
	div bl				;finds next rows first entry and sets cursor
	inc al
	mul bl
	mov bx, ax
	mov ah, 0x0f
	inc si
	jmp __printString16_loop1
	__printString16_loop2:
	mov [es:bx],ax			;characters are written in DMA address for display
	inc bx
	inc bx
	inc si
	cmp al,0
	jne __printString16_loop1
__printString16_preend:
	mov al,[si]
	cmp al,0			;check for clear screen
	jne __printString16_end
	push cx
	mov bx,80*25*2
	xor cx,cx
__printString16_loop3:
	mov [es:bx-2],  cx		;clears screen
	dec bx
	dec bx
	jnz __printString16_loop3
	mov  [__printString16_cursor],cx
	pop cx
	inc si
	jmp __printString16_loop1	;continues as if nothing happend from where it is left
__printString16_end:
	mov [__printString16_cursor],bx
	pop bx
	mov es, bx
	pop si				;pops back used registers
	pop bx
	pop ax
	ret
	__printString16_cursor: dw 0
