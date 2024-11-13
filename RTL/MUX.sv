`timescale 1ns/100ps

module MUX #(
    parameter int SIZE = 8
) (
    // if there will be SIZE bits of data there will be 2 additional bits for START and STOP
    input [SIZE+1:0] TX_DATA,
    input [$clog2(SIZE):0] ADDR,
    output D
);
assign D = TX_DATA[ADDR];
endmodule
