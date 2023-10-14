bits 16
	%include "./boot/MAIN_ADDR_FILE.asm"
	mov dx, 0x3D4
	mov al, 0xA	;disables the cursor
	out dx, al
	inc dx
	mov al, 0x20
	out dx, al

	call ip_get
	ip_get:			
	pop bx		;push IP to stack then pop it to ax
	cli		;we assume that this boot sector is loaded to a address divisable by 16
	mov cx, bx	
	shr bx,4
	mov ds,bx
	mov bp,0x7000	;set stack and base pointers
	mov sp,bp
	mov edi,ds
	shl edi,4
	mov bx,GDT_Descriptor
	lea esi,[edi+GDT]
	mov [GDT_Descriptor+2],esi
	
	call __enterPM_16	;enters 32 bit protected mode
bits 32
	xor eax, eax
	mov ax,cx
	and ax,0xFFF0
	add eax, COS_SIGNATURE
	push eax
	call MAIN_ADDR_OFF+pre_boot_end
bits 16
	%include "./functions16/__enterPM_16.asm"
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
COS_SIGNATURE:
	%include "./boot/COS_SIGNATURE.asm"
bits 32
pre_boot_end: