bits 16
%include "../functions/fat32.asm"			;push IP to stack then pop it to bx
	pop bx		
	cli		;we assume that this boot sector is loaded to a address divisable by 16
	shr bx,4
	mov ds,bx
	mov es,bx
	mov bp,0x7000	;set stack and base pointers
	mov sp,bp
	;mov al,0xd0
	;mov dx,0x64
	;out dx,al

%include "../functions/bootloader1_hdd.asm"
jmp second_stage_boot
times 510-($-$$) db 0
dw 0xaa55
msg2: db "Second Stage Bootloader is loaded",13,0
second_stage_boot:
mov si,msg2
call __printStringx86
hlt
%include "../functions/bootloader2_hdd.asm"
