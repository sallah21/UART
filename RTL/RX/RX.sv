`timescale 1ns / 100ps

module RX (
    input clk,
    input RXD,
    input RXC,
    output RX_END,
    output [7:0] DQ
);

logic [7:0] shift_reg = 8'dz;

logic RX_END;
logic sum_mux_up;
logic sum_mux_down;
logic RX_SAMPLE;
reg sum_r;

always @(posedge clk) begin
    sum_r = sum_mux_up + sum_mux_down;
    
    RX_END = (sum_r == 8'd152)? 1'b1 : 1'b0 ;

    sum_mux_up = (RX_END && (!RXD))? 'd0 : sum_r;

    sum_mux_down = (RXC && (!RX_END))? 'd1 : 'd0;

    RX_SAMPLE = 
    ((sum_r=='d7)? 1'b1: 1'b0 ) &&
    (!((sum_r=='d148)? 1'b1: 1'b0 )) &&
    (RXC) ;
end


always @(posedge RX_SAMPLE) begin
    shift_reg[0] <= RXD;
    shift_reg[1] <= shift_reg[0];
    shift_reg[2] <= shift_reg[1];
    shift_reg[3] <= shift_reg[2];
    shift_reg[4] <= shift_reg[3];
    shift_reg[5] <= shift_reg[4];
    shift_reg[6] <= shift_reg[5];
    shift_reg[7] <= shift_reg[6];

end

endmodule