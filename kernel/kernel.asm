bits 32	
kernel:	
	call get_eip
get_eip:
	pop edi
	sub edi,get_eip-kernel
	lea esi,[edi+coffee]
	mov ah,0x70
	call __printString_32
	hlt
msg1:	db	13,13,"Kernel has been loaded",13,0
%include "../functions32/__printString_32.asm"
%include "../side_tools/image.asm"
times 510-($-$$) db 0
dw 0xaa55


	
