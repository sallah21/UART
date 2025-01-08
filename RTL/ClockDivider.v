`timescale 10ns / 100ps

module ClockDivider #(parameter DIVISOR = 250) // Default
(
    input wire clk,         // clk 
    input wire reset,       // Reset signal
    output reg clk_uart     // 9600 baud rate clock output
);
    // Counter to keep track of clock cycles
    integer counter = 0;

    always @(posedge clk_50MHz or posedge reset) begin
        if (reset) begin
            counter <= 0;
            clk_uart <= 0;
        end else begin
            if (counter == (DIVISOR - 1)) begin
                counter <= 0;
                clk_uart <= ~clk_uart;  // Toggle the output clock
            end else begin
                counter <= counter + 1;
            end
        end
    end

    initial begin
        clk_uart <= 1'b0;
    end

endmodule