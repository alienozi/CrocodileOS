; Compile: nasm x.asm -f bin -o test.bin
; function to print a string saved in bx
; Author: Totan/Oguz
; see od -t x1 -A n xx.bin

	[bits 16]
	[org 0x7c00]			; BIOS Code load adress
	mov bp, 0x8000 			; move base stack pointer over the BIOS sector
	mov sp, bp  			; load base pointer to stack pointer

	mov cx, 10			; cx is loop counter
	mov bx,msg
dene:
	call __printString16
	loop dene

	jmp $				; Endless Loop
	
msg: 	db "AMOGUS", 0x0a , 0x0d ,0

	%include "./functions/__printString16.asm"

	times 510-($-$$) db 0		;pads the sector until the last two bytes in 512B
	dw 0xaa55			;last two bytes (word/wyde) with magic number! 
