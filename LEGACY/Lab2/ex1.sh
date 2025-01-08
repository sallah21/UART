#!/bin/bash

rm -f ex1.vvp
rm -f ex1.vcd

iverilog -Wall -s EX1_tb -o ex1.vvp Rx.v Tx.v Clock.v ex1.v

if [ $? -ne 0 ]; then
    echo Source compilation failure
    exit 1
fi

vvp ex1.vvp

if [ $? -ne 0 ]; then
    echo Running simulation failure
    exit 1
fi

gtkwave ex1.gtkw

if [ $? -ne 0 ]; then
    echo GTKWave failure
    exit 1
fi

