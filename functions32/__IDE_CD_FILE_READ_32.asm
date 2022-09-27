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
	mov ebp,esp			;pushes critical registers
	push esi
	push edi
	sub esp,4
	mov eax,16
	mov ecx,1
	call __IDE_ATAPI_READ_32	;loads the primary volume discriptor
	
	mov esi,[ebp-4]
	mov ebx,[ebp-8]
	
	add ebx,156			;sets ebx to point root directory entry
__IDE_CD_FILE_READ_32_directory_search_loop:

	inc esi
	xor eax,eax
	mov [ebp-4],esi
	mov ecx,[ebx+10]
	mov edi,[ebp-8]
	test cx,2047
	setnz al
	shr ecx,11				;makes necessary roundings
	add ecx,eax				;loads the desired data(directory or file)
	mov eax,[ebx+2]				;checks whether the loaded data was the file
	call __IDE_ATAPI_READ_32		;of a directory and if it is a directory
	mov esi,[ebp-4]				;function returns with 1 written in eax
	mov cx,[esi-3]				;which indicates success
	cmp cx,";1"				;otherwise program continues its search in
	je __IDE_CD_FILE_READ_32_success	;the last loaded directory
	mov ebx,[ebp-8]
	xor ecx,ecx
__IDE_CD_FILE_READ_32_string_lenght_loop:
	inc esi
	inc cl					;measures direcory/file name
	mov ch,[esi]
	cmp ch,"/"
	jne __IDE_CD_FILE_READ_32_string_lenght_loop
	
	mov [ebp-9],cl				;loads measured lenght in stack
	xor eax,eax
__IDE_CD_FILE_READ_32_directory_scan_loop:
	mov edi,ebx
	mov al,[ebx]
	mov ch,[ebx+32]			;load directors/file entry and name lenghts to al and cl
	add ebx,eax
	test al,al
	jz __IDE_CD_FILE_READ_32_fail	;if directory/file entry lenght is zero(which is not valid)
	cmp ch,cl			;to prevent possible infinite loop jumps to fail
	jne __IDE_CD_FILE_READ_32_directory_scan_loop
	xor ch,ch			;if lenght of entry and searched target are equal then
	mov ebx,edi			;strings are compared to ensure that they are exactly same
	add edi,33
	mov esi,[ebp-4]
	repe cmpsb			;repeted conditional string byte compare
	je __IDE_CD_FILE_READ_32_directory_search_loop
	mov cl,[ebp-9]			;if names are not identical, target name lenght is stored
	add ebx,eax			;and scan loop continues from next entry
	jmp __IDE_CD_FILE_READ_32_directory_scan_loop
	
	
__IDE_CD_FILE_READ_32_success:
	mov ax,1
__IDE_CD_FILE_READ_32_fail:
	xor ecx,ecx
	mov ebp,[ebp]
	add sp,16
	ret
%include "./functions32/__IDE_ATAPI_READ_32.asm"
%endif
