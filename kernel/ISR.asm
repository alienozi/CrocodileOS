bits 32
INT89_Entry: dd INT89-INT_SERVICE_START
INT5_Entry: dd INT5-INT_SERVICE_START
INT7_Entry: dd INT7-INT_SERVICE_START
Entry_terminator: dd 0 
INT_SERVICE_START: 

INT89:
_LFB0:
	       
	push	ebp
	mov	ebp, esp
	call	__x86.get_pc_thunk.ax
 OFFSET_LABEL0:
	add	eax,  -OFFSET_LABEL0
	mov [0xb8000+160],word 0xf0db

	nop
	pop	ebp
	iretd
_LFE0:
INT5:
_LFB1:
	       
	push	ebp
	mov	ebp, esp
	call	__x86.get_pc_thunk.ax
 OFFSET_LABEL1:
	add	eax,  -OFFSET_LABEL1
	nop
	pop	ebp
	iretd
_LFE1:
INT7:
_LFB2:
	       
	push	ebp
	mov	ebp, esp
	call	__x86.get_pc_thunk.ax
 OFFSET_LABEL2:
	add	eax,  -OFFSET_LABEL2
	nop
	pop	ebp
	iretd
_LFE2:
__x86.get_pc_thunk.ax:
_LFB3:
	mov	eax, DWORD [esp]
	ret
_LFE3:
