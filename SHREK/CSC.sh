#!/bin/bash
i=1
for arg in "$@" 
do
    i=`expr $i + 1`
    case $arg in
      --bare_metal | -bm)
        TYPE="BARE_METAL"
        MAIN_ADDR_FILE=${!i}
        ;;
      -shrek | -SHREK)
        TYPE="SHREK"
        SHREK_TYPE=${!i}
        ;;
      -o)
        OUTPUT=${!i}
        #echo $OUTPUT
        ;;
      -I)
        MORE_PATH=" -I ${!i} $MORE_PATH"
        #echo $MORE_PATH
        ;;
      -O1 | -O2 | -O3 | -O4 | -Os)
        OPT=$arg
        ;;
      *)
        i_sub=`expr $i - 2`
        if [[ ${!i_sub} == "--bare_metal" ]] || [[ ${!i_sub} == "-bm" ]] || [[ ${!i_sub} == "-o" ]] || [[ ${!i_sub} == "-I" ]] || [[ ${!i_sub} == "-shrek" ]] || [[ ${!i_sub} == "-SHREK" ]]
        then
          printf ""
	else
          INPUTS=" $arg $INPUTS"
        fi
        #echo $INPUTS
        ;;
    esac
done


case $TYPE in
  BARE_METAL)
    eval "gcc $INPUTS -m32 -masm=intel $OPT -fPIC -fno-asynchronous-unwind-tables -nostdlib -fno-stack-protector -ffreestanding -e main $MORE_PATH -c -o $OUTPUT.o"
    ;;
  SHREK)
    eval "gcc $INPUTS -m32 -masm=intel $OPT -fno-pie -fno-asynchronous-unwind-tables -nostdlib -fno-stack-protector -ffreestanding -e main $MORE_PATH -c -o $OUTPUT.o"
    ;;
esac
eval "ld -melf_i386 -oformat $OUTPUT.o -e main -Ttext=0x00000000 -Tdata=0x40000000 -Tbss=0x80000000 -Trodata=0xC0000000 -o $OUTPUT.bin"
eval "objcopy -O binary --only-section=.text $OUTPUT.bin $OUTPUT.text"
eval "objcopy -O binary --only-section=.data $OUTPUT.bin $OUTPUT.data"
eval "objcopy -O binary --only-section=.rodata $OUTPUT.bin $OUTPUT.rodata"

BSS_SIZE=`size -A $OUTPUT.o | grep -F ".bss" | tr -s [:space:] "\n" | sed -n 2p`

size -A $OUTPUT.o

if test -f "$OUTPUT.text"
then
  TEXT_SIZE=$(wc -c "$OUTPUT.text" | sed 's/ .*//')
else
  TEXT_SIZE=0
fi
if test -f "$OUTPUT.data"
then
  DATA_SIZE=$(wc -c "$OUTPUT.data" | sed 's/ .*//')
else
  DATA_SIZE=0
fi
if test -f "$OUTPUT.rodata"
then
  RODATA_SIZE=$(wc -c "$OUTPUT.rodata" | sed 's/ .*//')
else
  RODATA_SIZE=0
fi
if [[ $BSS_SIZE == "" ]]
then
  BSS_SIZE=0
fi
echo "$TEXT_SIZE $DATA_SIZE $BSS_SIZE $RODATA_SIZE"

