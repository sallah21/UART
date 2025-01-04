#!/bin/bash

# Create simulation directory if it doesn't exist
mkdir -p sim_run

# Clean previous simulation files
rm -rf sim_run/*

# Compile all RTL and testbench files
iverilog -g2012 -Y.sv -y../RTL/TX -y../RTL/RX \
    -o sim_run/uart_sim.vvp \
    ../RTL/TX/TX.sv \
    ../RTL/TX/INC.sv \
    ../RTL/TX/MUX.sv \
    ../RTL/RX/RX.sv \
    ../RTL/RX/BAUD_GENERATOR.sv \
    ../RTL/RX/CONTROL_UNIT.sv \
    ../RTL/RX/DDS.sv \
    ../RTL/RX/INPUT_FILTER.sv \
    ../RTL/RX/MEDIAN_FILTER.sv \
    ../RTL/RX/SHIFT_REG.sv \
    tb_uart.sv

# Check if compilation was successful
if [ $? -eq 0 ]; then
    echo "Compilation successful. Running simulation..."
    # Run simulation
    vvp sim_run/uart_sim.vvp
    
    # Check if VCD file was created
    if [ -f uart_sim.vcd ]; then
        echo "Opening waveform viewer..."
        gtkwave uart_sim.vcd &
    else
        echo "Error: VCD file was not created"
    fi
else
    echo "Compilation failed!"
fi
