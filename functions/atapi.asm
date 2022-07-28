bits 16
	call jmp
	jmp:
	pop ax
	cli
	shr ax,4
	mov ds,ax
	mov si,data1
	call __printStringx86
	mov dx,0x1f2
	mov cx,4
	xor ah,ah
	mov si,enter
	leloop:
	in al,dx
	inc dx
	call __binaryToDecimalx86
	call __printStringx86
	loop leloop
	xor ah,ah
	mov cx,1000
	lopp2:
	loop lopp2
	mov al,0xa1
	mov dx,0x1f7
	out dx,al
	mov cx,100
	lopp:
	in al,dx
	loop lopp
	wait1:
	in al,dx
	call __binaryToDecimalx86
	test al,9
	jz wait1
	mov dx, 0x1f0
	mov cx,256
	mov si,enter+1
	mov bx,data
	loopy:
	in ax,dx
	;ror ax,8
	mov [bx],ax
	add bx,2
	loop loopy
	mov si,data+54
	call __printStringx86
	mov si,enter
	call __printStringx86
	mov bx,data+47*2
	mov ax,[bx]
	call __binaryToDecimalx86
	mov dx,0x1f2
	mov cx,4
	xor ah,ah
	mov si,enter
	leloop2:
	in al,dx
	inc dx
	call __binaryToDecimalx86
	call __printStringx86
	loop leloop2
		hlt
data1: 
	db 10,"operating system found"
enter:	db 13," ",0
%include "__printStringx86.asm"
%include "__binaryToDecimalx86.asm"
data:
times 510-($-$$) db 0
dd 0xaa55
