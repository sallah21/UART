`timescale 1ns / 100ps

module tb_uart();

    // Parameters
    localparam CLK_PERIOD = 10; // 100MHz clock
    localparam FREQ_DIV_FACT = 10;
    localparam SIZE = 8;
    
    // Signals
    reg clk = 0;
    reg [7:0] tx_data = 0;
    reg tx_rq = 0;
    wire tx_busy;
    wire txc;
    wire [7:0] rx_data;
    wire rx_ready;
    wire frame_error;
    wire serial_line;
    
    // Simulation control
    reg simulation_finished = 0;
    
    // Clock generation
    always #(CLK_PERIOD/2) clk = ~clk;

    // Baud rate generator for TX
    BAUD_GENERATOR #(
        .FREQ_DIV_FACT(FREQ_DIV_FACT)
    ) bg_tx (
        .CLK(clk),
        .CE(1'b1),
        .SPE(1'b1),
        .D($clog2(FREQ_DIV_FACT)'(FREQ_DIV_FACT)),
        .ZD(txc)
    );

    // TX instance
    TX #(.SIZE(SIZE)) tx_inst (
        .TXDATA(tx_data),
        .TX_BUSY(tx_busy),
        .TX_RQ(tx_rq),
        .TXC(txc),
        .TXD(serial_line)
    );

    // RX instance
    RX rx_inst (
        .CLK(clk),
        .RXD(serial_line),
        .RX_READY(rx_ready),
        .DQ(rx_data),
        .FRAME_ERROR(frame_error)
    );

    // Test stimulus
    initial begin
        // Dump waveforms
        $dumpfile("uart_sim.vcd");
        $dumpvars(0, tb_uart);
        
        // Initial delay
        #(CLK_PERIOD * 10);
        
        // Test case 1: Send single byte
        $display("Starting Test Case 1 at time %t", $time);
        tx_data = 8'hA5;
        #(CLK_PERIOD * 2);
        tx_rq = 1;
        @(posedge tx_busy);
        tx_rq = 0;
        
        // Wait for transmission to complete
        @(negedge tx_busy);
        
        // Wait for reception
        @(posedge rx_ready);
        if (rx_data === 8'hA5) 
            $display("Test 1 PASSED: Received correct data 0xA5");
        else
            $display("Test 1 FAILED: Expected 0xA5, got 0x%h", rx_data);
            
        // Test case 2: Send another byte
        $display("Starting Test Case 2 at time %t", $time);
        #(CLK_PERIOD * 100);
        tx_data = 8'h3C;
        #(CLK_PERIOD * 2);
        tx_rq = 1;
        @(posedge tx_busy);
        tx_rq = 0;
        
        // Wait for transmission to complete
        @(negedge tx_busy);
        
        // Wait for reception
        @(posedge rx_ready);
        if (rx_data === 8'h3C)
            $display("Test 2 PASSED: Received correct data 0x3C");
        else
            $display("Test 2 FAILED: Expected 0x3C, got 0x%h", rx_data);
            
        // Check for frame errors
        if (frame_error)
            $display("WARNING: Frame error detected!");
            
        // Add some delay before ending simulation
        #(CLK_PERIOD * 1000);
        $display("Simulation completed at time %t", $time);
        simulation_finished = 1;
        $finish;
    end

    // Monitor for frame errors
    always @(posedge frame_error) begin
        $display("Frame error detected at time %t", $time);
    end

    // Timeout watchdog
    initial begin
        #10000000; // 10ms timeout
        if (!simulation_finished) begin
            $display("ERROR: Simulation timeout! Test did not complete.");
            $finish;
        end
    end

endmodule
