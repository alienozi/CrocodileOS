
COS.iso: ./iso/kernel/kernel.bin ./iso/boot/boot.bin ./iso/boot/boot_parameters.bin
	mkisofs -o ./COS.iso -no-emul-boot -b  boot/boot.bin ./iso/
	
./iso/boot/boot.bin: ./boot/boot_cd.asm ./functions16/__binaryToDecimal_16.asm ./functions16/__printString_16.asm ./functions16/__enterPM_16.asm ./functions32/__IDE_CD_FILE_READ_32.asm ./functions32/__printString_32.asm ./functions32/__IDE_ATAPI_READ_32.asm
	nasm ./boot/boot_cd.asm -f bin -o ./iso/boot/boot.bin
	
./iso/kernel/kernel.bin: ./kernel/kernel.c ./side_tools/asmEdit
	gcc -c -masm=intel -m32 -S ./kernel/kernel.c -o ./kernel/kernel.s;./side_tools/asmEdit ./kernel/kernel.s ./kernel/kernel.asm;rm ./kernel/kernel.s;nasm -f bin ./kernel/kernel.asm -o ./iso/kernel/kernel.bin;
	
./side_tools/asmEdit: ./side_tools/asmEdit.c
	gcc ./side_tools/asmEdit.c -o ./side_tools/asmEdit
