; Compile: nasm __printString16.asm -f bin -o test.bin
; function to print a string saved in bx
; Author: Totan
; see od -t x1 -A n test.bin
bits 16
	call jmp
	jmp:
	pop ax
	cli
	xor dx,dx
	shr ax,4
	mov ds,ax
	mov si,data1
	call __printString16
	mov dx,0x1f7
	in al,dx
	cmp al,0xff
	jne boot_stage_1
	mov dx,0x177
	in al,dx
	cmp al,0xff
	jne boot_stage_1
	mov dx,0x1ef
	in al,dx
	cmp al,0xff
	jne boot_stage_1
	mov dx,0x16f
	in al,dx
	cmp al,0xff
	jne boot_stage_1
	mov si,error1
	call __printString16
	cli
	hlt
boot_stage_1:
	sub dx,5
	mov al,3
	out dx,al
	dec al
	dec al
	inc dx
	out dx,al
	dec al
	inc dx
	out dx,al
	inc dx
	out dx,al
	inc dx
	mov al,11100000b
	out dx,al
	mov al,0x20
	inc dx
	out dx,al
	mov si,data2
	call __printString16
wait1:
	in al,dx
	test al,1
	jnz wait1
	
	sub dx,7
	mov di,ds
	shl di,4
	add di,second_stage
	mov cx,256*3
	rep insw
	mov si,data3
	call __printString16
	jmp long second_stage
data1: 
	db 0,0,"operating system found",13,0
data2:
	db "loading...",13,0
data3:
	db "second stage boot loader loaded",13,0
error1: 
	db "driver not found",0	
	%include "__printString16.asm"
	%include "__binaryToDecimal16.asm"
	times 446-($-$$) db 0
MBR_P1:
	db 0x80 ,1,1,0,0x06,16,16,16
	dd 0,4096
	times 48 db 0
	dw 0xaa55
second_stage:
mov si, data4
call __printString16
cli
hlt
data4:
	db "anan zaa xd xd",0,5
	times 1024-($-$$) db 0
