bits 16
%include "fat32.asm"
%include "bootloader1.asm"
times 510-($-$$) db 0
dw 0xaa55
%include "bootloader2.asm"
