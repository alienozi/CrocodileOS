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

ATAPI_DEVICE_FOUND:		;stores the identify packet device data
	pop bx
	sub dx,7		;substract 7 to get data port
	
	mov di,IDENTIFY_PACKET_DEVICE_DATA
	mov cx,256
	rep insw		;recieve the 512 byte data
	;mov ax,[IDENTIFY_PACKET_DEVICE_DATA]
	;call __binaryToDecimalx86
	;mov si,enter
	;call __printStringx86
	;mov ax,[IDENTIFY_PACKET_DEVICE_DATA+82*2]
	;call __binaryToDecimalx86
	;call __printStringx86

	
	mov di,data_test
	mov ax,1
	mov cx,10
	call __IDE_ATAPI_READx86
	
	mov ecx,12
	mov bx,data_test
	mov si,enter
	
	;xor eax,eax
display_test_loop:
	mov eax,[bx]
	add bx,4
	call __binaryToDecimalx86
	call __printStringx86
	loop display_test_loop
drive_fault:
	
	hlt

	%include "../functions/__printStringx86.asm"
	%include "../functions/__binaryToDecimalx86.asm"
	
	
times 510-($-$$) db 0
dw 0xaa55
IDENTIFY_PACKET_DEVICE_DATA:	times 256 dw 0
	
	%include "../functions/__IDE_ATAPI_READx86.asm"
		
msg1: db 10,"operating system found"
enter: db 13,0
msg2: db "IDE device not found",13,0
data_test:	dd	1,2,3,4,5,6,7,8,9
