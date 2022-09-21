
COS.iso: $(shell find iso/ -type f)
	mkisofs -o ./COS.iso -no-emul-boot -b  boot/boot.bin ./iso/
	
./iso/boot/boot.bin: $(shell find boot/ functions32/ functions16/ -type f)
	nasm ./boot/boot_cd.asm -f bin -o ./iso/boot/boot.bin
	
./kernel/kernel.asm: ./kernel/kernel.c ./side_tools/asmEdit
	gcc -c -masm=intel -m32 -S ./kernel/kernel.c -o ./kernel/kernel.s;./side_tools/asmEdit ./kernel/kernel.s ./kernel/kernel.asm;rm ./kernel/kernel.s;
	
./side_tools/asmEdit: ./side_tools/asmEdit.c
	gcc ./side_tools/asmEdit.c -o ./side_tools/asmEdit
	
./iso/kernel/kernel.bin: ./kernel/kernel.asm
	nasm -f bin ./kernel/kernel.asm -o ./iso/kernel/kernel.bin;
