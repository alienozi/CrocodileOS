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
printI:
_LFB1:
	       
	push	ebp
	mov	ebp, esp
	sub	esp, 16
	call	__x86.get_pc_thunk.ax
 OFFSET_LABEL1:
	add	eax,  -OFFSET_LABEL1
	mov	DWORD [-8+ebp], 753664
	jmp	_L6
_L9:
	mov	DWORD [-4+ebp], 0
	jmp	_L7
_L8:
	mov	edx, DWORD [8+ebp]
	lea	eax, [4+edx]
	mov	DWORD [8+ebp], eax
	mov	eax, DWORD [-8+ebp]
	lea	ecx, [4+eax]
	mov	DWORD [-8+ebp], ecx
	mov	edx, DWORD [edx]
	mov	DWORD [eax], edx
	add	DWORD [-4+ebp], 1
_L7:
	mov	eax, DWORD [-4+ebp]
	cmp	eax, DWORD [12+ebp]
	jl	_L8
	mov	eax, 80
	sub	eax, DWORD [12+ebp]
	sal	eax, 2
	add	DWORD [-8+ebp], eax
_L6:
	mov	eax, DWORD [8+ebp]
	mov	eax, DWORD [eax]
	test	eax, eax
	jne	_L9
	nop
	leave
	ret
_LFE1:
kernel:
_LFB2:
	       
	push	ebp
	mov	ebp, esp
	call	__x86.get_pc_thunk.ax
 OFFSET_LABEL2:
	add	eax,  -OFFSET_LABEL2
	hlt
	hlt
	hlt

	mov	eax, 1
	pop	ebp
	ret
_LFE2:
p.1506: dd 753664
__x86.get_pc_thunk.ax:
_LFB3:
	mov	eax, DWORD [esp]
	ret
_LFE3:
