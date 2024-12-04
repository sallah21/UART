`timescale 1ns / 100ps

module SHIFT_REG #(
    parameter int SIZE = 8
)(
    input CLK,
    input DATA_IN,
    input RXEN,
    output [SIZE-1:0] DATA_OUT
);

reg [SIZE-1:0] DATA_OUT_r;
assign DATA_OUT = DATA_OUT_r;

genvar i;
generate
    for (i = SIZE-1; i > 0; i = i - 1) begin : shift_logic
        always @(posedge CLK) begin
            if (RXEN) begin
                DATA_OUT_r[i] <= DATA_OUT_r[i-1];    
            end
        end
    end
endgenerate

always @(posedge CLK) begin
    if (RXEN) begin
        DATA_OUT_r[0] <= DATA_IN;    
    end
end

endmodule
