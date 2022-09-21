; Compile: nasm __printString16.asm -f bin -o test.bin
; function to read a file from a cdrom with iso9660 file system
; Author: Totan
;es:esi holds the pointer of file path string
;ds:edi hold the destination address of the read file data
;dx register holds the base address of the relevant port
;since the program most likely will not call this function with same parameters over again
;function will only restore the value of dx(eax,ebx,ecx,edi and esi may and probably will be altered)
;if function is succesfull it will return 1 otherwise 0 in eax
%ifndef __IDE_CD_FILE_READ_32_def
%define __IDE_CD_FILE_READ_32_def 0


__IDE_CD_FILE_READ_32:
	push ebp
	mov ebp,esp
	push esi
	push edi
	sub esp,4
	mov eax,16
	mov ecx,1
	call __IDE_ATAPI_READ_32
	
	mov esi,[ebp-4]
	mov ebx,[ebp-8]
	
	add ebx,156
__IDE_CD_FILE_READ_32_directory_search_loop:

	inc esi
	xor eax,eax
	mov [ebp-4],esi
	mov ecx,[ebx+10]
	mov edi,[ebp-8]
	test cx,2047
	setnz al
	shr ecx,11
	add ecx,eax
	mov eax,[ebx+2]
	call __IDE_ATAPI_READ_32
	mov esi,[ebp-4]
	mov cx,[esi-3]
	cmp cx,";1"
	je __IDE_CD_FILE_READ_32_success
	mov ebx,[ebp-8]
	xor ecx,ecx
__IDE_CD_FILE_READ_32_string_lenght_loop:
	inc esi
	inc cl
	mov ch,[esi]
	cmp ch,"/"
	jne __IDE_CD_FILE_READ_32_string_lenght_loop
	
	mov [esp-9],cl
	xor eax,eax
__IDE_CD_FILE_READ_32_directory_scan_loop:
	mov edi,ebx
	mov al,[ebx]
	mov ch,[ebx+32]
	
	add ebx,eax
	test al,al
	jz __IDE_CD_FILE_READ_32_fail
	cmp ch,cl
	jne __IDE_CD_FILE_READ_32_directory_scan_loop
	xor ch,ch
	mov ebx,edi
	add edi,33
	mov esi,[ebp-4]
	repe cmpsb
	je __IDE_CD_FILE_READ_32_directory_search_loop
	mov cl,[esp-9]
	add ebx,eax
	jmp __IDE_CD_FILE_READ_32_directory_scan_loop
	
	
__IDE_CD_FILE_READ_32_success:
	mov al,1
__IDE_CD_FILE_READ_32_fail:
	xor ecx,ecx
	mov ebp,[ebp]
	add sp,16
	ret
%include "./functions32/__IDE_ATAPI_READ_32.asm"
%endif
