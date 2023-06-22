
COS.iso: $(shell find iso/ -type f)
	mkisofs -o ./COS.iso -iso-level 2 -no-emul-boot -b  boot/boot.bin ./iso/
	
./iso/boot/boot.bin: $(shell find boot/ functions32/ functions16/ -type f)
	nasm ./boot/boot_cd.asm -f bin -o ./iso/boot/boot.bin;
		
./iso/home/CD_USER/icon.str: ./side_tools/icon.data ./side_tools/imageToString
	./side_tools/imageToString ./side_tools/icon.data ./side_tools/image.asm 80 50;nasm ./side_tools/image.asm -o ./iso/home/CD_USER/icon.str;

./side_tools/imageToString: ./side_tools/imageToString.c
	gcc ./side_tools/imageToString.c -o ./side_tools/imageToString

./iso/kernel/kernel.shrek: ./kernel/kernel.c $(shell find OS_functions/ -type f) ./SHREK/CSC
	./SHREK/CSC ./kernel/kernel.c -Vaddr 0x1000 -I ./OS_functions/general -I ./OS_functions/user -I ./OS_functions/kernel ;mv ./kernel/kernel.shrek ./iso/kernel/kernel.shrek

./SHREK/CSC: ./SHREK/CSC.cpp
	g++ ./SHREK/CSC.cpp -o ./SHREK/CSC

./SHREK/shrekdump: ./SHREK/shrekdump.cpp
	g++ ./SHREK/shrekdump.cpp -o ./SHREK/shrekdump