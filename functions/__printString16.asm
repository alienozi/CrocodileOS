; Compile: nasm __printString16.asm -f bin -o test.bin
; function to print a string saved in bx
; Author: Oguz/Totan
; see od -t x1 -A n test.bin

__printString16:		;uses bx register for input address (only 16 bit)
	push ax			;pushing necessary registers
	push bx
	mov ah, 0x0e
__printString16_loop:
	mov al, [bx]
	cmp al, 0		;ending condition
	je __printString16_end
	int 0x10
	inc bx
	jmp __printString16_loop
__printString16_end:
	pop bx
	pop ax
	ret

