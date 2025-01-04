`timescale 1ns/100ps

module INPUT_FILTER_tb();

    // Test signals
    reg RXD_IN;
    reg RXC;
    reg CLK;
    wire RXD_OUT;

    // Clock period parameters (in ns)
    localparam CLK_PERIOD_20MHZ = 50;    // 20 MHz
    localparam CLK_PERIOD_50MHZ = 20;    // 50 MHz
    localparam CLK_PERIOD_100MHZ = 10;   // 100 MHz

    // Stabilisation time 
    localparam STABILIZATION_TIME = 5;
    
    // Test patterns
    localparam GLITCH_DURATION = 2;      // Duration of glitch in clock cycles
    localparam TRANSITION_WAIT = 2;      // Wait time between transitions

    // Instance of the module under test
    INPUT_FILTER dut (
        .RXD_IN(RXD_IN),
        .RXC(RXC),
        .CLK(CLK),
        .RXD_OUT(RXD_OUT)
    );

    // Clock generation task
    task automatic gen_clock(input int period);
        forever begin
            CLK = 1'b0;
            #(period/2);
            CLK = 1'b1;
            #(period/2);
        end
    endtask

    // Test stimulus task
    task test_filter(input string test_name, input int clk_period);
        $display("\nStarting %s with clock period %0d ns", test_name, clk_period);
        
        // Test case 1: Stable input
        $display("Test Case 1: Stable Input Test");
        RXD_IN = 1'b1;
        repeat(STABILIZATION_TIME) @(posedge CLK);
        if (RXD_OUT !== 1'b1) begin 
            $error("%s: Failed stable HIGH input test", test_name);
            $display("RXD_IN=%b, RXD_OUT=%b, D_r=%b%b%b, SR_r=%b", 
                    RXD_IN, RXD_OUT, dut.D_r[2], dut.D_r[1], dut.D_r[0], dut.SR_r);
        end

        RXD_IN = 1'b0;
        repeat(STABILIZATION_TIME) @(posedge CLK);
        if (RXD_OUT !== 1'b0) begin
            $error("%s: Failed stable LOW input test", test_name);
            $display("RXD_IN=%b, RXD_OUT=%b, D_r=%b%b%b, SR_r=%b", 
                    RXD_IN, RXD_OUT, dut.D_r[2], dut.D_r[1], dut.D_r[0], dut.SR_r);
        end

        // Test case 2: Single glitch rejection
        $display("Test Case 2: Single Glitch Rejection Test");
        RXD_IN = 1'b1;
        repeat(STABILIZATION_TIME) @(posedge CLK);
        RXD_IN = 1'b0;
        repeat(GLITCH_DURATION) @(posedge CLK);
        RXD_IN = 1'b1;
        repeat(STABILIZATION_TIME) @(posedge CLK);
        if (RXD_OUT !== 1'b1) begin
            $error("%s: Failed single glitch test", test_name);
            $display("RXD_IN=%b, RXD_OUT=%b, D_r=%b%b%b, SR_r=%b", 
                    RXD_IN, RXD_OUT, dut.D_r[2], dut.D_r[1], dut.D_r[0], dut.SR_r);
        end

        // Test case 3: Multiple rapid transitions
        $display("Test Case 3: Multiple Rapid Transitions Test");
        repeat(5) begin
            RXD_IN = ~RXD_IN;
            repeat(TRANSITION_WAIT) @(posedge CLK);
            $display("Rapid transition - RXD_IN=%b, RXD_OUT=%b, D_r=%b%b%b, SR_r=%b", 
                    RXD_IN, RXD_OUT, dut.D_r[2], dut.D_r[1], dut.D_r[0], dut.SR_r);
        end
        repeat(STABILIZATION_TIME) @(posedge CLK);

        // Test case 4: Long pulse rejection
        $display("Test Case 4: Long Pulse Rejection Test");
        RXD_IN = 1'b0;
        repeat(STABILIZATION_TIME) @(posedge CLK);
        RXD_IN = 1'b1;
        repeat(STABILIZATION_TIME-1) @(posedge CLK); // Just under stabilization time
        RXD_IN = 1'b0;
        repeat(STABILIZATION_TIME) @(posedge CLK);
        if (RXD_OUT !== 1'b0) begin
            $error("%s: Failed long pulse rejection test", test_name);
            $display("RXD_IN=%b, RXD_OUT=%b, D_r=%b%b%b, SR_r=%b", 
                    RXD_IN, RXD_OUT, dut.D_r[2], dut.D_r[1], dut.D_r[0], dut.SR_r);
        end

        // Test case 5: Alternating pattern
        $display("Test Case 5: Alternating Pattern Test");
        repeat(4) begin
            RXD_IN = 1'b1;
            repeat(STABILIZATION_TIME) @(posedge CLK);
            RXD_IN = 1'b0;
            repeat(STABILIZATION_TIME) @(posedge CLK);
        end

        // Test case 6: Burst noise rejection
        $display("Test Case 6: Burst Noise Rejection Test");
        RXD_IN = 1'b1;
        repeat(STABILIZATION_TIME) @(posedge CLK);
        repeat(8) begin // Burst of 8 quick toggles
            RXD_IN = ~RXD_IN;
            @(posedge CLK);
        end
        RXD_IN = 1'b1;
        repeat(STABILIZATION_TIME) @(posedge CLK);
        if (RXD_OUT !== 1'b1) begin
            $error("%s: Failed burst noise rejection test", test_name);
            $display("RXD_IN=%b, RXD_OUT=%b, D_r=%b%b%b, SR_r=%b", 
                    RXD_IN, RXD_OUT, dut.D_r[2], dut.D_r[1], dut.D_r[0], dut.SR_r);
        end
        
        $display("%s completed\n", test_name);
    endtask

    // Test execution
    initial begin
        // VCD file setup with all signals
        $dumpfile("INPUT_FILTER_tb.vcd");
        $dumpvars(0, INPUT_FILTER_tb);
        
        // Explicitly dump internal signals
        $dumpvars(0, dut.D_r[0]);
        $dumpvars(0, dut.D_r[1]);
        $dumpvars(0, dut.D_r[2]);
        $dumpvars(0, dut.SR_r);
        $dumpvars(0, dut.SR_S_w);
        $dumpvars(0, dut.SR_R_w);
        
        // Initialize signals
        RXD_IN = 1'b0;
        RXC = 1'b0;
        CLK = 1'b0;

        // Test with different clock frequencies
        fork
            begin
                gen_clock(CLK_PERIOD_20MHZ);
            end
            begin
                #100 test_filter("20MHz Test", CLK_PERIOD_20MHZ);
                #200 test_filter("50MHz Test", CLK_PERIOD_50MHZ);
                #200 test_filter("100MHz Test", CLK_PERIOD_100MHZ);
                #100 $finish;
            end
        join
    end

endmodule