bits 32
_LC0:
	 db	"denem",0
_LC1:
	 db	"deneme55555555555",0
kernel:
_LFB0:
	       
	push	ebp
	mov	ebp, esp
	push	ebx
	sub	esp, 20
	call	__x86.get_pc_thunk.bx
 OFFSET_LABEL0:
	add	ebx,  -OFFSET_LABEL0
	lea	eax, [_LC0+ebx]
	mov	DWORD [-20+ebp], eax
	lea	eax, [_LC1+ebx]
	mov	DWORD [-16+ebp], eax
	mov	BYTE [-23+ebp], 111
	mov	WORD [-22+ebp], 222
	mov	DWORD [-12+ebp], 333
	sub	esp, 12
	push	DWORD [-20+ebp]
	call	tprint
	add	esp, 16
	sub	esp, 12
	push	DWORD [-16+ebp]
	call	print
	add	esp, 16
	hlt
	movzx	eax, WORD [varx.1512+ebx]
	add	eax, 1
	mov	WORD [varx.1512+ebx], ax
	hlt

	movzx	eax, WORD [varx.1512+ebx]
	mov	ebx, DWORD [-4+ebp]
	leave
	ret
_LFE0:
print:
_LFB1:
	       
	push	ebp
	mov	ebp, esp
	sub	esp, 16
	call	__x86.get_pc_thunk.ax
 OFFSET_LABEL1:
	add	eax,  -OFFSET_LABEL1
	mov	DWORD [-4+ebp], 753664
	jmp	_L4
_L5:
	mov	eax, DWORD [8+ebp]
	movzx	eax, BYTE [eax]
	cbw
	sub	ax, 4096
	mov	edx, eax
	mov	eax, DWORD [-4+ebp]
	mov	WORD [eax], dx
	add	DWORD [8+ebp], 1
	add	DWORD [-4+ebp], 2
_L4:
	mov	eax, DWORD [8+ebp]
	movzx	eax, BYTE [eax]
	test	al, al
	jne	_L5
	nop
	leave
	ret
_LFE1:
tprint:
_LFB2:
	       
	push	ebp
	mov	ebp, esp
	sub	esp, 16
	call	__x86.get_pc_thunk.ax
 OFFSET_LABEL2:
	add	eax,  -OFFSET_LABEL2
	mov	DWORD [-4+ebp], 753714
	jmp	_L8
_L9:
	mov	eax, DWORD [8+ebp]
	movzx	eax, BYTE [eax]
	cbw
	sub	ax, 4096
	mov	edx, eax
	mov	eax, DWORD [-4+ebp]
	mov	WORD [eax], dx
	add	DWORD [8+ebp], 1
	add	DWORD [-4+ebp], 2
_L8:
	mov	eax, DWORD [8+ebp]
	movzx	eax, BYTE [eax]
	test	al, al
	jne	_L9
	nop
	leave
	ret
_LFE2:
varx.1512: dw 77
varb.1511: dd 88
vara.1510: db 32
varx.1522: dw 77
varb.1521: dd 88
vara.1520: db 32
varx.1532: dw 77
varb.1531: dd 88
vara.1530: db 32
__x86.get_pc_thunk.ax:
_LFB3:
	mov	eax, DWORD [esp]
	ret
_LFE3:
__x86.get_pc_thunk.bx:
_LFB4:
	mov	ebx, DWORD [esp]
	ret
_LFE4:
