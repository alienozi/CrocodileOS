; Compile: nasm __printString16.asm -f bin -o test.bin
; function to read sectors from an ide atapi drive
; Author: Totan
;ds:di hold the destination address of the read data
;ecx register holds the number of sectors to be read
;eax register holds the LBA of first sector to be read
;dx register holds the base address of the relevant port
;since the program most likely will not call this function with same parameters over again
;function will only restore the value of dx(eax,ecx,edi and esi may and probably will be altered)
%ifndef __IDE_ATAPI_READx86_def
%define __IDE_ATAPI_READx86_def 0
__IDE_ATAPI_READx86:
	mov esi,ecx
	ror cx,8
	ror ax,8
	ror ecx,16
	ror eax,16
	ror cx,8
	ror ax,8
	mov [__IDE_ATAPI_READx86_PACKET+2],eax
	mov [__IDE_ATAPI_READx86_PACKET+6],ecx
	xor al,al
	mov ecx,esi

	shl ecx,10		;the LSB in byte limit indicates whether the device should expect
	cmp esi,0x1f+1		;to exceed the limit or not
	mov esi,ecx		;so we set this byte accordingly
	rcl ecx,1
		

				
	inc dl
	out dx,al
	mov ax,cx
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
	
	mov eax,esi
	mov esi,__IDE_ATAPI_READx86_PACKET
	sub dl,7
	mov ecx,6
	rep outsw
	mov si,ax
	mov ch,0xff
	add dl,7
	__IDE_ATAPI_READx86_WAIT_LOOP:	;~3ms delay
	in al,dx
	loop __IDE_ATAPI_READx86_WAIT_LOOP
	mov ecx,eax
	mov cx,si
	sub dl,7
	rep insw
	ret
__IDE_ATAPI_READx86_PACKET: 
	db 0xa8,0
	times 10 db 0
%endif
