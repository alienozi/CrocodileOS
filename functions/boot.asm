bits 16
%include "fat32.asm"
%include "bootloader1.asm"
jmp second_stage_boot
times 510-($-$$) db 0
dw 0xaa55
msg2: db "Second Stage Bootloader is loaded",0
second_stage_boot:
mov si,msg2
call __printStringx86
hlt
%include "bootloader2.asm"
