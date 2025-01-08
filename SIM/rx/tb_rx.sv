`timescale 1ns / 100ps

module tb_rx();

    // Parameters
    localparam CLK_PERIOD = 10; // 100MHz clock
    localparam FREQ_DIV_FACT = 10;
    localparam SIZE = 8;
    
    // Signals
    reg clk = 0;
    reg rxd = 1;  // Serial input line, default to idle (high)
    wire rx_ready;
    wire [7:0] rx_data;
    wire frame_error;
    
    // Simulation control
    reg simulation_finished = 0;
    
    // Clock generation
    always #(CLK_PERIOD/2) clk = ~clk;

    // RX instance
    uart_rx rx_inst (
        .clk(clk),
        .reset(1'b0),
        .rx(rxd),
        .rx_data(rx_data),
        .rx_ready(rx_ready),
        .error(frame_error)
    );

    // Task to send one byte serially
    task send_byte;
        input [7:0] data;
        integer i;
        begin
            // Start bit
            rxd = 0;
            #(CLK_PERIOD * FREQ_DIV_FACT);
            
            // Data bits (LSB first)
            for (i = 0; i < 8; i = i + 1) begin
                rxd = data[i];
                #(CLK_PERIOD * FREQ_DIV_FACT);
            end
            
            // Stop bit
            rxd = 1;
            #(CLK_PERIOD * FREQ_DIV_FACT);
        end
    endtask

    // Test stimulus
    initial begin
        // Dump waveforms
        $dumpfile("rx_sim.vcd");
        $dumpvars(0, tb_rx);
        
        // Initial delay
        #(CLK_PERIOD * 10);
        
        // Test case 1: Send single byte 0xA5
        $display("Starting Test Case 1 at time %t", $time);
        send_byte(8'hA5);
        
        // Wait for reception
        @(posedge rx_ready);
        if (rx_data === 8'hA5) 
            $display("Test 1 PASSED: Received correct data 0xA5");
        else
            $display("Test 1 FAILED: Expected 0xA5, got 0x%h", rx_data);
            
        // Test case 2: Send byte 0x3C
        $display("\nStarting Test Case 2 at time %t", $time);
        #(CLK_PERIOD * 20);  // Add some delay between transfers
        send_byte(8'h3C);
        
        // Wait for reception
        @(posedge rx_ready);
        if (rx_data === 8'h3C)
            $display("Test 2 PASSED: Received correct data 0x3C");
        else
            $display("Test 2 FAILED: Expected 0x3C, got 0x%h", rx_data);

        // Test case 3: Test frame error (missing stop bit)
        $display("\nStarting Test Case 3 (Frame Error Test) at time %t", $time);
        #(CLK_PERIOD * 20);
        
        // Start bit
        rxd = 0;
        #(CLK_PERIOD * FREQ_DIV_FACT);
        
        // Send 8 data bits
        rxd = 1;  // Send all 1's
        #(CLK_PERIOD * FREQ_DIV_FACT * 8);
        
        // Missing stop bit (keep it low)
        rxd = 0;
        #(CLK_PERIOD * FREQ_DIV_FACT);
        
        // Check frame error
        if (frame_error)
            $display("Test 3 PASSED: Frame error detected");
        else
            $display("Test 3 FAILED: Frame error not detected");
            
        // Return to idle state
        rxd = 1;
        #(CLK_PERIOD * 50);
        
        // End simulation
        $display("\nSimulation completed at time %t", $time);
        $finish;
    end

endmodule
