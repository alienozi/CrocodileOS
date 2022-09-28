
COS.iso: $(shell find iso/ -type f)
	mkisofs -o ./COS.iso -iso-level 2 -no-emul-boot -b  boot/boot.bin ./iso/
	
./iso/boot/boot.bin: $(shell find boot/ functions32/ functions16/ -type f)
	nasm ./boot/boot_cd.asm -f bin -o ./iso/boot/boot.bin;
	
./kernel/kernel.asm: ./kernel/kernel.c ./side_tools/asmEdit
	gcc -c -masm=intel -m32 -S ./kernel/kernel.c -o ./kernel/kernel.s;./side_tools/asmEdit ./kernel/kernel.s ./kernel/kernel.asm;rm ./kernel/kernel.s;
	
./side_tools/asmEdit: ./side_tools/asmEdit.c
	gcc ./side_tools/asmEdit.c -o ./side_tools/asmEdit;
	
./side_tools/isrEdit: ./side_tools/isrEdit.c
	gcc ./side_tools/isrEdit.c -o ./side_tools/isrEdit;

./iso/kernel/kernel.bin: ./kernel/kernel.asm
	nasm -f bin ./kernel/kernel.asm -o ./iso/kernel/kernel.bin;
	
./iso/boot/boot_parameters.bin: ./boot/boot_parameters.asm
	nasm -f bin ./boot/boot_parameters.asm -o ./iso/boot/boot_parameters.bin;
	
./iso/home/CD_USER/icon.str: ./side_tools/icon.data ./side_tools/imageToString
	./side_tools/imageToString ./side_tools/icon.data ./side_tools/image.asm 80 50;	nasm ./side_tools/image.asm -o ./iso/home/CD_USER/icon.str;

./side_tools/imageToString: ./side_tools/imageToString.c
	gcc ./side_tools/imageToString.c -o ./side_tools/imageToString

./kernel/ISR.asm: ./kernel/ISR.c ./side_tools/asmEdit
	gcc -c -masm=intel -m32 -S ./kernel/ISR.c -o ./kernel/ISR.s;./side_tools/asmEdit ./kernel/ISR.s ./kernel/ISR.asm -IDT;rm ./kernel/ISR.s;
	
./iso/kernel/ISR.bin ./kernel/IDT.asm: ./kernel/ISR.asm ./side_tools/isrEdit
	nasm -f bin ./kernel/ISR.asm -o file.bin;./side_tools/isrEdit ./kernel/ISR.asm ./file.bin ./iso/kernel/ISR.bin ./kernel/IDT.asm;rm file.bin;
