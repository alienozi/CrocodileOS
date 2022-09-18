
COS.iso: ./iso/kernel/kernel.bin ./iso/boot/boot.bin ./iso/boot/boot_parameters.bin
	mkisofs -o ./COS.iso -no-emul-boot -b  boot/boot.bin ./iso/
	
./iso/boot/boot.bin: ./boot/boot_cd.asm
	nasm ./boot/boot_cd.asm -f bin -o ./iso/boot/boot.bin
	
./iso/kernel/kernel.bin: ./kernel/kernel.c
	gcc -c -masm=intel -m32 ./kernel/kernel.c;objcopy -O binary --adjust-vma=0x100000000 -j .text kernel.o  ./iso/kernel/kernel.bin;./side_tools/kernelEdit ./iso/kernel/kernel.bin ./side_tools/kernel_fix.data 7;rm kernel.o
