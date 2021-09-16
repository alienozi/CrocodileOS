[bits 16]
mov ax, 0x7c0
mov ds, ax
mov bx, msg            ; bx is parameter move the memory address of our message string into bx
call print
jmp $			;infinite jump

print:
	push ax		;pushing necessary registers
	push bx
	mov ah, 0x0e
loop1:
	mov al, [bx]
	cmp al, 0	;ending condition
	je end
	int 0x10
	inc bx
	jmp loop1
end:
    pop bx
    pop ax
    ret

;DATA
msg:    db 'ANAN',0

times 510 -( $ - $$ ) db 0 
dw 0xaa55
