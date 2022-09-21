	.file	"imageToString.c"
	.text
	.section	.rodata
.LC0:
	.string	"r"
.LC1:
	.string	"w+"
.LC2:
	.string	"-C"
.LC3:
	.string	"dw "
.LC4:
	.string	"%u, "
.LC5:
	.string	" \n"
.LC6:
	.string	"{ "
.LC7:
	.string	"0 } "
	.text
	.globl	main
	.type	main, @function
main:
.LFB6:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$96, %rsp
	movl	%edi, -84(%rbp)
	movq	%rsi, -96(%rbp)
	movq	-96(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	leaq	.LC0(%rip), %rsi
	movq	%rax, %rdi
	call	fopen@PLT
	movq	%rax, -24(%rbp)
	movq	-96(%rbp), %rax
	addq	$16, %rax
	movq	(%rax), %rax
	leaq	.LC1(%rip), %rsi
	movq	%rax, %rdi
	call	fopen@PLT
	movq	%rax, -16(%rbp)
	movq	-96(%rbp), %rax
	addq	$24, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -40(%rbp)
	movq	-96(%rbp), %rax
	addq	$32, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -36(%rbp)
	movl	-40(%rbp), %eax
	imull	-36(%rbp), %eax
	sall	$2, %eax
	cltq
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -8(%rbp)
	movl	-40(%rbp), %eax
	imull	-36(%rbp), %eax
	movl	%eax, %edx
	movl	-40(%rbp), %eax
	addl	%edx, %eax
	cltq
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -32(%rbp)
	movl	$0, -68(%rbp)
	movl	-40(%rbp), %eax
	imull	-36(%rbp), %eax
	sall	$2, %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rcx
	movq	-8(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	fread@PLT
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	fclose@PLT
	movl	$0, -64(%rbp)
	jmp	.L2
.L71:
	movl	$0, -60(%rbp)
	jmp	.L3
.L70:
	movl	-36(%rbp), %eax
	subl	-64(%rbp), %eax
	cmpl	$1, %eax
	jle	.L4
	movl	-64(%rbp), %eax
	imull	-40(%rbp), %eax
	movl	%eax, %edx
	movl	-60(%rbp), %eax
	addl	%edx, %eax
	sall	$2, %eax
	movslq	%eax, %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	js	.L5
	movl	-64(%rbp), %eax
	imull	-40(%rbp), %eax
	movl	%eax, %edx
	movl	-60(%rbp), %eax
	addl	%edx, %eax
	sall	$2, %eax
	cltq
	leaq	1(%rax), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	js	.L6
	movl	-64(%rbp), %eax
	imull	-40(%rbp), %eax
	movl	%eax, %edx
	movl	-60(%rbp), %eax
	addl	%edx, %eax
	sall	$2, %eax
	cltq
	leaq	2(%rax), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	jns	.L7
	movl	$4, %eax
	jmp	.L10
.L7:
	movl	$1, %eax
	jmp	.L10
.L6:
	movl	$3, %eax
	jmp	.L10
.L5:
	movl	$2, %eax
.L10:
	movb	%al, -69(%rbp)
	movsbl	-69(%rbp), %eax
	cmpl	$4, %eax
	je	.L11
	cmpl	$4, %eax
	jg	.L59
	cmpl	$3, %eax
	je	.L13
	cmpl	$3, %eax
	jg	.L59
	cmpl	$1, %eax
	je	.L14
	cmpl	$2, %eax
	je	.L15
	jmp	.L59
.L14:
	movq	-32(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -32(%rbp)
	movb	$-36, (%rax)
	movl	-64(%rbp), %eax
	addl	$1, %eax
	imull	-40(%rbp), %eax
	movl	%eax, %edx
	movl	-60(%rbp), %eax
	addl	%edx, %eax
	sall	$2, %eax
	movslq	%eax, %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	js	.L16
	movl	-64(%rbp), %eax
	addl	$1, %eax
	imull	-40(%rbp), %eax
	movl	%eax, %edx
	movl	-60(%rbp), %eax
	addl	%edx, %eax
	sall	$2, %eax
	cltq
	leaq	1(%rax), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	js	.L17
	movl	-64(%rbp), %eax
	addl	$1, %eax
	imull	-40(%rbp), %eax
	movl	%eax, %edx
	movl	-60(%rbp), %eax
	addl	%edx, %eax
	sall	$2, %eax
	cltq
	leaq	2(%rax), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	jns	.L18
	movl	$4, %eax
	jmp	.L21
.L18:
	movl	$1, %eax
	jmp	.L21
.L17:
	movl	$3, %eax
	jmp	.L21
.L16:
	movl	$2, %eax
.L21:
	movb	%al, -69(%rbp)
	movsbl	-69(%rbp), %eax
	cmpl	$4, %eax
	je	.L22
	cmpl	$4, %eax
	jg	.L84
	cmpl	$3, %eax
	je	.L24
	cmpl	$3, %eax
	jg	.L84
	cmpl	$1, %eax
	je	.L25
	cmpl	$2, %eax
	je	.L26
	jmp	.L84
.L25:
	movq	-32(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -32(%rbp)
	movb	$0, (%rax)
	jmp	.L23
.L26:
	movq	-32(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -32(%rbp)
	movb	$15, (%rax)
	jmp	.L23
.L24:
	movq	-32(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -32(%rbp)
	movb	$2, (%rax)
	jmp	.L23
.L22:
	movq	-32(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -32(%rbp)
	movb	$1, (%rax)
	nop
.L23:
	jmp	.L84
.L15:
	movl	-64(%rbp), %eax
	addl	$1, %eax
	imull	-40(%rbp), %eax
	movl	%eax, %edx
	movl	-60(%rbp), %eax
	addl	%edx, %eax
	sall	$2, %eax
	movslq	%eax, %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	js	.L27
	movl	-64(%rbp), %eax
	addl	$1, %eax
	imull	-40(%rbp), %eax
	movl	%eax, %edx
	movl	-60(%rbp), %eax
	addl	%edx, %eax
	sall	$2, %eax
	cltq
	leaq	1(%rax), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	js	.L28
	movl	-64(%rbp), %eax
	addl	$1, %eax
	imull	-40(%rbp), %eax
	movl	%eax, %edx
	movl	-60(%rbp), %eax
	addl	%edx, %eax
	sall	$2, %eax
	cltq
	leaq	2(%rax), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	jns	.L29
	movl	$4, %eax
	jmp	.L32
.L29:
	movl	$1, %eax
	jmp	.L32
.L28:
	movl	$3, %eax
	jmp	.L32
.L27:
	movl	$2, %eax
.L32:
	movb	%al, -69(%rbp)
	movsbl	-69(%rbp), %eax
	cmpl	$4, %eax
	je	.L33
	cmpl	$4, %eax
	jg	.L85
	cmpl	$3, %eax
	je	.L35
	cmpl	$3, %eax
	jg	.L85
	cmpl	$1, %eax
	je	.L36
	cmpl	$2, %eax
	je	.L37
	jmp	.L85
.L36:
	movq	-32(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -32(%rbp)
	movb	$-33, (%rax)
	movq	-32(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -32(%rbp)
	movb	$15, (%rax)
	jmp	.L34
.L37:
	movq	-32(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -32(%rbp)
	movb	$-37, (%rax)
	movq	-32(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -32(%rbp)
	movb	$15, (%rax)
	jmp	.L34
.L35:
	movq	-32(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -32(%rbp)
	movb	$-33, (%rax)
	movq	-32(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -32(%rbp)
	movb	$47, (%rax)
	jmp	.L34
.L33:
	movq	-32(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -32(%rbp)
	movb	$-33, (%rax)
	movq	-32(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -32(%rbp)
	movb	$31, (%rax)
	nop
.L34:
	jmp	.L85
.L13:
	movq	-32(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -32(%rbp)
	movb	$-36, (%rax)
	movl	-64(%rbp), %eax
	addl	$1, %eax
	imull	-40(%rbp), %eax
	movl	%eax, %edx
	movl	-60(%rbp), %eax
	addl	%edx, %eax
	sall	$2, %eax
	movslq	%eax, %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	js	.L38
	movl	-64(%rbp), %eax
	addl	$1, %eax
	imull	-40(%rbp), %eax
	movl	%eax, %edx
	movl	-60(%rbp), %eax
	addl	%edx, %eax
	sall	$2, %eax
	cltq
	leaq	1(%rax), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	js	.L39
	movl	-64(%rbp), %eax
	addl	$1, %eax
	imull	-40(%rbp), %eax
	movl	%eax, %edx
	movl	-60(%rbp), %eax
	addl	%edx, %eax
	sall	$2, %eax
	cltq
	leaq	2(%rax), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	jns	.L40
	movl	$4, %eax
	jmp	.L43
.L40:
	movl	$1, %eax
	jmp	.L43
.L39:
	movl	$3, %eax
	jmp	.L43
.L38:
	movl	$2, %eax
.L43:
	movb	%al, -69(%rbp)
	movsbl	-69(%rbp), %eax
	cmpl	$4, %eax
	je	.L44
	cmpl	$4, %eax
	jg	.L86
	cmpl	$3, %eax
	je	.L46
	cmpl	$3, %eax
	jg	.L86
	cmpl	$1, %eax
	je	.L47
	cmpl	$2, %eax
	je	.L48
	jmp	.L86
.L47:
	movq	-32(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -32(%rbp)
	movb	$32, (%rax)
	jmp	.L45
.L48:
	movq	-32(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -32(%rbp)
	movb	$47, (%rax)
	jmp	.L45
.L46:
	movq	-32(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -32(%rbp)
	movb	$2, (%rax)
	jmp	.L45
.L44:
	movq	-32(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -32(%rbp)
	movb	$33, (%rax)
	nop
.L45:
	jmp	.L86
.L11:
	movq	-32(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -32(%rbp)
	movb	$-36, (%rax)
	movl	-64(%rbp), %eax
	addl	$1, %eax
	imull	-40(%rbp), %eax
	movl	%eax, %edx
	movl	-60(%rbp), %eax
	addl	%edx, %eax
	sall	$2, %eax
	movslq	%eax, %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	js	.L49
	movl	-64(%rbp), %eax
	addl	$1, %eax
	imull	-40(%rbp), %eax
	movl	%eax, %edx
	movl	-60(%rbp), %eax
	addl	%edx, %eax
	sall	$2, %eax
	cltq
	leaq	1(%rax), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	js	.L50
	movl	-64(%rbp), %eax
	addl	$1, %eax
	imull	-40(%rbp), %eax
	movl	%eax, %edx
	movl	-60(%rbp), %eax
	addl	%edx, %eax
	sall	$2, %eax
	cltq
	leaq	2(%rax), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	jns	.L51
	movl	$4, %eax
	jmp	.L54
.L51:
	movl	$1, %eax
	jmp	.L54
.L50:
	movl	$3, %eax
	jmp	.L54
.L49:
	movl	$2, %eax
.L54:
	movb	%al, -69(%rbp)
	movsbl	-69(%rbp), %eax
	cmpl	$4, %eax
	je	.L55
	cmpl	$4, %eax
	jg	.L59
	cmpl	$3, %eax
	je	.L56
	cmpl	$3, %eax
	jg	.L59
	cmpl	$1, %eax
	je	.L57
	cmpl	$2, %eax
	je	.L58
	jmp	.L59
.L57:
	movq	-32(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -32(%rbp)
	movb	$16, (%rax)
	jmp	.L59
.L58:
	movq	-32(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -32(%rbp)
	movb	$31, (%rax)
	jmp	.L59
.L56:
	movq	-32(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -32(%rbp)
	movb	$18, (%rax)
	jmp	.L59
.L55:
	movq	-32(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -32(%rbp)
	movb	$17, (%rax)
	jmp	.L59
.L4:
	movl	-64(%rbp), %eax
	imull	-40(%rbp), %eax
	movl	%eax, %edx
	movl	-60(%rbp), %eax
	addl	%edx, %eax
	sall	$2, %eax
	movslq	%eax, %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	js	.L60
	movl	-64(%rbp), %eax
	imull	-40(%rbp), %eax
	movl	%eax, %edx
	movl	-60(%rbp), %eax
	addl	%edx, %eax
	sall	$2, %eax
	cltq
	leaq	1(%rax), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	js	.L61
	movl	-64(%rbp), %eax
	imull	-40(%rbp), %eax
	movl	%eax, %edx
	movl	-60(%rbp), %eax
	addl	%edx, %eax
	sall	$2, %eax
	cltq
	leaq	2(%rax), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	jns	.L62
	movl	$4, %eax
	jmp	.L65
.L62:
	movl	$1, %eax
	jmp	.L65
.L61:
	movl	$3, %eax
	jmp	.L65
.L60:
	movl	$2, %eax
.L65:
	movb	%al, -69(%rbp)
	movsbl	-69(%rbp), %eax
	cmpl	$4, %eax
	je	.L66
	cmpl	$4, %eax
	jg	.L59
	cmpl	$3, %eax
	je	.L67
	cmpl	$3, %eax
	jg	.L59
	cmpl	$1, %eax
	je	.L68
	cmpl	$2, %eax
	je	.L69
	jmp	.L59
.L68:
	movq	-32(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -32(%rbp)
	movb	$-36, (%rax)
	movq	-32(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -32(%rbp)
	movb	$0, (%rax)
	jmp	.L59
.L69:
	movq	-32(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -32(%rbp)
	movb	$-37, (%rax)
	movq	-32(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -32(%rbp)
	movb	$15, (%rax)
	jmp	.L59
.L67:
	movq	-32(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -32(%rbp)
	movb	$-36, (%rax)
	movq	-32(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -32(%rbp)
	movb	$2, (%rax)
	jmp	.L59
.L66:
	movq	-32(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -32(%rbp)
	movb	$-33, (%rax)
	movq	-32(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -32(%rbp)
	movb	$1, (%rax)
	jmp	.L59
.L84:
	nop
	jmp	.L59
.L85:
	nop
	jmp	.L59
.L86:
	nop
.L59:
	addl	$2, -68(%rbp)
	addl	$1, -60(%rbp)
.L3:
	movl	-60(%rbp), %eax
	cmpl	-40(%rbp), %eax
	jl	.L70
	addl	$2, -64(%rbp)
.L2:
	movl	-64(%rbp), %eax
	cmpl	-36(%rbp), %eax
	jl	.L71
	movl	-68(%rbp), %edx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movb	$0, (%rax)
	movl	-68(%rbp), %eax
	negq	%rax
	addq	%rax, -32(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	cmpl	$5, -84(%rbp)
	jle	.L72
	movq	-96(%rbp), %rax
	addq	$40, %rax
	movq	(%rax), %rax
	leaq	.LC2(%rip), %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L73
.L72:
	movl	$0, -56(%rbp)
	jmp	.L74
.L77:
	movq	-16(%rbp), %rax
	movq	%rax, %rcx
	movl	$3, %edx
	movl	$1, %esi
	leaq	.LC3(%rip), %rdi
	call	fwrite@PLT
	movl	$0, -52(%rbp)
	jmp	.L75
.L76:
	movl	-56(%rbp), %eax
	imull	-40(%rbp), %eax
	addl	%eax, %eax
	movslq	%eax, %rdx
	movl	-52(%rbp), %eax
	cltq
	addq	%rax, %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %edx
	movq	-16(%rbp), %rax
	leaq	.LC4(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	addl	$2, -52(%rbp)
.L75:
	movl	-40(%rbp), %eax
	addl	%eax, %eax
	cmpl	%eax, -52(%rbp)
	jl	.L76
	movq	-16(%rbp), %rax
	movl	$1, %edx
	movq	$-2, %rsi
	movq	%rax, %rdi
	call	fseek@PLT
	movq	-16(%rbp), %rax
	movq	%rax, %rcx
	movl	$2, %edx
	movl	$1, %esi
	leaq	.LC5(%rip), %rdi
	call	fwrite@PLT
	addl	$1, -56(%rbp)
.L74:
	movl	-40(%rbp), %ecx
	movl	-68(%rbp), %eax
	movl	$0, %edx
	divl	%ecx
	shrl	%eax
	movl	%eax, %edx
	movl	-56(%rbp), %eax
	cmpl	%eax, %edx
	ja	.L77
	jmp	.L78
.L73:
	movq	-16(%rbp), %rax
	movq	%rax, %rcx
	movl	$2, %edx
	movl	$1, %esi
	leaq	.LC6(%rip), %rdi
	call	fwrite@PLT
	movl	$0, -48(%rbp)
	jmp	.L79
.L82:
	movl	$0, -44(%rbp)
	jmp	.L80
.L81:
	movl	-48(%rbp), %eax
	imull	-40(%rbp), %eax
	addl	%eax, %eax
	movslq	%eax, %rdx
	movl	-44(%rbp), %eax
	cltq
	addq	%rax, %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %edx
	movq	-16(%rbp), %rax
	leaq	.LC4(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	addl	$2, -44(%rbp)
.L80:
	movl	-40(%rbp), %eax
	addl	%eax, %eax
	cmpl	%eax, -44(%rbp)
	jl	.L81
	addl	$1, -48(%rbp)
.L79:
	movl	-40(%rbp), %ecx
	movl	-68(%rbp), %eax
	movl	$0, %edx
	divl	%ecx
	shrl	%eax
	movl	%eax, %edx
	movl	-48(%rbp), %eax
	cmpl	%eax, %edx
	ja	.L82
	movq	-16(%rbp), %rax
	movq	%rax, %rcx
	movl	$4, %edx
	movl	$1, %esi
	leaq	.LC7(%rip), %rdi
	call	fwrite@PLT
.L78:
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	fclose@PLT
	movq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movl	$1, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:
