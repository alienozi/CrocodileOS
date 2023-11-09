; Author: Totan

; I have tried to avoid using the bios as much as I can, but at this moment I have to use it in order to preceed.
; In the future I intend to change this if I can, but currently I am not that hopeful
__biosMMapGet_entry_count:
	DD	0
__biosMMapGet:
	xor ebx, ebx
	mov edx, 0x0534D4150
	mov eax, 0xe820
	mov ecx, 24
	mov [es:di + 20], dword 1

	int 0x15

	cmp eax, 0x0534D4150
	jne __biosMMapGet_failed
	test ebx, ebx
	jz __biosMMapGet_failed

__biosMMapGet_loop:

	jcxz __biosMMapGet_skip

	cmp cl, 20
	seta	cl
	mov ch, [es:di + 20]
	not ch
	test ch, cl
	jnz __biosMMapGet_skip

	mov ecx, [es:di + 8]
	mov eax, [es:di + 12]

	or ecx, eax

	jz __biosMMapGet_skip

	inc dword [__biosMMapGet_entry_count]

	add di, 24

__biosMMapGet_skip:

	mov edx, 0x0534D4150
	mov eax, 0xe820
	mov ecx, 24
	mov [es:di + 20], dword 1

	test ebx, ebx
	jz __biosMMapGet_end

	int 0x15

	jmp __biosMMapGet_loop
	
__biosMMapGet_end:
	mov eax, [__biosMMapGet_entry_count]
	ret

__biosMMapGet_failed:
	mov eax, -1
	ret