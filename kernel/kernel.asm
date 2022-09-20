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
_LC1:
	 db	"deneme123456789abcdef",0
kernel:
_LFB1:
	       
	push	ebp
	mov	ebp, esp
	sub	esp, 16
	call	__x86.get_pc_thunk.ax
 OFFSET_LABEL1:
	add	eax,  -OFFSET_LABEL1
	lea	edx, [_LC0+eax]
	mov	DWORD [-12+ebp], edx
	lea	eax, [_LC1+eax]
	mov	DWORD [-8+ebp], eax
	mov	BYTE [-15+ebp], 111
	mov	WORD [-14+ebp], 222
	mov	DWORD [-4+ebp], 333
	push	240
	push	DWORD [-12+ebp]
	call	printS
	add	esp, 8
	push	15
	push	DWORD [-8+ebp]
	call	printS
	add	esp, 8
	hlt
	hlt

	mov	eax, 1
	leave
	ret
_LFE1:
p.1506: dd 753664
	align 4
le_int.1514:	 dd 0
	align 2
le_short.1513:	 dw 0
	align 1
le_char.1512:	 db 0
__x86.get_pc_thunk.ax:
_LFB2:
	mov	eax, DWORD [esp]
	ret
_LFE2:
