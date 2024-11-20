`timescale 1ns / 100ps
module BAUD_GENERATOR
/* NOTE: This module look like cosmic fuckery compared to web implementation
  so if there is problem with RX its there 
*/ 
   (
     input CE,
     input CLK,
     input SPE,
     input [7:0] D,
     output ZD
   );

   
  reg [7:0] counter_r ; 
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
        ZD_r <= 1'b1;
     end 
  end

  assign ZD = ZD_r;

endmodule
