; Compile: nasm pci.asm -f bin -o test.bin
; 
; Author: Totan
; see od -t x1 -A n test.bin
bits 16
	call jmp
jmp:			
	pop ax		
	cli		
	shr ax,4
	mov ds,ax
	mov si,data1
	call __printStringx86
	mov si,data2
	mov es,ax
	mov bp,0x7000
	mov sp,bp
	mov cx,256
	
loop1:
	push cx
	mov cx,32
loop2:	
	mov ah,[bp-2]
	mov al,cl
	dec al
	shl al,3
	shl eax,8
	mov edx,0x80000000
	or eax,edx
	mov dx,0xcf8
	mov al,8
	out dx,eax
	mov dx,0xcfc
	in eax,dx
	cmp ax,0xffff
	je next
	shr eax,16
	mov dl,al
	shr ax,8
	call __binaryToDecimalx86
	call __printStringx86
	mov al,dl
	call __binaryToDecimalx86
	call __printStringx86
next:
	loop loop2
next_loop:
	pop cx
	loop loop1
	
the_end:
	hlt
%include "__printStringx86.asm"
%include "__binaryToDecimalx86.asm"
data1:	db 10,0
data2: db " ",0
	times 510-($-$$) db 0
MBR_P1:
	;db 0x80 ,1,1,0,0x06,16,16,16
	;dd 0,4096
	;times 48 db 0
	dw 0xaa55
