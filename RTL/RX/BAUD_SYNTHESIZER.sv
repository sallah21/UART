`timescale 1ns / 100ps
module BAUD_SYNTHESIZER
  (
    input [7:0] ACC_DELTA,
    input CLK,
    output RXC
  );

  reg RXC_r;
  reg [7:0] ADD_r = 8'd0;

  always @(posedge CLK)
  begin
    {RXC_r, ADD_r} = ACC_DELTA + ADD_r;
  end

  assign RXC = RXC_r;

endmodule
