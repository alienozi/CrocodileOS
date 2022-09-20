bits 16
call ip_get
ip_get:			
	pop bx		;push IP to stack then pop it to ax
	cli		;we assume that this boot sector is loaded to a address divisable by 16
	shr bx,4
	mov ax,bx
	mov ds,bx
	shl ax,4
	mov es,bx
	mov [Boot_loader_offset],ax
	mov bp,0x7000	;set stack and base pointers
	mov sp,bp
	mov si,msg1
	call __printString_16
	
	
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
	call __printString_16
	hlt
	
IDE_DEVICE_DETECTED:
	
port_test:
	mov al,0xa1
	mov cl,5
	out dx,al
retry_loop:
	
wait_loop:
	in al,dx
	test al,1<<7		;wait untily the drive is not busy
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
	GDT:
	dd 0,0
	dw 0xffff
        dw 0x0
        db 0x0
        db 0b10011010
        db 0b11001111
        db 0x0
        dw 0xffff
        dw 0x0
        db 0x0
        db 0b10010010
        db 0b11001111
        db 0x0
        
GDT_Descriptor:
	dw GDT-GDT_Descriptor-1
	dd 0
Boot_loader_offset:
	dd 0
	%include "./functions16/__printString_16.asm"
	%include "./functions16/__binaryToDecimal_16.asm"
	%include "./functions16/__enterPM_16.asm"
	
times 510-($-$$) db 0
dw 0xaa55
	ATAPI_DEVICE_FOUND:		;stores the identify packet device data
	
	pop bx
	sub dx,7		;substract 7 to get data port
	mov si,msg3
	call __printString_16
	
	mov di,IDENTIFY_PACKET_DEVICE_DATA
	mov cx,256
	rep insw		;recieve the 512 byte data
	mov cx,dx
	
	mov bx,GDT_Descriptor
	mov edi,[Boot_loader_offset]
	lea esi,[edi+GDT]
	mov [GDT_Descriptor+2],esi
	
	call __enterPM_16
bits 32
	mov dx,cx
	push edi
	lea esi,[kernel.dir+edi]
	lea edi,[IDENTIFY_PACKET_DEVICE_DATA+512+edi]
	mov ax,16
	mov es,ax
	call __IDE_CD_FILE_READ_32
	jmp IDENTIFY_PACKET_DEVICE_DATA+512
	%include "./functions32/__IDE_CD_FILE_READ_32.asm"
	%include "./functions32/__printString_32.asm"
bits 16
directory_search_not_found:
	mov si,msg4
	call __printString_16
	hlt

		
msg1: db 10,"Operating system found"
enter: db 13,0
msg2: db "IDE device not found",13,0
msg3: db "IDE device found",13,0
msg4: db "kernel.bin not found",0
kernel.dir: db "/KERNEL/KERNEL.BIN;1/",0
times 2048-($-$$) db 0
IDENTIFY_PACKET_DEVICE_DATA:
