COMPILING_OS:=$(shell uname -r)
COMPILING_HOST:=$(shell uname -n)
COMPILING_MACHINE:=$(shell uname -m)
COMPILING_DATE:=$(shell date +"%d:%m:%Y")
COMPILING_TIME:=$(shell date +"%H:%M:%S")
COS.iso: $(shell find iso/ -type f)
	mkisofs -o ./COS.iso -iso-level 2 -no-emul-boot -b BOOT/cd_boot.bin ./iso/

./boot/pre_cd_boot.bin ./iso/BOOT/COS_SIGNATURE.txt: $(shell find functions16/ -type f) ./boot/pre_cd_boot.asm ./boot/MAIN_ADDR_FILE.asm  ./boot/COS_SIGNATURE.asm ./boot/post_cd_boot.bin ./iso/KERNEL/kernel.shrek
	nasm ./boot/pre_cd_boot.asm -f bin -D COMPILING_OS=\"$(COMPILING_OS)\" -D COMPILING_HOST=\"$(COMPILING_HOST)\" \
	-D COMPILING_MACHINE=\"$(COMPILING_MACHINE)\" -D COMPILING_DATE=\"$(COMPILING_DATE)\" -D COMPILING_TIME=\"$(COMPILING_TIME)\" -o ./boot/pre_cd_boot.bin;
	nasm ./boot/COS_SIGNATURE.asm -f bin -D COMPILING_OS=\"$(COMPILING_OS)\" -D COMPILING_HOST=\"$(COMPILING_HOST)\" \
	-D COMPILING_MACHINE=\"$(COMPILING_MACHINE)\" -D COMPILING_DATE=\"$(COMPILING_DATE)\" -D COMPILING_TIME=\"$(COMPILING_TIME)\" -o ./iso/BOOT/COS_SIGNATURE.txt

./boot/post_cd_boot.bin ./boot/MAIN_ADDR_FILE.asm: $(shell find OS_functions/ -type f) ./boot/post_boot.c ./SHREK/CSC.sh ./SHREK/formater
	sh ./SHREK/CSC.sh ./boot/post_boot.c -I ./OS_functions --bare_metal ./boot/MAIN_ADDR_FILE.asm -o ./boot/post_cd_boot.bin;

./iso/BOOT/cd_boot.bin: ./boot/post_cd_boot.bin ./boot/pre_cd_boot.bin
	rm -f ./iso/BOOT/cd_boot.bin;cat ./boot/pre_cd_boot.bin ./boot/post_cd_boot.bin >> ./iso/BOOT/cd_boot.bin;
		
./iso/HOME/_ICONS/icon.str: ./side_tools/icon.data ./side_tools/imageToString
	./side_tools/imageToString ./side_tools/icon.data ./side_tools/image.asm 80 50;nasm ./side_tools/image.asm -o ./iso/HOME/_ICONS/icon.str;

./iso/HOME/_ICONS/hat.str: ./side_tools/icon.data ./side_tools/imageToString
	./side_tools/imageToString ./side_tools/hat.data ./side_tools/hat.asm 80 50;nasm ./side_tools/hat.asm -o ./iso/HOME/_ICONS/hat.str;

./side_tools/imageToString: ./side_tools/imageToString.c
	gcc ./side_tools/imageToString.c -o ./side_tools/imageToString

./SHREK/SHREKdump: ./SHREK/SHREKdump.cpp $(shell find OS_functions/ -type f)
	g++ ./SHREK/SHREKdump.cpp -I ./OS_functions/general -o ./SHREK/SHREKdump

./SHREK/formater: ./SHREK/formater.cpp $(shell find OS_functions/ -type f)
	g++ ./SHREK/formater.cpp -I ./OS_functions/general -o ./SHREK/formater

./iso/KERNEL/kernel.shrek: $(shell find OS_functions/ -type f) ./kernel/kernel.c ./SHREK/CSC.sh ./SHREK/formater
	sh ./SHREK/CSC.sh ./kernel/kernel.c -shrek kernel -I ./OS_functions -o ./iso/KERNEL/kernel.shrek
