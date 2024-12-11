`timescale 1ns / 1ps

module CONTROL_UNIT_tb;

  parameter int SIZE = 8;

  // Inputs
  reg CLK;
  reg RXC;
  reg RXD;

  // Outputs
  wire RXRDY;
  wire RXEN;

  // Instantiate the CONTROL_UNIT
  CONTROL_UNIT #(
                 .SIZE(SIZE)
               ) uut (
                 .CLK(CLK),
                 .RXC(RXC),
                 .RXD(RXD),
                 .RXRDY(RXRDY),
                 .RXEN(RXEN)
               );

  // Clock generation
  initial
  begin
    CLK = 0;
    forever
      #5 CLK = ~CLK; // 100MHz clock
  end

  // Clock generation
  initial
  begin
    #2
     RXC = 0;
    forever
      #3 RXC = ~RXC; // 100MHz clock
  end

  // Stimulus
  initial
  begin
    $dumpfile("CONTROL_UNIT_tb.vcd");
    $dumpvars(0, CONTROL_UNIT_tb);
    // Initialize inputs
    RXD = 1;
    // Begin a transmission
    repeat (2) @(posedge RXC);
    RXD = 0;
    @(posedge RXC);
    RXD = 1;
    @(posedge RXC);
    RXD = 0;
    @(posedge RXC);
    RXD = 1;
    @(posedge RXC);
    RXD = 0;
    @(posedge RXC);
    RXD = 1;
    @(posedge RXC);
    RXD = 0;
    @(posedge RXC);
    RXD = 1;
    @(posedge RXC);
    RXD = 0;
    @(posedge RXC);
    RXD <= 1;
    repeat(10) @(posedge RXC);
    RXD = 1;
    @(posedge RXC);
    RXD = 0;
    @(posedge RXC);
    RXD = 1;
    @(posedge RXC);
    RXD = 0;
    @(posedge RXC);
    RXD = 1;
    @(posedge RXC);
    RXD = 0;
    @(posedge RXC);
    RXD = 1;
    @(posedge RXC);
    RXD = 0;
    @(posedge RXC);
    // End simulation
    $finish;
  end

endmodule
