; Compile: nasm pci.asm -f bin -o test.bin
; 
; Author: Totan
; see od -t x1 -A n test.bin
bits 16
	call jmp
jmp:			
	pop ax		
	cli		
	shr ax,4
	mov ds,ax
	mov si,data1
	call __printStringx86
	mov si,data2
	mov es,ax
	mov bp,0x7000
	mov sp,bp
	mov eax, 0x88000; this value gives 0x80000008 after a 16 bit ror
	
pci_bus_number_loop:		
	ror eax,16		
pci_device_number_loop:		
				
	mov dx,0xcf8
	out dx,eax
	mov ebx,eax		;store the config address
	mov dx,0xcfc
	in eax,dx
	shr eax,16
	cmp ah,0xff
	je skip

	call __binaryToDecimalx86
	call __printStringx86
skip:
	mov eax,ebx		;load the stored config address

	add ah,8
	jnc pci_device_number_loop
	ror eax,16
	add al,1
	jnc pci_bus_number_loop


	hlt
%include "__printStringx86.asm"
%include "__binaryToDecimalx86.asm"
data1:	db 10,0
data2: db " ",0
	times 510-($-$$) db 0
MBR_P1:
	;db 0x80 ,1,1,0,0x06,16,16,16
	;dd 0,4096
	;times 48 db 0
	dw 0xaa55
