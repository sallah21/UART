`timescale 10ns / 100ps

module uart_tx (
    input wire clk,
    input wire reset,
    input wire tx_start,
    input wire [7:0] tx_data,
    output reg tx,
    output reg tx_busy
);
    reg [3:0] bit_cnt;
    reg [9:0] shift_reg;
    reg [3:0] state;

    localparam IDLE = 4'd0,
               START = 4'd1,
               DATA = 4'd2,
               STOP = 4'd3;

    initial begin
        state <= IDLE;
        tx <= 1'b1;
        tx_busy <= 1'b0;
        bit_cnt <= 4'd0;
        shift_reg <= 10'd0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            tx <= 1'b1;
            tx_busy <= 1'b0;
            bit_cnt <= 4'd0;
            shift_reg <= 10'd0;
        end else begin
            case (state)
                IDLE: begin
                    tx <= 1'b1;
                    tx_busy <= 1'b0;
                    if (tx_start) begin
                        shift_reg <= {1'b1, tx_data, 1'b0}; // Stop bit, data, start bit
                        state <= START;
                        tx_busy <= 1'b1;
                    end
                end
                START: begin
                    tx <= shift_reg[0];
                    shift_reg <= shift_reg >> 1;
                    state <= DATA;
                    bit_cnt <= 4'd0;
                end
                DATA: begin
                    tx <= shift_reg[0];
                    shift_reg <= shift_reg >> 1;
                    bit_cnt <= bit_cnt + 1;
                    if (bit_cnt == 4'd7) state <= STOP;
                end
                STOP: begin
                    tx <= 1'b1;
                    state <= IDLE;
                    tx_busy <= 1'b0;
                end
            endcase
        end
    end
endmodule