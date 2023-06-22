#!/bin/bash
TYPE="SHREK"
BASE_ADDR=0x7c00
i=1
for arg in "$@" 
do
    i=`expr $i + 1`
    case $arg in
      --bare_metal | -bm)
        TYPE="BARE_METAL"
        MAIN_ADDR_FILE=${!i}
        ;;
      -o)
        OUTPUT=${!i}
        #echo $OUTPUT
        ;;
      -I)
        MORE_PATH=" -I ${!i} $MORE_PATH"
        #echo $MORE_PATH
        ;;
      -O1 | -O2 | -O3 | -O4)
        OPT=$arg
        ;;
      *)
        i_sub=`expr $i - 2`
        if [[ ${!i_sub} == "--bare_metal" ]] || [[ ${!i_sub} == "-bm" ]] || [[ ${!i_sub} == "-o" ]] || [[ ${!i_sub} == "-I" ]]
        then
          printf ""
	else
          INPUTS=" $arg $INPUTS"
        fi
        #echo $INPUTS
        ;;
    esac
done

eval "gcc $INPUTS -m32 -masm=intel $OPT -fno-pie -nostdlib -e main -ffreestanding $MORE_PATH -c -o $OUTPUT.o"
echo "gcc $INPUTS -m32 -masm=intel -nostdinc -e main -ffreestanding $MORE_PATH -c -o $OUTPUT.o"
DATA_SIZE=`size -A $OUTPUT.o | grep -F ".data" | tr -s [:space:] "\n" | sed -n 2p`
RODATA_SIZE=`size -A $OUTPUT.o| grep -F ".rodata" | tr -s [:space:] "\n" | sed -n 2p`
BSS_SIZE=`size -A $OUTPUT.o | grep -F ".bss" | tr -s [:space:] "\n" | sed -n 2p`
TEXT_SIZE=`size -A $OUTPUT.o | grep -F ".text" | tr -s [:space:] "\n" | sed -n 2p`
if [[ $DATA_SIZE == "" ]]
then
  DATA_SIZE=0
fi
if [[ $RODATA_SIZE == "" ]]
then
  RODATA_SIZE=0
fi
if [[ $BSS_SIZE == "" ]]
then
  BSS_SIZE=0
fi
if [[ $TEXT_SIZE == "" ]]
then
  TEXT_SIZE=0
fi
echo "$DATA_SIZE $RODATA_SIZE $BSS_SIZE $TEXT_SIZE"
case $TYPE in
  BARE_METAL)
    TEXT_ADDR=$BASE_ADDR
    DATA_ADDR=`printf "0x%X" $(( $TEXT_ADDR + $TEXT_SIZE + ( (16 - ( $TEXT_SIZE % 16 ) % 16 ) ) ))`
    BSS_ADDR=`printf "0x%X" $(( $DATA_ADDR + $DATA_SIZE + ( (16 - ( $DATA_SIZE % 16 ) ) % 16 ) ))`
    RODATA_ADDR=`printf "0x%X" $(( $BSS_ADDR + $BSS_SIZE + ( (16 - ( $BSS_SIZE % 16 ) ) % 16 ) ))`
    echo "$TEXT_ADDR $DATA_ADDR $BSS_ADDR $RODATA_ADDR"
    eval "ld -melf_i386 -oformat $OUTPUT.o -e main -Ttext=$TEXT_ADDR -Tdata=$DATA_ADDR -Tbss=$BSS_ADDR -Trodata=$RODATA_ADDR -o $OUTPUT.bin"
    eval "objcopy -O binary --only-section=.text $OUTPUT.bin $OUTPUT.text"
    eval "objcopy -O binary --only-section=.data $OUTPUT.bin $OUTPUT.data"
    eval "objcopy -O binary --only-section=.bss $OUTPUT.bin $OUTPUT.bss"
    eval "objcopy -O binary --only-section=.rodata $OUTPUT.bin $OUTPUT.rodata"
    eval "\"%define MAIN_ADDR 0x\$(objdump -S kolpa.bin | grep -F "\<main\>:"| tr -s [:space:] "\n" | sed -n 1p)\" >> $MAIN_ADDR_FILE"
    
    eval "dd if=$OUTPUT.text of=$OUTPUT"
    eval "dd if=/dev/zero of=$OUTPUT bs=1 count=$(( ( (16 - ( $TEXT_SIZE % 16 ) % 16 ) ) )) oflag=append conv=notrunc"
    eval "dd if=$OUTPUT.data of=$OUTPUT oflag=append conv=notrunc"
    eval "dd if=/dev/zero of=$OUTPUT bs=1 count=$(( ( (16 - ( $DATA_SIZE % 16 ) % 16 ) ) )) oflag=append conv=notrunc"
    eval "dd if=$OUTPUT.bss of=$OUTPUT oflag=append conv=notrunc"
    eval "dd if=/dev/zero of=$OUTPUT bs=1 count=$(( ( (16 - ( $BSS_SIZE % 16 ) % 16 ) ) )) oflag=append conv=notrunc"
    eval "dd if=$OUTPUT.rodata of=$OUTPUT oflag=append conv=notrunc"
    eval "dd if=/dev/zero of=$OUTPUT bs=1 count=$(( ( (16 - ( $RODATA_SIZE % 16 ) % 16 ) ) )) oflag=append conv=notrunc"
    ;;
  SHREK)
    echo ""
    ;;
esac
