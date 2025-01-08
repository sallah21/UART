`timescale 1ns / 100ps
module INPUT_FILTER 
(
    input RXD_IN,
    input RXC,
    input CLK,
    input RXEN,
    output RXD_OUT
);
// XXX: this returns wrong data
reg D_r [2:0];

reg SR_r;

reg d1;
reg d2;
reg d3;

wire SR_S_w = D_r[0] && D_r[1] && D_r[2];
wire SR_R_w = !(D_r[0] || D_r[1] || D_r[2]);

always @(posedge RXC) begin
    D_r[0] <= RXD_IN;
    D_r[1] <= D_r[0];
    D_r[2] <= D_r[1];
    if (!SR_R_w ) begin
        SR_r <= SR_S_w;
    end
    else begin
        SR_r <= 'x;
    end
end
assign RXD_OUT = SR_r;

assign d1 = D_r[0];
assign d2 = D_r[1];
assign d3 = D_r[2];

endmodule
