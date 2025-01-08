`timescale 1ns/100ps

module uart_rx (
    input wire clk,
    input wire reset,
    input wire rx,
    input wire tx_busy,
    output reg [7:0] rx_data,
    output reg rx_ready,
    output reg error
);
    reg [3:0] bit_cnt;
    reg [7:0] shift_reg;
    reg [3:0] state;

    localparam IDLE = 4'd0,
               START = 4'd1,
               DATA = 4'd2,
               STOP = 4'd3;

    initial begin
        state <= IDLE;
        rx_ready <= 1'b0;
        bit_cnt <= 4'd0;
        shift_reg <= 8'd0;
        error <= 1'b0;
        rx_data <= 8'd0;
    end

    always @(posedge clk or posedge reset) begin
        if (!reset) begin
            state <= IDLE;
            rx_ready <= 1'b0;
            bit_cnt <= 4'd0;
            shift_reg <= 8'd0;
            error <= 1'b0;
            rx_data <= 8'd0;
        end else begin
            case (state)
                IDLE: begin
                    rx_ready <= 1'b1;
                    if (~rx && tx_busy) state <= START; // Start bit detected
                end
                START: begin
                    state <= DATA;
                    bit_cnt <= 4'd0;
                    shift_reg <= {rx, shift_reg[7:1]};
                    rx_ready <= 1'b0;
                end
                DATA: begin
                    // Shift in LSB first
                    shift_reg <= {rx, shift_reg[7:1]};
                    bit_cnt <= bit_cnt + 1;
                    if (bit_cnt == 4'd6) state <= STOP;
                end
                STOP: begin
                    if (rx) begin
                        error <= 1'b0; // Stop bit detected
                        rx_data <= shift_reg; // Data is already in correct order
                        rx_ready <= 1'b1;
                    end
                    else begin 
                        error <= 1'b1; // Error: Stop bit not detected
                    end
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule
