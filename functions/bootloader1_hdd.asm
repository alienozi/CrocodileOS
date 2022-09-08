; Compile: nasm boot.asm -f bin -o test.bin
; 
; Author: Totan

	mov si,msg1	;display first text
	call __printStringx86
	
	mov dx,0x1f6

IDE_HDD_bus_check:
	mov cx,15
	mov al,7<<5		;the following code segment checks both master and slave IDE drives
	out dx,al		;at primary and secondary ports
	inc dx			;currently this bootloader can only locate the drives in primary
				;and secondary buses since it seems reasonable to just check those
IDE_HDD_bus_check_loop0:	;the drive of interest for boot might be changed later by us
	in al,dx		;or personally by user if seems necessary
	loop IDE_HDD_bus_check_loop0
	test al,6
	jz boot_loader_stage1_IDE_HDD	
	mov cl,15
	dec dx
	mov al,(7<<5)+(1<<4)
	out dx,al
	inc dx
	
IDE_HDD_bus_check_loop1:
	in al,dx
	loop IDE_HDD_bus_check_loop1
	test al,6
	jz boot_loader_stage1_IDE_HDD
	cmp dx,0x1f7
	mov dx,0x176
	je IDE_HDD_bus_check

	
IDE_HDD_not_found:		;check for ahci card with pci brute force scan

	mov eax, 0x88000; this value gives 0x80000008 after a 16 bit ror
	
pci_bus_number_loop:		;brute force pci scan for ahci card with 2 loops
	ror eax,16		;loop variables are second and third significant bytes of eax
pci_device_number_loop:		;they were used to simply avoid using stack and increase both
				;readability and speed(not significant at all but it is good practice)
	mov dx,0xcf8
	out dx,eax
	mov ebx,eax		;store the config address
	mov dx,0xcfc
	in eax,dx
	shr eax,16
	
	cmp ax,0x0106
	je AHCI_CARD_FOUND
	mov eax,ebx		;load the stored config address

	add ah,8
	jnc pci_device_number_loop
	ror eax,16
	add al,1
	jnc pci_bus_number_loop
	
AHCI_CARD_NOT_FOUND:


IDE_HDD_error:

IDE_HDD_drive_fault:

	hlt

AHCI_CARD_FOUND:
	mov si,found
	call __printStringx86
	mov bl,0x24
	mov eax,ebx
	mov dx,0xcf8
	out dx,eax
	mov dx,0xcfc
	in eax,dx
	
	;call __binaryToDecimalx86
	;hlt
	lgdt [Temporary_GDTR]
	;mov ebx,c0
	or ebx,1
	;mov c0,ebx
	
	mov ebx,eax	;bar5 value of ahci is read from pci
	
	
	;mov ebx,c0
	and ebx,0xFFFFFFFE
	;mov c0,ebx
	
	;call __binaryToDecimalx86
	hlt
	
%include "../functions/__printStringx86.asm"
;%include "../functions/__binaryToDecimalx86.asm"

msg1: db 10,"COS found"
enter: db 13,0
found: db "ahci found",0
Temporary_GDT:
	dq 0
	db 0,0x49,0b10011110,0,0x70,0,0,0
Temporary_GDTR:
	dd	Temporary_GDT
	dw	8*2
boot_loader_stage1_IDE_HDD:
	mov cl,5
	
boot_loader_stage1_IDE_HDD_again:
	xor al,al
	sub dx,2
	out dx,al
	dec dx
	out dx,al
	dec dx
	inc al
	out dx,al
	dec dx
	mov al,3
	out dx,al
	add dx,5
	mov al,0x20
	out dx,al
	
boot_loader_stage1_IDE_HDD_wait:
	in al,dx
	test al,0b101001
	jz boot_loader_stage1_IDE_HDD_wait
	test al,1
	loopnz boot_loader_stage1_IDE_HDD_again
	jnz IDE_HDD_error
	test al,0b100000
	jnz IDE_HDD_drive_fault
	sub dx,7
	mov cx,256*15
	mov di,msg2
	rep insw
		
