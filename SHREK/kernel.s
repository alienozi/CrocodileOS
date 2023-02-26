	.file	"kernel.c"
	.intel_syntax noprefix
	.text
	.globl	printS
	.type	printS, @function
printS:
.LFB0:
	.cfi_startproc
	push	ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	mov	ebp, esp
	.cfi_def_cfa_register 5
	sub	esp, 4
	call	__x86.get_pc_thunk.ax
	add	eax, OFFSET FLAT:_GLOBAL_OFFSET_TABLE_
	mov	edx, DWORD PTR 12[ebp]
	mov	BYTE PTR -4[ebp], dl
	jmp	.L2
.L3:
	mov	edx, DWORD PTR p.0@GOTOFF[eax]
	lea	ecx, 1[edx]
	mov	DWORD PTR p.0@GOTOFF[eax], ecx
	mov	ecx, DWORD PTR 8[ebp]
	movzx	ecx, BYTE PTR [ecx]
	mov	BYTE PTR [edx], cl
	mov	edx, DWORD PTR p.0@GOTOFF[eax]
	lea	ecx, 1[edx]
	mov	DWORD PTR p.0@GOTOFF[eax], ecx
	movzx	ecx, BYTE PTR -4[ebp]
	mov	BYTE PTR [edx], cl
	add	DWORD PTR 8[ebp], 1
.L2:
	mov	edx, DWORD PTR 8[ebp]
	movzx	edx, BYTE PTR [edx]
	test	dl, dl
	jne	.L3
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	printS, .-printS
	.section	.rodata
.LC0:
	.string	"abc"
	.text
	.globl	kernel
	.type	kernel, @function
kernel:
.LFB1:
	.cfi_startproc
	push	ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	mov	ebp, esp
	.cfi_def_cfa_register 5
	call	__x86.get_pc_thunk.ax
	add	eax, OFFSET FLAT:_GLOBAL_OFFSET_TABLE_
	push	242
	lea	eax, .LC0@GOTOFF[eax]
	push	eax
	call	printS
	add	esp, 8
#APP
# 21 "./kernel/kernel.c" 1
	hlt

# 0 "" 2
#NO_APP
	mov	eax, 1
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE1:
	.size	kernel, .-kernel
	.data
	.align 4
	.type	p.0, @object
	.size	p.0, 4
p.0:
	.long	753664
	.section	.text.__x86.get_pc_thunk.ax,"axG",@progbits,__x86.get_pc_thunk.ax,comdat
	.globl	__x86.get_pc_thunk.ax
	.hidden	__x86.get_pc_thunk.ax
	.type	__x86.get_pc_thunk.ax, @function
__x86.get_pc_thunk.ax:
.LFB2:
	.cfi_startproc
	mov	eax, DWORD PTR [esp]
	ret
	.cfi_endproc
.LFE2:
	.ident	"GCC: (GNU) 12.2.1 20230111"
	.section	.note.GNU-stack,"",@progbits
