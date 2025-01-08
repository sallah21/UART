#!/bin/bash

# Create simulation directory if it doesn't exist
mkdir -p sim_out

# Clean up any previous simulation files
rm -f sim_out/uart_sim.vvp uart_tx_rx.vcd

# Compile the design with SystemVerilog support
iverilog -g2012 \
  -Wall \
  -Wno-timescale \
  -DDEBUG=1 \
  -o sim_out/uart_sim.vvp \
  RTL/TX/TX.sv \
  RTL/TX/INC.sv \
  RTL/TX/MUX.sv \
  RTL/RX/Rx.v \
  RTL/RX/CONTROL_UNIT.sv \
  RTL/RX/DDS.sv \
  RTL/RX/INPUT_FILTER.sv \
  RTL/RX/MEDIAN_FILTER.sv \
  RTL/RX/BAUD_GENERATOR.sv \
  RTL/RX/SHIFT_REG.sv \
  SIM/tb_uart_tx_rx.sv \
  RTL/ClockDivider.v

if [ $? -eq 0 ]; then
    echo "Compilation successful, running simulation..."
    vvp sim_out/uart_sim.vvp
    
    if [ $? -ne 0 ]; then
        echo "Simulation failed with error code $?"
        exit 1
    else
        echo "Simulation completed successfully"
    fi
else
    echo "Compilation failed!"
    exit 1
fi

# Open GTKWave if VCD file exists
if [ -f uart_tx_rx.vcd ]; then
    gtkwave RX_test.gtkw &
fi
