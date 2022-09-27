bits 32
jmp kernel
printS:
_LFB0:
	       
	push	ebp
	mov	ebp, esp
	sub	esp, 4
	call	__x86.get_pc_thunk.ax
 OFFSET_LABEL0:
	add	eax,  -OFFSET_LABEL0
	mov	edx, DWORD [12+ebp]
	mov	BYTE [-4+ebp], dl
	jmp	_L2
_L3:
	mov	edx, DWORD [p.1506+eax]
	lea	ecx, [1+edx]
	mov	DWORD [p.1506+eax], ecx
	mov	ecx, DWORD [8+ebp]
	movzx	ecx, BYTE [ecx]
	mov	BYTE [edx], cl
	mov	edx, DWORD [p.1506+eax]
	lea	ecx, [1+edx]
	mov	DWORD [p.1506+eax], ecx
	movzx	ecx, BYTE [-4+ebp]
	mov	BYTE [edx], cl
	add	DWORD [8+ebp], 1
_L2:
	mov	edx, DWORD [8+ebp]
	movzx	edx, BYTE [edx]
	test	dl, dl
	jne	_L3
	nop
	leave
	ret
_LFE0:
_LC0:
	 db	"test",0
kernel:
_LFB1:
	       
	push	ebp
	mov	ebp, esp
	push	ebx
	call	__x86.get_pc_thunk.bx
 OFFSET_LABEL1:
	add	ebx,  -OFFSET_LABEL1
	push	2
	lea	eax, [_LC0+ebx]
	push	eax
	call	printS
	add	esp, 8
	push	2
	lea	eax, [_LC0+ebx]
	push	eax
	call	printS
	add	esp, 8
	push	2
	lea	eax, [_LC0+ebx]
	push	eax
	call	printS
	add	esp, 8
	push	2
	lea	eax, [_LC0+ebx]
	push	eax
	call	printS
	add	esp, 8
	push	2
	lea	eax, [_LC0+ebx]
	push	eax
	call	printS
	add	esp, 8
	hlt

	mov	eax, 1
	mov	ebx, DWORD [-4+ebp]
	leave
	ret
_LFE1:
p.1506: dd 753664
__x86.get_pc_thunk.ax:
_LFB2:
	mov	eax, DWORD [esp]
	ret
_LFE2:
__x86.get_pc_thunk.bx:
_LFB3:
	mov	ebx, DWORD [esp]
	ret
_LFE3:
