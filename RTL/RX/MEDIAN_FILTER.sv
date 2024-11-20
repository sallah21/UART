`timescale 1ns / 100ps
module MEDIAN_FILTER 
// TODO: Think about parameterizing number of flops 
(
    input RXD_RAW,
    input SAMP,
    input CLK,
    output RXD
);

reg D_r [2:0];

always @(posedge CLK) begin
    D_r[0] <= RXD_RAW;
    D_r[1] <= D_r[0];
    D_r[2] <= D_r[1];
end

assign RXD = 
(D_r[0] && D_r[2])
||
(D_r[0] && D_r[1])
||
(D_r[1] && D_r[2]);

endmodule