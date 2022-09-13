; Compile: nasm __printString16.asm -f bin -o test.bin
; function to read a file from a cdrom with iso9660 file system
; Author: Totan
;es:si holds the pointer of file path string
;ds:di hold the destination address of the read file data
;dx register holds the base address of the relevant port
;since the program most likely will not call this function with same parameters over again
;function will only restore the value of dx(eax,ecx,edi and esi may and probably will be altered)
;if function is succesfull it will return 1 otherwise 0 in eax
%ifndef __IDE_CD_FILE_READx86_def
%define __IDE_CD_FILE_READx86_def 0
%include "../functions/__IDE_ATAPI_READx86.asm"

__IDE_CD_FILE_READx86:
	push bp
	mov bp,sp
	push si
	push di
	mov eax,16
	mov ecx,1
	call __IDE_ATAPI_READx86
	
	mov si,[bp-2]
	mov bx,[bp-4]
	
	
	
	add bx,156
__IDE_CD_FILE_READx86_directory_search_loop:

	inc si
	xor eax,eax
	mov [bp-2],si
	mov ecx,[bx+10]
	mov di,[bp-4]
	test cx,2047
	setnz al
	shr ecx,11
	add ecx,eax
	mov eax,[bx+2]
	call __IDE_ATAPI_READx86
	mov si,[bp-2]
	mov bx,[si-3]
	cmp bx,";1"
	je __IDE_CD_FILE_READx86_success
	mov bx,[bp-4]
	xor ecx,ecx
__IDE_CD_FILE_READx86_string_lenght_loop:
	inc si
	inc cl
	mov ch,[si]
	cmp ch,"/"
	jne __IDE_CD_FILE_READx86_string_lenght_loop
	
	
	
	mov gs,cx
	xor eax,eax
__IDE_CD_FILE_READx86_directory_scan_loop:
	mov di,bx
	mov al,[bx]
	mov ch,[bx+32]
	
	add bx,ax
	xor ax,ax
	test ch,ch
	jz __IDE_CD_FILE_READx86_fail
	cmp ch,cl
	jne __IDE_CD_FILE_READx86_directory_scan_loop	
	xor ch,ch
	mov bx,di
	add di,33
	mov si,[bp-2]
	repe cmpsb
	setne ch
	test cx,cx
	jz __IDE_CD_FILE_READx86_directory_search_loop
	mov cx,gs
	add bx,ax
	jmp __IDE_CD_FILE_READx86_directory_scan_loop
	
	
__IDE_CD_FILE_READx86_success:
	bts ax,0
__IDE_CD_FILE_READx86_fail:
	mov bp,[bp]
	add sp,6
	ret
	__IDE_CD_FILE_READx86_condition_byte: db 0
%endif