case $TYPE in
  BARE_METAL)
    BASE_ADDR="0x7C00"
    TEXT_ADDR="$BASE_ADDR"
    DATA_ADDR=`printf "0x%X" $(( $TEXT_ADDR + $TEXT_SIZE ))`
    DATA_ADDR=`printf "0x%X" $(( $DATA_ADDR + ( (16 - ( $DATA_ADDR % 16 ) ) % 16  )))`
    BSS_ADDR=`printf "0x%X" $(( $DATA_ADDR + $DATA_SIZE ))`
    BSS_ADDR=`printf "0x%X" $(( $BSS_ADDR + ( (16 - ( $BSS_ADDR % 16 ) ) % 16  )))`	
    RODATA_ADDR=`printf "0x%X" $(( $BSS_ADDR + $BSS_SIZE + 16))`
    RODATA_ADDR=`printf "0x%X" $(( $RODATA_ADDR + ( (16 - ( $RODATA_ADDR % 16 ) ) % 16) ))`
    echo "$TEXT_ADDR $DATA_ADDR $BSS_ADDR $RODATA_ADDR"
    eval "ld -melf_i386 -oformat $OUTPUT.o -e main -Ttext=$TEXT_ADDR -Tdata=$DATA_ADDR -Tbss=$BSS_ADDR -Trodata=$RODATA_ADDR -o $OUTPUT.bin"
    echo "ld -melf_i386 -oformat $OUTPUT.o -e main -Ttext=$TEXT_ADDR -Tdata=$DATA_ADDR -Tbss=$BSS_ADDR -Trodata=$RODATA_ADDR -o $OUTPUT.bin"
    eval "objcopy -O binary --only-section=.text $OUTPUT.bin $OUTPUT.text"
    eval "objcopy -O binary --only-section=.data $OUTPUT.bin $OUTPUT.data"
    eval "objcopy -O binary --only-section=.rodata $OUTPUT.bin $OUTPUT.rodata"
    rm -f $MAIN_ADDR_FILE $OUTPUT
    eval "echo \"%define MAIN_ADDR_OFF (0x\$(objdump -S $OUTPUT.bin | grep -F \"<main>:\"| tr -s [:space:] \"\\n\" | sed -n 1p) - $BASE_ADDR)\" >> $MAIN_ADDR_FILE"
    
    eval "dd if=$OUTPUT.text of=$OUTPUT"
    eval "dd if=/dev/zero of=$OUTPUT bs=1 count=$(( $DATA_ADDR - $TEXT_ADDR - $TEXT_SIZE )) oflag=append conv=notrunc"
    eval "dd if=$OUTPUT.data of=$OUTPUT oflag=append conv=notrunc"
    eval "dd if=/dev/zero of=$OUTPUT bs=1 count=$(( $BSS_ADDR - $DATA_ADDR - $DATA_SIZE )) oflag=append conv=notrunc"  
    eval "dd if=/dev/zero of=$OUTPUT bs=1 count=$BSS_SIZE oflag=append conv=notrunc"
    eval "dd if=/dev/zero of=$OUTPUT bs=1 count=$(( $RODATA_ADDR - $BSS_ADDR - $BSS_SIZE )) oflag=append conv=notrunc"
    eval "dd if=$OUTPUT.rodata of=$OUTPUT oflag=append conv=notrunc"
    rm -f $OUTPUT.text $OUTPUT.data $OUTPUT.rodata

    rm -f $OUTPUT.func
    eval "objdump -S $OUTPUT.bin | grep \">:\" | grep -v -F \"<.\" | sed -e \"s/\([^ ]*\) *\([^ ]*\)/\2 \1 /g\" | sed \"s/<//\" | sed \"s/>: /\n0x/\" >> $OUTPUT.func"
    echo "end" >> $OUTPUT.func
    ;;
  SHREK)
    if [[ $SHREK_TYPE == "kernel" ]] || [[ $SHREK_TYPE == "KERNEL" ]]
    then
      #BASE_ADDR=0xC0000000
      BASE_ADDR="0x100000" #for debug
    else
      BASE_ADDR="0x1000"
    fi
    TEXT_ADDR=$BASE_ADDR
    DATA_ADDR=`printf "0x%X" $(( $TEXT_ADDR + $TEXT_SIZE ))`
    DATA_ADDR=`printf "0x%X" $(( $DATA_ADDR + ( (4096 - ( $DATA_ADDR % 4096 ) ) % 4096  )  + 4096))`
    BSS_ADDR=`printf "0x%X" $(( $DATA_ADDR + $DATA_SIZE ))`
    BSS_ADDR=`printf "0x%X" $(( $BSS_ADDR + ( (16 - ( $BSS_ADDR % 16 ) ) % 16  ) ))`
    RODATA_ADDR=`printf "0x%X" $(( $BSS_ADDR + $BSS_SIZE ))`
    RODATA_ADDR=`printf "0x%X" $(( $RODATA_ADDR + ( (4096 - ( $RODATA_ADDR % 4096 ) ) % 4096  ) + 4096))`

    echo "$TEXT_ADDR $DATA_ADDR $BSS_ADDR $RODATA_ADDR"
    eval "ld -melf_i386 -oformat $OUTPUT.o -e main -Ttext=$TEXT_ADDR -Tdata=$DATA_ADDR -Tbss=$BSS_ADDR -Trodata=$RODATA_ADDR -o $OUTPUT.bin"
    echo "ld -melf_i386 -oformat $OUTPUT.o -e main -Ttext=$TEXT_ADDR -Tdata=$DATA_ADDR -Tbss=$BSS_ADDR -Trodata=$RODATA_ADDR -o $OUTPUT.bin"
    eval "objcopy -O binary --only-section=.text $OUTPUT.bin $OUTPUT.text"
    eval "objcopy -O binary --only-section=.data $OUTPUT.bin $OUTPUT.data"
    eval "objcopy -O binary --only-section=.rodata $OUTPUT.bin $OUTPUT.rodata"

    rm -f $OUTPUT.func
    eval "objdump -S $OUTPUT.bin | grep \">:\" | grep -v -F \"<.\" | sed -e \"s/\([^ ]*\) *\([^ ]*\)/\2 \1 /g\" | sed \"s/<//\" | sed \"s/>: /\n/\" >> $OUTPUT.func"
    FUNC_COUNT=$(( $(cat $OUTPUT.func | wc -l) / 2 ));

    DATA_SIZE=$(( DATA_SIZE ))
    RODATA_SIZE=$(( RODATA_SIZE ))
    BSS_SIZE=$(( BSS_SIZE ))
    TEXT_SIZE=$(( TEXT_SIZE ))
    eval "./SHREK/formater $FUNC_COUNT $BSS_SIZE $OUTPUT.func $OUTPUT.text $OUTPUT.data $OUTPUT.rodata $OUTPUT $(($BASE_ADDR))"
    rm -f $OUTPUT.func $OUTPUT.text $OUTPUT.data $OUTPUT.rodata $OUTPUT.o $OUTPUT.bin
    ;;
esac
