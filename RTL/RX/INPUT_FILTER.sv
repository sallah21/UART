`timescale 1ns / 100ps
module INPUT_FILTER 
(
    input RXD_IN,
    input RXC,
    input CLK,
    output RXD_OUT
);

reg D_r [2:0];

reg SR_r;

wire SR_S_w = D_r[0] && D_r[1] && D_r[2];
wire SR_R_w = !(D_r[0] || D_r[1] || D_r[2]);

always @(posedge CLK) begin
    D_r[0] <= RXD_IN;
    D_r[1] <= D_r[0];
    D_r[2] <= D_r[1];
    if (!SR_R_w) begin
        SR_r <= SR_S_w;
    end
end
assign RXD_OUT = SR_r;

endmodule
