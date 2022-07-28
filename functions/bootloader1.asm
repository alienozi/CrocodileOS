; Compile: nasm boot.asm -f bin -o test.bin
; 
; Author: Totan
	call jmp
jmp:			;push IP to stack then pop it to ax
	pop ax		;substract 90 from ax to take fat32 bpb in consideration
	sub ax,90	;set ds accordingly
	cli		;we assume that this boot sector is loaded to a address divisable by 16
	xor dx,dx
	shr ax,4
	mov ds,ax
	mov es,ax
	mov si,msg1
	call __printStringx86

	mov dx,0x1f6

IDE_HDD_bus_check:
	mov cx,15
	mov al,7<<5
	out dx,al
	inc dx
	
IDE_HDD_bus_check_loop0:
	in al,dx
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

	
IDE_HDD_not_found:
	
hlt
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
	mov si,msg2
	call __printStringx86
	hlt
	
IDE_HDD_error:

IDE_HDD_drive_fault:
	hlt
	

%include "__printStringx86.asm"
	msg1: db 10,"Basil_OS found",13,0
	err: db "error",0
