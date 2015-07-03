#!/bin/bash

source env.sh

rm -f demo_test16.cfg demo_driver16.o demo_test16.o demo_test16_mine.o demo_driver16.exe

${CC} -ggdb -m64 -c -o demo_test16.o demo_test16.c

if [ -e "${IDA_PATH}/idaq" ]
then
    echo "Using IDA to recover CFG"
    ${BIN_DESCEND_PATH}/bin_descend_wrapper.py -march=x86-64 -entry-symbol=shiftit -i=demo_test16.o >> /dev/null
else
    echo "Using bin_descend to recover CFG"
    ${BIN_DESCEND_PATH}/bin_descend -march=x86-64 -d -entry-symbol=shiftit -i=demo_test16.o
fi

${CFG_TO_BC_PATH}/cfg_to_bc -march=x86-64 -i demo_test16.cfg -driver=shiftit,shiftit,2,return,C -o demo_test16.bc

${LLVM_PATH}/opt -O3 -o demo_test16_opt.bc demo_test16.bc
${LLVM_PATH}/llc -march=x86-64 -filetype=obj -o demo_test16_mine.o demo_test16_opt.bc
${CC} -ggdb -m64 -o demo_driver16.exe demo_driver16.c demo_test16_mine.o
./demo_driver16.exe
