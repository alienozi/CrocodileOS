bits 16
call ip_get
ip_get:			
	pop bx		;push IP to stack then pop it to ax
	cli		;we assume that this boot sector is loaded to a address divisable by 16
	shr bx,4
	mov ds,bx
	mov es,bx
	mov bp,0x7000	;set stack and base pointers
	mov sp,bp
	mov si,msg1
	call __printStringx86
	
	xor ax,ax
	xor bx,bx
IDE_SM_SCAN_LOOP:
	mov dx,0x176
	out dx,al
	add dl,0xf0-0x70	;sets dx to 0x1F6
	out dx,al
	
	inc dl
	mov cx,15
IDE_DRIVE_SELECT_WAIT_LOOP:

	in al,dx
	loop IDE_DRIVE_SELECT_WAIT_LOOP
	
	inc bl
	test al,0x04
	jnz skip_loop
	call IDE_DEVICE_DETECTED
skip_loop:
	sub dx,0xf0-0x70	;sets dx to 0x177
	in al,dx
	inc bl
	test al,0x04
	jnz skip_loop_2
	call IDE_DEVICE_DETECTED
skip_loop_2:
	mov al,1<<4
	test bl,2
	jnz IDE_SM_SCAN_LOOP
	
IDE_DEVICE_NOT_FOUND:
	mov si,msg2
	call __printStringx86
	hlt
	
IDE_DEVICE_DETECTED:
	
port_test:
	mov al,0xa1
	mov cl,5
	out dx,al
retry_loop:
	
wait_loop:
	in al,dx
	test al,1<<7		;wait untily the drive is not bussy
	jnz wait_loop
	
	test al,1		;check for an error if it exists retry it again up to four times
	loopnz retry_loop
	jz IDE_DEVICE_NO_ERROR
	ret
IDE_DEVICE_NO_ERROR:
	test al,1<<5
	jnz drive_fault		;check for a drive fault
	test al,1<<3		;check if drive is ready if not retry it again up to four times
	loopz retry_loop
	jnz ATAPI_DEVICE_FOUND
	ret


drive_fault:
	
	hlt

	%include "../functions/__printStringx86.asm"
	%include "../functions/__binaryToDecimalx86.asm"
	
	
times 510-($-$$) db 0
dw 0xaa55
	ATAPI_DEVICE_FOUND:		;stores the identify packet device data
	pop bx
	sub dx,7		;substract 7 to get data port
	
	mov si,msg1
	call __printStringx86
	mov di,IDENTIFY_PACKET_DEVICE_DATA
	mov cx,256
	rep insw		;recieve the 512 byte data

	
	mov di,IDENTIFY_PACKET_DEVICE_DATA+512
	mov eax,16
	mov ecx,1
	call __IDE_ATAPI_READx86
	
	mov eax,[IDENTIFY_PACKET_DEVICE_DATA+512+156+2]
	mov ecx,[IDENTIFY_PACKET_DEVICE_DATA+512+156+10]
	mov di,IDENTIFY_PACKET_DEVICE_DATA+512
	shr ecx,11
	call __IDE_ATAPI_READx86
	
	mov bx,IDENTIFY_PACKET_DEVICE_DATA+512
	movzx ax,[bx+0]
	add bx,ax
directory_search:
	xor ch,ch
	movzx ax,[bx+0]
	add bx,ax
	mov al,[bx+0]
	test al,al
	jz directory_search_not_found
	mov al,[bx+32]	
	cmp al,6
	sete cl
	add ch,cl
	mov eax,[bx+33]
	cmp eax,"KERN"
	sete cl
	add ch,cl
	mov ax,[bx+33+4]
	cmp ax,"EL"
	sete cl
	add ch,cl
	mov ax,[bx+25]	
	cmp ax,";1"
	setne cl
	add ch,cl
	test ch,4
	jz directory_search
	
	
	mov eax,[bx+2]
	mov ecx,[bx+10]
	mov di,IDENTIFY_PACKET_DEVICE_DATA+512
	shr ecx,11
	call __IDE_ATAPI_READx86
	mov bx,IDENTIFY_PACKET_DEVICE_DATA+512
	movzx ax,[bx+0]
	add bx,ax
	
	
	directory_search2:
	xor ch,ch
	movzx ax,[bx+0]
	add bx,ax
	mov al,[bx+0]
	test al,al
	jz directory_search_not_found
	mov al,[bx+32]	
	cmp al,12
	sete cl
	add ch,cl
	mov eax,[bx+33]
	cmp eax,"KERN"
	sete cl
	add ch,cl
	mov eax,[bx+33+4]
	cmp eax,"EL.B"
	sete cl
	add ch,cl
	mov eax,[bx+33+8]
	cmp eax,"IN;1"
	sete cl
	add ch,cl
	test ch,4
	jz directory_search2
	
	
	xor eax,eax
	mov ecx,[bx+10]
	mov di,IDENTIFY_PACKET_DEVICE_DATA+512
	test cx,2047
	setnz ah
	shl ah,3
	add ecx,eax
	mov eax,[bx+2]
	call __IDE_ATAPI_READx86
	
	jmp IDENTIFY_PACKET_DEVICE_DATA+512
	
directory_search_not_found:
	mov si,msg4
	call __printStringx86
	hlt
	%include "../functions/__IDE_ATAPI_READx86.asm"
		
msg1: db 10,"operating system found"
enter: db 13,0
msg2: db "IDE device not found",13,0
msg3: db "IDE device found",13,0
msg4: db "kernel.bin not found",0
times 2048-($-$$) db 0
IDENTIFY_PACKET_DEVICE_DATA:
