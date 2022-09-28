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
	mov bx,GDT_Descriptor
	mov edi,[Boot_loader_offset]
	lea esi,[edi+GDT]
	mov [GDT_Descriptor+2],esi
	call __enterPM_16
bits 32
	push edi
	push ebp
	mov ebp, esp
	jmp IDE_DEVICE_NOT_FOUND
bits 16
	
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
	
	call __enterPM_16	;enters 32 bit protected mode
bits 32
	mov dx,cx
	push edi
	push ebp
	mov ebp, esp
	lea esi,[icon.dir+edi]				;loads icon to ram then to screen
	lea edi,[edi+IDENTIFY_PACKET_DEVICE_DATA+512]
	call __IDE_CD_FILE_READ_32
	test al,al
	jz CD_FILE_READ_FAIL
	mov esi,[ebp+4]
	mov edi,0xb8000
	lea esi,[esi+IDENTIFY_PACKET_DEVICE_DATA+512]
	mov ecx,4000
	rep movsb
	mov edi,[ebp+4]
	lea esi,[edi+boot_parameters.dir]
	lea edi,[edi+IDENTIFY_PACKET_DEVICE_DATA+512]
	call __IDE_CD_FILE_READ_32			;loads boot parameters
	test al,al
	jz CD_FILE_READ_FAIL
	mov edi,[ebp+4]
	lea esi,[edi+kernel.dir]
	mov edi,[edi+IDENTIFY_PACKET_DEVICE_DATA+512+16]
	call __IDE_CD_FILE_READ_32			;loads the kernel as specified 
	test al,al					;in boot parameter file
	jz CD_FILE_READ_FAIL
	mov edi,[ebp+4]
	mov edi,[edi+IDENTIFY_PACKET_DEVICE_DATA+512+16]
	jmp edi

IDE_DEVICE_NOT_FOUND:		;check for ahci card with pci brute force scan

	mov eax, 0x88000	;this value gives 0x80000008 after a 16 bit ror
	
pci_bus_number_loop:		;brute force pci scan for ahci card with 2 loops
	ror eax,16		;loop variables are second and third significant bytes of eax
pci_device_number_loop:		;they were used to simply avoid using stack and increase both
				;readability and speed(not significant at all but it is good practice)
	mov dx,0xcf8
	out dx,eax
	mov ebx,eax		;store the config address
	mov dx,0xcfc
	in eax,dx
	shr eax,8
	
	cmp eax,0x010601
	je AHCI_CARD_FOUND
	mov eax,ebx		;load the stored config address

	add ah,8
	jnc pci_device_number_loop
	ror eax,16
	add al,1
	jnc pci_bus_number_loop
	
AHCI_SATA_DEVICE_NOT_FOUND:
AHCI_CARD_NOT_FOUND:
	lea esi,[edi+msg2]
	mov ah,0x0f
	call __printString_32
	hlt
AHCI_CARD_FOUND:
	mov edx,ebx
	lea esi,[edi+msg5]
	mov ah,0x0f
	call __printString_32
	xor ecx,ecx
	mov eax,edx
	mov al,0x24
	mov dx,0xcf8
	out dx,eax		;loads bar5 address
	mov dx,0xcfc
	in eax,dx
	and al,0xf8
	mov edx,eax
	add eax,0x80
	mov ecx,32
AHCI_PORT_SCAN:
	add eax,0x80
	cmp [eax+0x24], dword 0xeb140101
	loopne AHCI_PORT_SCAN
	jne AHCI_SATA_DEVICE_NOT_FOUND
	mov eax,[eax+0x1c]
	call __binaryToDecimal_32
	mov edi,[ebp+4]
	mov ah,0x0f
	lea esi,[edi+msg6]
	call __printString_32
	mov ecx,0
	mov eax,0
	call __AHCI_ATAPI_READ_32
	hlt


	%include "./functions32/__IDE_CD_FILE_READ_32.asm"
	%include "./functions32/__AHCI_ATAPI_READ_32.asm"
	%include "./functions32/__printString_32.asm"
	%include "./functions32/__binaryToDecimal_32.asm"
CD_FILE_READ_FAIL:
	mov esi,[ebp+4]
	lea esi,[esi+msg4]
	mov ah,0xf0
	call __printString_32
	hlt

		
msg1: db 10,"Operating system found"
enter: db 13,0
msg2: db 13,"storage device not found",0
msg3: db "IDE device found",13,0
msg4: db "CD FILE READ ERROR",0
msg5: db 13,"AHCI Controller found",13,0
msg6: db "Storage device found",0
kernel.dir: db "/KERNEL/KERNEL.BIN;1/",0,0,0
icon.dir: db "/HOME/CD_USER/ICON.STR;1/",0
boot_parameters.dir: db "/BOOT/BOOT_PARAMETERS.BIN;1/",0
double_enter: db 13,13,0
times 2048-($-$$) db 0
IDENTIFY_PACKET_DEVICE_DATA:
