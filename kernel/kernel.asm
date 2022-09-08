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
	hlt
msg1:	db	13,"kernel has been loaded",13,0
%include "../functions/__printStringx86.asm"
times 510-($-$$) db 0
dw 0xaa55
