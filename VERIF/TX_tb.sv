`timescale 1ns / 100ps
module TX_tb;

  parameter int SIZE = 8;

  reg [SIZE-1:0] TXDATA;
  reg TX_RQ;
  reg TXC;
  wire TX_BUSY;
  wire TXD;

  TX #(
      .SIZE(SIZE)
  ) uut (
      .TXDATA(TXDATA),
      .TX_BUSY(TX_BUSY),
      .TX_RQ(TX_RQ),
      .TXC(TXC),
      .TXD(TXD)
  );

  initial begin
    $dumpfile("TX_tb.vcd");
    $dumpvars(0, TX_tb);

    // Initialize inputs
    TXDATA = 0;
    TX_RQ = 0;
    TXC = 0;
    @(negedge TX_BUSY);
    // Apply test vectors
    #10 TXDATA = 8'b10101010; TX_RQ = 1;
    #20 TX_RQ = 0;
    @(negedge TX_BUSY);
    #30 TXDATA = 8'b11001100; TX_RQ = 1;
    #40 TX_RQ = 0;
    #1000;
    // Add more test cases as needed
    #50 $finish;
  end

  always #5 TXC = ~TXC; // Clock generation

endmodule
