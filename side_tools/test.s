	.file	"test.c"
	.intel_syntax noprefix
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	endbr32
	push	ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	mov	ebp, esp
	.cfi_def_cfa_register 5
	sub	esp, 16
	call	__x86.get_pc_thunk.ax
	add	eax, OFFSET FLAT:_GLOBAL_OFFSET_TABLE_
	mov	DWORD PTR -8[ebp], 888
	mov	DWORD PTR -4[ebp], 555
	mov	DWORD PTR o.1514@GOTOFF[eax], 888
	mov	edx, DWORD PTR o.1514@GOTOFF[eax]
	add	edx, 1
	mov	DWORD PTR o.1514@GOTOFF[eax], edx
	mov	edx, DWORD PTR p.1515@GOTOFF[eax]
	add	edx, 1
	mov	DWORD PTR p.1515@GOTOFF[eax], edx
	mov	edx, DWORD PTR u.1513@GOTOFF[eax]
	add	edx, 1
	mov	DWORD PTR u.1513@GOTOFF[eax], edx
	mov	edx, DWORD PTR -8[ebp]
	mov	DWORD PTR c.1506@GOTOFF[eax], edx
	mov	edx, DWORD PTR b.1505@GOTOFF[eax]
	mov	DWORD PTR -4[ebp], edx
	mov	edx, DWORD PTR c.1506@GOTOFF[eax]
	add	edx, 1
	mov	DWORD PTR c.1506@GOTOFF[eax], edx
	add	DWORD PTR -4[ebp], 1
	mov	BYTE PTR -10[ebp], 55
	mov	BYTE PTR -9[ebp], 22
	mov	eax, 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.local	o.1514
	.comm	o.1514,4,4
	.local	p.1515
	.comm	p.1515,4,4
	.local	u.1513
	.comm	u.1513,4,4
	.data
	.align 4
	.type	c.1506, @object
	.size	c.1506, 4
c.1506:
	.long	666
	.section	.rodata
	.align 4
	.type	b.1505, @object
	.size	b.1505, 4
b.1505:
	.long	777
	.data
	.align 4
	.type	array.1521, @object
	.size	array.1521, 20
array.1521:
	.long	0
	.long	1
	.long	2
	.long	3
	.long	4
	.section	.rodata
	.type	dd.1520, @object
	.size	dd.1520, 1
dd.1520:
	.byte	45
	.data
	.align 2
	.type	cc.1519, @object
	.size	cc.1519, 2
cc.1519:
	.value	88
	.local	y.1512
	.comm	y.1512,4,4
	.local	t.1511
	.comm	t.1511,4,4
	.local	r.1510
	.comm	r.1510,4,4
	.local	e.1509
	.comm	e.1509,4,4
	.align 4
	.type	w.1508, @object
	.size	w.1508, 4
w.1508:
	.long	11
	.align 4
	.type	q.1507, @object
	.size	q.1507, 4
q.1507:
	.long	234
	.section	.text.__x86.get_pc_thunk.ax,"axG",@progbits,__x86.get_pc_thunk.ax,comdat
	.globl	__x86.get_pc_thunk.ax
	.hidden	__x86.get_pc_thunk.ax
	.type	__x86.get_pc_thunk.ax, @function
__x86.get_pc_thunk.ax:
.LFB1:
	.cfi_startproc
	mov	eax, DWORD PTR [esp]
	ret
	.cfi_endproc
.LFE1:
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 4
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 4
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 4
4:
