`timescale 1ns / 100ps

module RX_tb;

// Testbench signals
reg clk;
reg RXD;
reg RXC;
wire RX_END;
wire [7:0] DQ;

// Instantiate the RX module
RX uut (
    .clk(clk),
    .RXD(RXD),
    .RXC(RXC),
    .RX_END(RX_END),
    .DQ(DQ)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk; // 100MHz clock
end

// Test stimulus
initial begin
    $dumpfile("RX_tb.vcd");
    $dumpvars(0, RX_tb);
    // Initialize inputs
    RXD = 0;
    RXC = 0;

    // Apply test vectors
    #10 RXD = 1;
    #10 RXC = 1;
    #10 RXD = 0;
    #10 RXC = 0;
    #10 RXD = 1;
    #10 RXC = 1;
    
    // More test vectors to thoroughly test the module
    #10 RXD = 0;
    #10 RXC = 0;
    #10 RXD = 1;
    #10 RXC = 1;
    #10 RXD = 0;
    #10 RXC = 0;
    #10 RXD = 1;
    #10 RXC = 1;
    
    // End the simulation after a few cycles
    #100 $finish;
end

// Monitor
initial begin
    $monitor("Time=%0t | RXD=%b | RXC=%b | RX_END=%b | DQ=%b", $time, RXD, RXC, RX_END, DQ);
end

endmodule
