	.file	"kernel.c"
	.intel_syntax noprefix
	.text
	.globl	pri_print
	.type	pri_print, @function
pri_print:
.LFB0:
	.cfi_startproc
	push	ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	mov	ebp, esp
	.cfi_def_cfa_register 5
	push	ebx
	sub	esp, 20
	.cfi_offset 3, -12
	call	__x86.get_pc_thunk.cx
	add	ecx, OFFSET FLAT:_GLOBAL_OFFSET_TABLE_
	mov	eax, DWORD PTR 8[ebp]
	mov	BYTE PTR -24[ebp], al
	lea	eax, 12[ebp]
	mov	DWORD PTR -16[ebp], eax
	jmp	.L2
.L33:
	mov	eax, DWORD PTR 12[ebp]
	movzx	eax, BYTE PTR [eax]
	cmp	al, 37
	jne	.L3
	mov	eax, DWORD PTR 12[ebp]
	add	eax, 1
	mov	DWORD PTR 12[ebp], eax
	add	DWORD PTR -16[ebp], 4
	mov	eax, DWORD PTR 12[ebp]
	movzx	eax, BYTE PTR [eax]
	movsx	eax, al
	sub	eax, 82
	cmp	eax, 38
	ja	.L32
	sal	eax, 2
	mov	eax, DWORD PTR .L6@GOTOFF[eax+ecx]
	add	eax, ecx
	jmp	eax
	.section	.rodata
	.align 4
	.align 4
.L6:
	.long	.L14@GOTOFF
	.long	.L32@GOTOFF
	.long	.L32@GOTOFF
	.long	.L32@GOTOFF
	.long	.L32@GOTOFF
	.long	.L32@GOTOFF
	.long	.L5@GOTOFF
	.long	.L32@GOTOFF
	.long	.L32@GOTOFF
	.long	.L32@GOTOFF
	.long	.L32@GOTOFF
	.long	.L32@GOTOFF
	.long	.L32@GOTOFF
	.long	.L32@GOTOFF
	.long	.L32@GOTOFF
	.long	.L32@GOTOFF
	.long	.L32@GOTOFF
	.long	.L13@GOTOFF
	.long	.L12@GOTOFF
	.long	.L32@GOTOFF
	.long	.L32@GOTOFF
	.long	.L32@GOTOFF
	.long	.L32@GOTOFF
	.long	.L12@GOTOFF
	.long	.L32@GOTOFF
	.long	.L32@GOTOFF
	.long	.L32@GOTOFF
	.long	.L32@GOTOFF
	.long	.L29@GOTOFF
	.long	.L10@GOTOFF
	.long	.L7@GOTOFF
	.long	.L32@GOTOFF
	.long	.L32@GOTOFF
	.long	.L9@GOTOFF
	.long	.L8@GOTOFF
	.long	.L7@GOTOFF
	.long	.L32@GOTOFF
	.long	.L32@GOTOFF
	.long	.L5@GOTOFF
	.text
.L13:
	mov	eax, DWORD PTR cursor.0@GOTOFF[ecx]
	lea	edx, 1[eax]
	mov	DWORD PTR cursor.0@GOTOFF[ecx], edx
	mov	edx, DWORD PTR -16[ebp]
	movzx	edx, BYTE PTR [edx]
	mov	BYTE PTR [eax], dl
	mov	eax, DWORD PTR cursor.0@GOTOFF[ecx]
	lea	edx, 1[eax]
	mov	DWORD PTR cursor.0@GOTOFF[ecx], edx
	movzx	edx, BYTE PTR -24[ebp]
	mov	BYTE PTR [eax], dl
	jmp	.L32
.L12:
	mov	eax, DWORD PTR -16[ebp]
	mov	eax, DWORD PTR [eax]
	test	eax, eax
	jns	.L7
	mov	eax, DWORD PTR cursor.0@GOTOFF[ecx]
	lea	edx, 1[eax]
	mov	DWORD PTR cursor.0@GOTOFF[ecx], edx
	mov	BYTE PTR [eax], 45
	mov	eax, DWORD PTR cursor.0@GOTOFF[ecx]
	lea	edx, 1[eax]
	mov	DWORD PTR cursor.0@GOTOFF[ecx], edx
	movzx	edx, BYTE PTR -24[ebp]
	mov	BYTE PTR [eax], dl
	mov	eax, DWORD PTR -16[ebp]
	mov	eax, DWORD PTR [eax]
	neg	eax
	mov	edx, eax
	mov	eax, DWORD PTR -16[ebp]
	mov	DWORD PTR [eax], edx
.L7:
#APP
# 24 "./OS_functions/kernel/primative.h" 1
	push 10

# 0 "" 2
#NO_APP
.L15:
	mov	eax, DWORD PTR -16[ebp]
	mov	ebx, DWORD PTR [eax]
	mov	edx, -858993459
	mov	eax, ebx
	mul	edx
	shr	edx, 3
	mov	eax, edx
	sal	eax, 2
	add	eax, edx
	add	eax, eax
	sub	ebx, eax
	mov	edx, ebx
#APP
# 26 "./OS_functions/kernel/primative.h" 1
	push edx

# 0 "" 2
#NO_APP
	mov	eax, DWORD PTR -16[ebp]
	mov	eax, DWORD PTR [eax]
	mov	edx, -858993459
	mul	edx
	shr	edx, 3
	mov	eax, DWORD PTR -16[ebp]
	mov	DWORD PTR [eax], edx
	mov	eax, DWORD PTR -16[ebp]
	mov	eax, DWORD PTR [eax]
	test	eax, eax
	jne	.L15
#APP
# 29 "./OS_functions/kernel/primative.h" 1
	pop edx
add dl,'0'

# 0 "" 2
#NO_APP
	mov	eax, edx
	mov	BYTE PTR -17[ebp], al
	jmp	.L16
.L17:
	mov	eax, DWORD PTR cursor.0@GOTOFF[ecx]
	movzx	edx, BYTE PTR -17[ebp]
	mov	BYTE PTR [eax], dl
	mov	eax, DWORD PTR cursor.0@GOTOFF[ecx]
	add	eax, 1
	mov	DWORD PTR cursor.0@GOTOFF[ecx], eax
	mov	eax, DWORD PTR cursor.0@GOTOFF[ecx]
	lea	edx, 1[eax]
	mov	DWORD PTR cursor.0@GOTOFF[ecx], edx
	movzx	edx, BYTE PTR -24[ebp]
	mov	BYTE PTR [eax], dl
#APP
# 34 "./OS_functions/kernel/primative.h" 1
	pop edx
add dl,'0'

# 0 "" 2
#NO_APP
	mov	eax, edx
	mov	BYTE PTR -17[ebp], al
.L16:
	cmp	BYTE PTR -17[ebp], 57
	jle	.L17
	jmp	.L32
.L5:
#APP
# 39 "./OS_functions/kernel/primative.h" 1
	push 127

# 0 "" 2
#NO_APP
.L20:
	mov	eax, DWORD PTR -16[ebp]
	mov	eax, DWORD PTR [eax]
	and	eax, 15
	cmp	eax, 9
	jbe	.L18
	mov	eax, DWORD PTR -16[ebp]
	mov	eax, DWORD PTR [eax]
	and	eax, 15
	mov	edx, eax
	mov	eax, DWORD PTR 12[ebp]
	movzx	eax, BYTE PTR [eax]
	movsx	eax, al
	add	eax, edx
	sub	eax, 33
	jmp	.L19
.L18:
	mov	eax, DWORD PTR -16[ebp]
	mov	eax, DWORD PTR [eax]
	and	eax, 15
	add	eax, 48
.L19:
#APP
# 41 "./OS_functions/kernel/primative.h" 1
	push eax

# 0 "" 2
#NO_APP
	mov	eax, DWORD PTR -16[ebp]
	mov	eax, DWORD PTR [eax]
	shr	eax, 4
	mov	edx, eax
	mov	eax, DWORD PTR -16[ebp]
	mov	DWORD PTR [eax], edx
	mov	eax, DWORD PTR -16[ebp]
	mov	eax, DWORD PTR [eax]
	test	eax, eax
	jne	.L20
#APP
# 44 "./OS_functions/kernel/primative.h" 1
	pop edx

# 0 "" 2
#NO_APP
	mov	eax, edx
	mov	BYTE PTR -17[ebp], al
	jmp	.L21
.L22:
	mov	eax, DWORD PTR cursor.0@GOTOFF[ecx]
	movzx	edx, BYTE PTR -17[ebp]
	mov	BYTE PTR [eax], dl
	mov	eax, DWORD PTR cursor.0@GOTOFF[ecx]
	add	eax, 1
	mov	DWORD PTR cursor.0@GOTOFF[ecx], eax
	mov	eax, DWORD PTR cursor.0@GOTOFF[ecx]
	lea	edx, 1[eax]
	mov	DWORD PTR cursor.0@GOTOFF[ecx], edx
	movzx	edx, BYTE PTR -24[ebp]
	mov	BYTE PTR [eax], dl
#APP
# 49 "./OS_functions/kernel/primative.h" 1
	pop edx

# 0 "" 2
#NO_APP
	mov	eax, edx
	mov	BYTE PTR -17[ebp], al
.L21:
	cmp	BYTE PTR -17[ebp], 102
	jle	.L22
	jmp	.L32
.L9:
	mov	DWORD PTR -12[ebp], 0
	jmp	.L23
