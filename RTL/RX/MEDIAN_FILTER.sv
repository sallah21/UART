`timescale 1ns / 100ps
module MEDIAN_FILTER 
// TODO: Think about parameterizing number of flops 
(
    input RXD_IN,
    input RXC,
    input CLK,
    input RXEN,
    output RXD_OUT
);

reg D_r [2:0];

always @(posedge RXC) begin
    D_r[0] <= RXD_IN;
    D_r[1] <= D_r[0];
    D_r[2] <= D_r[1];
end

assign RXD_OUT = 
(D_r[0] && D_r[2])
||
(D_r[0] && D_r[1])
||
(D_r[1] && D_r[2]);

endmodule