`timescale 1ns / 1ps

module CONTROL_UNIT #(
    parameter int SIZE = 8
) (
    input CLK,
    input RXC,
    input RXD,
    output RXRDY,
    output RXEN,
    output FRAME_ERROR
);

reg [SIZE:0] data_cnt_reg;
reg            RXEN_reg = 0;
reg            RXD_prev_reg;
reg            ongoing_transmission_reg = 0;
reg            RXRDY_reg = 1'b1;   
reg            FRAME_ERROR_reg = 1'b0;
 // TODO: parity bit handling 

always @(posedge RXC) begin
    RXD_prev_reg <= RXD;    
    if (ongoing_transmission_reg) begin 
        RXEN_reg <= 1'b1;
        data_cnt_reg <= data_cnt_reg + {{(SIZE-1){1'b0}}, 1'b1};
    end
    else begin
        RXEN_reg <= 1'b0;
    end
end

always @(posedge CLK) begin

    if ((RXD_prev_reg & !RXD) && !ongoing_transmission_reg) begin
        ongoing_transmission_reg <=1'b1;
        RXRDY_reg <= 1'b0;
        data_cnt_reg <= {{(SIZE-1){1'b0}}};
    end
    if (data_cnt_reg > SIZE ) begin
        ongoing_transmission_reg <= 1'b0;
        RXRDY_reg <= 1'b1;
        data_cnt_reg <=  {{(SIZE-1){1'b0}}};
        // Check for frame error (stop bit should be 1)
        FRAME_ERROR_reg <= !RXD;
    end

end

assign RXEN = RXEN_reg;
assign RXRDY = RXRDY_reg;    
assign FRAME_ERROR = FRAME_ERROR_reg;
endmodule