#!/bin/bash

rm -f TX_tb
rm -f TX_tb.vcd
clear
iverilog -Wall -g2012 -s TX -o TX_tb ./RTL/TX.sv ./RTL/inc.sv ./RTL/MUX.sv

if [ $? -eq 1 ]; then
    echo Source compilation failure
    exit 1
fi

vvp TX_tb

if [ $? -ne 0 ]; then
    echo Running simulation failure
    exit 1
fi

gtkwave TX_tb.vcd


if [$? -ne 0]; then
    echo GTKWave failure
    exit 1
fi

