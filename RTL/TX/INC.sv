`timescale 1ns/100ps
module INC #(
    parameter int SIZE = 4,
    parameter int MAX_VAL = 9
) (
   input CLK,
   input CE,
   input R,
   output [SIZE-1:0] Q
);
    
    reg [SIZE-1:0] Q_r = {SIZE {1'b0}};

    always @(posedge CLK or posedge R) begin
        if (R) begin
            Q_r <= {SIZE {1'b0}};
        end
        else begin
            if (CE) begin
                if (Q_r < MAX_VAL) begin
                    Q_r <= Q_r + 1'b1;    
                end
            end
        end
    end
    assign Q = Q_r;
endmodule