jmp boot
times 3-($-$$) db 0
NAME:		db "BASIL_OS"
BPB_BytsPerSec:	dw 512
BPB_SecPerClus:	db 8
BPB_RsvdSecCnt:	dw 16
BPB_NumFATs:	db 2
BPB_RootEntCnt: dw 0
BPB_TotSec16:	dw 0
BPB_Media:	db 0xf0
BPB_FATSz16:	dw 0
BPB_SecPerTrk:	dw 16
BPB_NumHeads:	dw 2
BPB_HiddSec:	dd 16
BPB_TotSec32:	dd 2097152
BPB_FATSz32:	dd 2048
BPB_ExtFlags:	dw 0
BPB_FSVer:	dw 0
BPB_RootClus:	dd 2
BPB_FSInfo:	dw 1
BPB_BkBootSec:	dw 0
BPB_Reserved:	dd 0,0,0
BS_DrvNum:	db 0x80
BS_Reserved1:	db 0
BS_BootSig:	db 0x29
BS_VolID:	dd 0x89abcdef
BS_VolLab:	db "BASIL_OS   "
BS_FilSysType:	db "FAT32   "
boot:



