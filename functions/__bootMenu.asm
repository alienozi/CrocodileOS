; Compile: nasm x.asm -f bin -o test.bin
; function to print a string saved in bx
; Author: Oguz
; see od -t x1 -A n xx.bin

;#############################################################################################
; 
	[bits 16]
	[org 0x7c00]			; BIOS Code load adress
	mov bp, 0x8000 			; move base stack pointer over the BIOS sector
	mov sp, bp  			; load base pointer to stack pointer
;#############################################################################################
	
;#############################################################################################
; detect drives, show menu entries accordingly used following registers for following medium:
; HDD:			CD:		Floppy(?)	
;
;	AH=01 --> int 13 -> gives status to al
;
;	+   	00  no error
;	+   	01  bad command passed to driver
;	   	02  address mark not found or bad sector
;	   	03  diskette write protect error
;	   	04  sector not found
;	   	05  fixed disk reset failed
;	   	06  diskette changed or removed
;	   	07  bad fixed disk parameter table
;	   	08  DMA overrun
;	   	09  DMA access across 64k boundary
;	   	0A  bad fixed disk sector flag
;	   	0B  bad fixed disk cylinder
;	   	0C  unsupported track/invalid media
;	   	0D  invalid number of sectors on fixed disk format
;	   	0E  fixed disk controlled data address mark detected
;	   	0F  fixed disk DMA arbitration level out of range
;	   	10  ECC/CRC error on disk read
;	   	11  recoverable fixed disk data error, data fixed by ECC
;	   	20  controller error (NEC for floppies)
;	   	40  seek failure
;	   	80  time out, drive not ready
;	   	AA  fixed disk drive not ready
;	   	BB  fixed disk undefined error
;	   	CC  fixed disk write fault on selected drive
;	   	E0  fixed disk status error/Error reg = 0
;	   	FF  sense operation failed
;#############################################################################################
	
	mov cl, 0x01			; error check flag counter
	mov ah, 0x01			; precursor to interrupt 13,01
	int 13				; INT 13,1 - Get Status
	cmp al, 0x00
	je __NoError	

__ErrChk:
	cmp al, cl			; try all possible combinations print error msg accordingly
	je __ErrFoundIn
	inc cl
	cmp cl, 0xff			; end of error codes
	je __Menu 
	
	jmp __ErrChk
	
__HelpFag:
	and bx, 0x00FF	
	add bx, 0x0037			; add 55 to hex, so it's legible as Hex to ASCII
	mov ah, 0x0e
	mov al, bl
	int 0x10
	ret

__HelpFag2:
	and bx, 0x00FF	
	add bx, 0x0030			; add 48 to hex number to make ascii char number
	mov al, bl
	mov ah, 0x0e
	int 0x10
	ret
	
__ErrFoundIn:	
	mov ch, 0x02			; counter declared for __ErrFound
	mov bx, ErrMsg
	call __printString16


__ErrFound:	
	mov bl, al
	mov bh, al
	and bl, 0x0F			; get right char
	and bh, 0xF0			; get left char
	shr bh, 4			; shift 4 bit one hex
	
	;mov es,bh			; save bh on es
	mov dx,bx			; save bh on es
	shr dx,8
	and dx, 0x00FF

	cmp bl, 0x0A			; if bigger than 9 add 55
	jge __HelpFag
	cmp bl, 0x09			; if smaller than 9 add 48
	jle __HelpFag2
	
	and bx, 0x0000
	;mov es, bl			; restore bl ?
	mov bx,dx
	
	dec ch
	cmp ch, 0x00
	jne __ErrFound

__NoError:				
	mov ah, 0x08			; precursor to interrupt 13,08
	int 13				; INT 13,8 - Get Current Drive Parameters (XT & newer)

__Menu:	
	mov bx, Border
	call __printString16
	mov bx, MenuEntry1
	call __printString16
	mov bx, MenuEntry2
	call __printString16
	mov bx, MenuEntry3
	call __printString16
	mov bx, Border
	call __printString16	
	
	jmp $				; Endless Loop

	%include "__printString16.asm"


;DATA
ErrMsg: 	db "Error Reading Devices, Error Code:",0

Border:		db "*************************************", 0x0a, 0x0d, 0
MenuEntry1:	db "* 1) Load Cylinder from the CD	*", 0x0a, 0x0d, 0
MenuEntry2:	db "* 2) Load Cylinder from HDD		*", 0x0a, 0x0d, 0
MenuEntry3:	db "* 2) Load Cylinder from Floppy	*", 0x0a, 0x0d, 0
;#############################################################################################
	times 510-($-$$) db 0		;pads the sector until the last two bytes in 512B
	dw 0xaa55			;last two bytes (word/wyde) with magic number! 
;#############################################################################################