.L24:
	mov	eax, DWORD PTR -16[ebp]
	mov	edx, DWORD PTR [eax]
	mov	eax, DWORD PTR -12[ebp]
	add	eax, edx
	mov	ebx, eax
	mov	eax, DWORD PTR cursor.0@GOTOFF[ecx]
	lea	edx, 1[eax]
	mov	DWORD PTR cursor.0@GOTOFF[ecx], edx
	movzx	edx, BYTE PTR [ebx]
	mov	BYTE PTR [eax], dl
	mov	eax, DWORD PTR cursor.0@GOTOFF[ecx]
	lea	edx, 1[eax]
	mov	DWORD PTR cursor.0@GOTOFF[ecx], edx
	movzx	edx, BYTE PTR -24[ebp]
	mov	BYTE PTR [eax], dl
	add	DWORD PTR -12[ebp], 1
.L23:
	mov	eax, DWORD PTR -16[ebp]
	mov	edx, DWORD PTR [eax]
	mov	eax, DWORD PTR -12[ebp]
	add	eax, edx
	movzx	eax, BYTE PTR [eax]
	test	al, al
	jne	.L24
	jmp	.L32
.L10:
#APP
# 59 "./OS_functions/kernel/primative.h" 1
	push 10

# 0 "" 2
#NO_APP
	jmp	.L25
.L26:
	mov	eax, DWORD PTR -16[ebp]
	mov	eax, DWORD PTR [eax]
	and	eax, 7
#APP
# 61 "./OS_functions/kernel/primative.h" 1
	push eax

# 0 "" 2
#NO_APP
	mov	eax, DWORD PTR -16[ebp]
	mov	eax, DWORD PTR [eax]
	shr	eax, 3
	mov	edx, eax
	mov	eax, DWORD PTR -16[ebp]
	mov	DWORD PTR [eax], edx
.L25:
	mov	eax, DWORD PTR -16[ebp]
	mov	eax, DWORD PTR [eax]
	test	eax, eax
	jne	.L26
#APP
# 64 "./OS_functions/kernel/primative.h" 1
	pop edx
add dl,'0'

# 0 "" 2
#NO_APP
	mov	eax, edx
	mov	BYTE PTR -17[ebp], al
	jmp	.L27
.L28:
	mov	eax, DWORD PTR cursor.0@GOTOFF[ecx]
	movzx	edx, BYTE PTR -17[ebp]
	mov	BYTE PTR [eax], dl
	mov	eax, DWORD PTR cursor.0@GOTOFF[ecx]
	add	eax, 1
	mov	DWORD PTR cursor.0@GOTOFF[ecx], eax
	mov	eax, DWORD PTR cursor.0@GOTOFF[ecx]
	lea	edx, 1[eax]
	mov	DWORD PTR cursor.0@GOTOFF[ecx], edx
	movzx	edx, BYTE PTR -24[ebp]
	mov	BYTE PTR [eax], dl
#APP
# 69 "./OS_functions/kernel/primative.h" 1
	pop edx
add dl,'0'

# 0 "" 2
#NO_APP
	mov	eax, edx
	mov	BYTE PTR -17[ebp], al
.L27:
	cmp	BYTE PTR -17[ebp], 55
	jle	.L28
	jmp	.L32
.L34:
	nop
.L29:
	mov	eax, DWORD PTR cursor.0@GOTOFF[ecx]
	lea	edx, 1[eax]
	mov	DWORD PTR cursor.0@GOTOFF[ecx], edx
	mov	BYTE PTR [eax], 32
	mov	eax, DWORD PTR cursor.0@GOTOFF[ecx]
	lea	edx, 1[eax]
	mov	DWORD PTR cursor.0@GOTOFF[ecx], edx
	movzx	edx, BYTE PTR -24[ebp]
	mov	BYTE PTR [eax], dl
	mov	eax, DWORD PTR cursor.0@GOTOFF[ecx]
	mov	ebx, eax
	mov	edx, -858993459
	mov	eax, ebx
	mul	edx
	shr	edx, 7
	mov	eax, edx
	sal	eax, 2
	add	eax, edx
	sal	eax, 5
	sub	ebx, eax
	mov	edx, ebx
	test	edx, edx
	jne	.L34
	jmp	.L32
.L8:
	mov	DWORD PTR -8[ebp], 8
	jmp	.L30
.L31:
	mov	eax, DWORD PTR cursor.0@GOTOFF[ecx]
	lea	edx, 1[eax]
	mov	DWORD PTR cursor.0@GOTOFF[ecx], edx
	mov	BYTE PTR [eax], 32
	mov	eax, DWORD PTR cursor.0@GOTOFF[ecx]
	lea	edx, 1[eax]
	mov	DWORD PTR cursor.0@GOTOFF[ecx], edx
	movzx	edx, BYTE PTR -24[ebp]
	mov	BYTE PTR [eax], dl
	sub	DWORD PTR -8[ebp], 1
