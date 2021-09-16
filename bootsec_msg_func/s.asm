; Compile: nasm bootsec_func_msg.asm -f bin -o test.bin
; A simple boot sector program
; Author: Oguz
; see od -t x1 -A n xx.bin

	[org 0x7c00]			; BIOS Code load adress
	mov bp, 0x8000 			; move base stack pointer over the BIOS sector
	mov sp, bp  			; load base pointer to stack pointer
	
	mov ah, 0x0e			; int 10/ah = 0eh -> scroll teletype BIOS
	%include "__printString16.asm"	
	mov bx, msg			; bx is parameter move the memory address of our message string into bx
	call __printString16
	jmp $



	times 510-($-$$) db 0		;pads the sector until the last two bytes in 512B
	dw 0xaa55			;last two bytes (word/wyde) with magic number! 

;DATA
msg:	db 'ANAN',0 
