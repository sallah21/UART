module CONTROL_UNIT #(
    parameter int SIZE = 8
) (
    input CLK,
    input RXC,
    input RXD,
    output RXRDY,
    output RXEN
);

reg [SIZE-1:0] data_cnt_reg = 0;
reg            RXEN_reg = 0;


always @(posedge CLK) begin
    if () begin // TODO: Implement logic for this 
        RXEN_reg <= 1'b1;
    end
    else begin
        RXEN_reg <= 1'b0;
    end
end
    
endmodule