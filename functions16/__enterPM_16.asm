; function to enter 32 bit protected mode
; Author: Totan
; ds:bx holds the address of gdt descriptor
; some of the segment registers are set to zero(fs,gs)
; cs is set to 0x8
; ss, ds and es is set to 0x10 
; before returning function makes a far jump to GDT entry 0x08 
; this function assumes it is located with in first 64 kb(not exactly a PIC but it is fine)
%ifndef __enterPM16_def
%define __enterPM16_def 0
__enterPM_16:				
	mov ax,ds					
	shl ax,4					;this section of the code a bit chaotic and most probabily unnecessary
	add ax,__enterPM16_32bit_mode			;with absolute address, to maintain position indepency of the boot loader
	mov [ds:far_jump_0x08+1],ax			;we alter the code during run time
	
	mov dx,0x92
	in al,dx		;enable gate A20
	or al,2
	out dx,al
	
	mov al,0xff
	mov dx,0x21		;disable AT PIC(NMIs are disabled)
	out dx,al
	mov dx,0xa1
	out dx,al
	
	xor edx,edx
	lgdt [ds:bx]		;GDT descriptor is loaded
	pop dx			;return address is translated to 32 bits 
	
	mov eax,cr0
	or al,1			;protected mode enabled
	mov cr0,eax
far_jump_0x08:		
	dd 0x080000ea
	db 0	
__enterPM16_32bit_mode:	
bits 32
	xor ax,ax
	mov fs,ax
	mov gs,ax
	mov ax,16		;segment descriptors are set as specified
	mov ss,ax
	mov ds,ax
	mov es,ax
	jmp edx
bits 16
	
%endif
