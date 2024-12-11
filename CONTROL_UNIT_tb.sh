#!/bin/bash

rm -f TX_tb
rm -f TX_tb.vcd
clear
iverilog -Wall -g2012 -s CONTROL_UNIT_tb -o CONTROL_UNIT_tb ./RTL/RX/CONTROL_UNIT.sv ./VERIF/CONTROL_UNIT_tb.sv


if [ $? -eq 1 ]; then
    echo Source compilation failure
    exit 1
fi

vvp -l CONTROL_UNIT_tb_log.txt CONTROL_UNIT_tb

if [ $? -ne 0 ]; then
    echo Running simulation failure
    exit 1
fi

gtkwave CONTROL_UNIT_tb.gtkw

if [$? -ne 0]; then
    echo GTKWave failure
    exit 1
fi