.L30:
	cmp	DWORD PTR -8[ebp], 0
	jg	.L31
	jmp	.L32
.L14:
	mov	DWORD PTR cursor.0@GOTOFF[ecx], 0
	jmp	.L32
.L3:
	mov	edx, DWORD PTR 12[ebp]
	mov	eax, DWORD PTR cursor.0@GOTOFF[ecx]
	movzx	edx, BYTE PTR [edx]
	mov	BYTE PTR [eax], dl
	mov	eax, DWORD PTR cursor.0@GOTOFF[ecx]
	add	eax, 1
	mov	DWORD PTR cursor.0@GOTOFF[ecx], eax
	mov	eax, DWORD PTR cursor.0@GOTOFF[ecx]
	lea	edx, 1[eax]
	mov	DWORD PTR cursor.0@GOTOFF[ecx], edx
	movzx	edx, BYTE PTR -24[ebp]
	mov	BYTE PTR [eax], dl
.L32:
	mov	eax, DWORD PTR 12[ebp]
	add	eax, 1
	mov	DWORD PTR 12[ebp], eax
.L2:
	mov	eax, DWORD PTR 12[ebp]
	movzx	eax, BYTE PTR [eax]
	test	al, al
	jne	.L33
	nop
	nop
	mov	ebx, DWORD PTR -4[ebp]
	leave
	.cfi_restore 5
	.cfi_restore 3
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	pri_print, .-pri_print
	.section	.rodata
.LC0:
	.string	"test"
	.text
	.globl	test
	.type	test, @function
test:
.LFB1:
	.cfi_startproc
	push	ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	mov	ebp, esp
	.cfi_def_cfa_register 5
	call	__x86.get_pc_thunk.ax
	add	eax, OFFSET FLAT:_GLOBAL_OFFSET_TABLE_
	lea	eax, .LC0@GOTOFF[eax]
	push	eax
	push	15
	call	pri_print
	add	esp, 8
	mov	eax, 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE1:
	.size	test, .-test
	.section	.rodata
.LC1:
	.string	"deneme deneme 1 2 3"
.LC2:
	.string	"deneme d443"
	.text
	.globl	main
	.type	main, @function
main:
.LFB2:
	.cfi_startproc
	push	ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	mov	ebp, esp
	.cfi_def_cfa_register 5
	push	ebx
	.cfi_offset 3, -12
	call	__x86.get_pc_thunk.bx
	add	ebx, OFFSET FLAT:_GLOBAL_OFFSET_TABLE_
	lea	eax, .LC1@GOTOFF[ebx]
	push	eax
	push	15
	call	pri_print
	add	esp, 8
	lea	eax, .LC2@GOTOFF[ebx]
	push	eax
	push	15
	call	pri_print
	add	esp, 8
#APP
# 11 "./kernel/kernel.c" 1
	hlt

# 0 "" 2
#NO_APP
	mov	eax, 0
	mov	ebx, DWORD PTR -4[ebp]
	leave
	.cfi_restore 5
	.cfi_restore 3
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE2:
	.size	main, .-main
	.data
	.align 4
	.type	cursor.0, @object
	.size	cursor.0, 4
cursor.0:
	.long	753664
	.section	.text.__x86.get_pc_thunk.ax,"axG",@progbits,__x86.get_pc_thunk.ax,comdat
	.globl	__x86.get_pc_thunk.ax
	.hidden	__x86.get_pc_thunk.ax
	.type	__x86.get_pc_thunk.ax, @function
__x86.get_pc_thunk.ax:
.LFB3:
	.cfi_startproc
	mov	eax, DWORD PTR [esp]
	ret
	.cfi_endproc
.LFE3:
	.section	.text.__x86.get_pc_thunk.cx,"axG",@progbits,__x86.get_pc_thunk.cx,comdat
	.globl	__x86.get_pc_thunk.cx
	.hidden	__x86.get_pc_thunk.cx
	.type	__x86.get_pc_thunk.cx, @function
__x86.get_pc_thunk.cx:
.LFB4:
	.cfi_startproc
	mov	ecx, DWORD PTR [esp]
	ret
	.cfi_endproc
.LFE4:
	.section	.text.__x86.get_pc_thunk.bx,"axG",@progbits,__x86.get_pc_thunk.bx,comdat
	.globl	__x86.get_pc_thunk.bx
	.hidden	__x86.get_pc_thunk.bx
	.type	__x86.get_pc_thunk.bx, @function
__x86.get_pc_thunk.bx:
.LFB5:
	.cfi_startproc
	mov	ebx, DWORD PTR [esp]
	ret
	.cfi_endproc
.LFE5:
	.ident	"GCC: (GNU) 12.2.1 20230201"
	.section	.note.GNU-stack,"",@progbits
