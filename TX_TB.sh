#!/bin/bash

rm -f TX_tb
rm -f TX_tb.vcd
clear
iverilog -Wall -g2012 -s TX_tb -o TX_tb ./RTL/TX/TX.sv ./RTL/TX/INC.sv ./RTL/TX/MUX.sv ./VERIF/TX_tb.sv


if [ $? -eq 1 ]; then
    echo Source compilation failure
    exit 1
fi

vvp -l log.txt TX_tb

if [ $? -ne 0 ]; then
    echo Running simulation failure
    exit 1
fi

gtkwave TX_tb.gtkw

if [$? -ne 0]; then
    echo GTKWave failure
    exit 1
fi

