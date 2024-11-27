#!/bin/bash

rm -f TX_tb
rm -f TX_tb.vcd
clear
iverilog -Wall -g2012 -s RX_tb -o RX_tb ./RTL/RX/RX.sv ./VERIF/RX_tb.sv


if [ $? -eq 1 ]; then
    echo Source compilation failure
    exit 1
fi

vvp -l log.txt RX_tb

if [ $? -ne 0 ]; then
    echo Running simulation failure
    exit 1
fi

gtkwave RX_tb.gtkw
if [$? -ne 0]; then
    echo GTKWave failure
    exit 1
fi

