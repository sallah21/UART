`timescale 1ns / 100ps
module BAUD_GENERATOR
   #(
      parameter FREQ_DIV_FACT = 9600
   )
   (
     input CE,
     input CLK,
     input SPE,
     input [$clog2(FREQ_DIV_FACT):0] D,
     output ZD
   );

   
  reg [$clog2(FREQ_DIV_FACT):0] counter_r ; 
  reg ZD_r;
  initial begin
     counter_r = D;
  end

  always @(posedge CLK)
  begin
     if (counter_r > 0) begin
        counter_r <= counter_r -1;
        ZD_r <= 1'b0;
     end
     else begin
        counter_r <= counter_r -1;
        ZD_r <= 1'b1;
     end 
  end

  assign ZD = ZD_r;

endmodule
