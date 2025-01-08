`timescale 1ns/100ps

module tb_uart_tx_rx();
    // Parameters
    parameter CLK_PERIOD = 10;    // 10ns period
    parameter MAX_CYCLES = 5000;  // Maximum cycles before timeout
    parameter BITS_PER_FRAME = 10; // Start + 8 data + Stop
    
    // Signals
    reg [7:0] tx_data;
    wire tx_busy;
    reg tx_rq;
    reg clk;
    wire txd;
    reg reset;
    wire [7:0] rx_data;
    wire rx_ready;
    wire rx_error;

    // Test counters
    integer cycle_count = 0;
    reg [7:0] captured_rx_data;
    reg data_received;
    reg [3:0] bit_count;
    reg [9:0] received_frame;

    // Instantiate TX
    TX #(.SIZE(8)) tx_inst (
        .TXDATA(tx_data),
        .TX_BUSY(tx_busy),
        .TX_RQ(tx_rq),
        .TXC(clk),
        .TXD(txd)
    );

    // Instantiate RX
    uart_rx rx_inst (
        .clk(clk),
        .reset(reset),
        .rx(txd),
        .rx_data(rx_data),
        .rx_ready(rx_ready),
        .error(rx_error)
    );

    // Clock generation
    initial begin
        $display("Starting simulation...");
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Monitor TXD bits for debugging
    always @(posedge clk) begin
        if (tx_busy) begin
            $display("Time %t: TXD = %b, Bit %d", $time, txd, bit_count);
            bit_count <= bit_count + 1;
            received_frame <= {received_frame[8:0], txd};
        end else begin
            bit_count <= 0;
        end
    end

    // Cycle counter and timeout
    always @(posedge clk) begin
        cycle_count <= cycle_count + 1;
        if (cycle_count >= MAX_CYCLES) begin
            $display("Simulation timeout after %d cycles", cycle_count);
            $finish;
        end
    end

    // Capture RX data when ready
    always @(posedge clk) begin
        if (rx_ready) begin
            captured_rx_data <= rx_data;
            data_received <= 1;
            $display("Time %t: Data captured: 0x%h", $time, rx_data);
            $display("Complete frame received: %b", received_frame);
        end
    end

    // Test stimulus
    initial begin
        // Initialize
        $display("Initializing signals...");
        tx_data = 0;
        tx_rq = 0;
        reset = 1;
        data_received = 0;
        bit_count = 0;
        received_frame = 0;
        
        // Wait and release reset
        repeat(5) @(posedge clk);
        $display("Time %t: Releasing reset...", $time);
        reset = 0;
        repeat(5) @(posedge clk);

        // Send test data
        $display("Time %t: Starting test transmission of 0xA5 = %b", $time, 8'hA5);
        tx_data = 8'hA5;
        tx_rq = 1;
        @(posedge clk);
        tx_rq = 0;
        
        // Wait for busy signal
        @(posedge tx_busy);
        $display("Time %t: TX started transmitting", $time);

        // Wait for data to be received
        while (!data_received && cycle_count < MAX_CYCLES) begin
            @(posedge clk);
        end
        
        // Check result
        if (data_received) begin
            if (captured_rx_data === 8'hA5) begin
                $display("TEST PASSED: Received correct data 0x%h", captured_rx_data);
                $display("Binary representation: %b", captured_rx_data);
            end else begin
                $display("TEST FAILED: Expected 0xA5 (%b), Received 0x%h (%b)", 
                        8'hA5, captured_rx_data, captured_rx_data);
            end
        end else begin
            $display("TEST FAILED: No data received after %d cycles", cycle_count);
        end

        // End simulation
        $display("Test complete at cycle %d", cycle_count);
        $finish;
    end

    // Monitor TX busy transitions for debugging
    always @(tx_busy)
        $display("Time %t: TX_BUSY changed to %b", $time, tx_busy);
        
    always @(rx_ready)
        $display("Time %t: RX_READY changed to %b", $time, rx_ready);

    // Debug monitors
    always @(posedge clk) begin
        if (tx_busy) begin
            $display("Time %t: TX state - BUSY=%b, TXD=%b", $time, tx_busy, txd);
        end
        if (rx_ready) begin
            $display("Time %t: RX state - READY=%b, DATA=0x%h, ERROR=%b", 
                    $time, rx_ready, rx_data, rx_error);
        end
    end

    // Generate VCD file
    initial begin
        $dumpfile("uart_tx_rx.vcd");
        $dumpvars(0, tb_uart_tx_rx);
    end

endmodule
