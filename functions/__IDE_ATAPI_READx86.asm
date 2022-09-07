;ds:di hold the destination address of the read data
;al register holds the number of sectors to be read(this is not a long read function)
;ecx register holds the LBA of first sector to be read
;dx register holds the base address of the relevant port
;since the program most likely will not call this function with same parameters over again
;function will only restore the value of dx(ax,cx,di and si may and probably will be altered)

__IDE_ATAPI_READx86:
	ror cx,8
	ror ecx,16
	shl eax,24
	ror cx,8
	mov [__IDE_ATAPI_READx86_PACKET+2],ecx
	mov [__IDE_ATAPI_READx86_PACKET+6],eax
	shr eax,24-11
	inc dl
	out dx,al
	add dl,3
	out dx,al
	inc dl
	mov al,ah
	out dx,al
	add dl,2	
	mov al,0xa0
	out dx,al
	
	__IDE_ATAPI_READx86_wait_loop2:
	in al,dx
	test al,1<<7		;wait untily the drive is not bussy
	jnz __IDE_ATAPI_READx86_wait_loop2
	
	mov si,__IDE_ATAPI_READx86_PACKET
	sub dl,7
	mov ecx,6
	rep outsw
	mov ch,0xff
	add dl,7
	__IDE_ATAPI_READx86_WAIT_LOOP:	;~3ms delay
	in al,dx
	loop __IDE_ATAPI_READx86_WAIT_LOOP
	sub dl,7
	mov ch,ah
	shr ax,1
	rep insw
	ret
__IDE_ATAPI_READx86_PACKET: 
	db 0xa8,0
	times 14 db 0
