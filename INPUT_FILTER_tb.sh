#!/bin/bash

# Change to the project root directory
cd "$(dirname "$0")"

# Clean up previous simulation files
rm -f INPUT_FILTER_tb
rm -f INPUT_FILTER_tb.vcd
clear

# Compile the design
echo "Compiling design..."
iverilog -Wall -g2012 -s INPUT_FILTER_tb -o INPUT_FILTER_tb \
    -y ./RTL/RX \
    ./VERIF/INPUT_FILTER_tb.sv \
    ./RTL/RX/INPUT_FILTER.sv

if [ $? -ne 0 ]; then
    echo "Source compilation failure"
    exit 1
fi

# Run the simulation
echo "Running simulation..."
vvp -l INPUT_FILTER_tb_log.txt INPUT_FILTER_tb

if [ $? -ne 0 ]; then
    echo "Running simulation failure"
    exit 1
fi

# Open waveform viewer
if [ -f INPUT_FILTER_tb.gtkw ]; then
    echo "Opening GTKWave with saved configuration..."
    gtkwave INPUT_FILTER_tb.gtkw
else
    echo "No saved GTKWave configuration found. Opening VCD file directly..."
    gtkwave INPUT_FILTER_tb.vcd
fi

if [ $? -ne 0 ]; then
    echo "GTKWave failure"
    exit 1
fi
