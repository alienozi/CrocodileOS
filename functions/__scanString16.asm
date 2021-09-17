; Compile: nasm __scanString16.asm -f bin -o test.bin
; function to scan a string and store in address in bx in increasing address order
; Author: Oguz/Totan
; see od -t x1 -A n test.bin
__scanString16:
	push ax
	push bx			;push registers
__scanString16_loop1:
	xor ah, ah
	int 0x16		;get key input
	mov ah, 0x0e
	cmp al, 13		;compaire the input with enter
	je __scanString16_end	;break the loop if input is enter
	int 0x10		
	mov [bx],al		;print what key is pressed
	inc bx
	jmp __scanString16_loop1
__scanString16_end:
	mov al,10
	int 0x10		;goto the next line in screen
	mov al,13
	int 0x10
	mov [bx], byte 0 	; add ending null value for future use
	pop bx
	pop ax			;pop registers
	ret	
