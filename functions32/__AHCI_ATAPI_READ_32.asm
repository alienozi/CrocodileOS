;ecx register holds the number of sectors to be read
;eax register holds the LBA of first sector to be read
;ebx holds the port address
;edx holds the AHCI base address
%ifndef __AHCI_ATAPI_READ_32_def
%define __AHCI_ATAPI_READ_32_def 0
%define __AHCI_ATAPI_READ_32_CMD_FIS ebp-(12+64)
%define __AHCI_ATAPI_READ_32_ATAPI_CMD ebp-12
__AHCI_ATAPI_READ_32:
	push ebp
	mov ebp,esp
	sub esp,64+16
	mov esi,ecx
	
	mov [__AHCI_ATAPI_READ_32_CMD_FIS+4],eax
	mov [__AHCI_ATAPI_READ_32_CMD_FIS],dword 0x00a08027
	
	shl ecx,10		;the LSB in byte limit indicates whether the device should expect
	cmp esi,0x1f+1		;to exceed the limit or not
	rcl ecx,1		;so we set this byte accordingly
	
	mov [__AHCI_ATAPI_READ_32_CMD_FIS+12],cx
	
	mov esi,ecx
	
	ror cx,8
	ror ax,8
	ror ecx,16
	ror eax,16		;coverting little endian to big endian
	ror cx,8
	ror ax,8
	
	mov [__AHCI_ATAPI_READ_32_CMD_FIS+8],al
	mov [__AHCI_ATAPI_READ_32_CMD_FIS+9],word 0
	mov [__AHCI_ATAPI_READ_32_CMD_FIS+14],word 0
	mov [__AHCI_ATAPI_READ_32_CMD_FIS+7],byte 0
	mov [__AHCI_ATAPI_READ_32_CMD_FIS+11],byte 0
	mov [__AHCI_ATAPI_READ_32_CMD_FIS+16],dword 0
	
	
	
	mov [__AHCI_ATAPI_READ_32_ATAPI_CMD+2],eax
	mov [__AHCI_ATAPI_READ_32_ATAPI_CMD+6],ecx	;preparing atapi block for command table
	mov [__AHCI_ATAPI_READ_32_ATAPI_CMD+10],word 0
	
	shl ebx,7
	add ebx,edx

	mov esi,[ebx]
	mov esi,[esi+2]



	mov ebp,[ebp]
	mov esp,ebp
	ret
%endif
