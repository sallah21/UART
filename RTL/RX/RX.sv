`timescale 1ns / 100ps

module RX (
    input clk,
    input RXD,
    input CLK,
    output RX_READY,
    output [7:0] DQ
);

//////////////////////////////////////////////////////////
///// Local Parameters
//////////////////////////////////////////////////////////
localparam SIZE = 8;
localparam FREQ_DIV_FACT = 9600; // Frequency Division factor

//////////////////////////////////////////////////////////
///// Input filter instance and logic
//////////////////////////////////////////////////////////

wire RXD_OUT_w;

INPUT_FILTER IP_inst (
    .RXD_IN(RXD),
    .RXC(ZD_w),
    .CLK(CLK),
    .RXD_OUT(RXD_OUT_w)
);


//////////////////////////////////////////////////////////
///// Baud generator instance and logic
//////////////////////////////////////////////////////////

wire ZD_w; // May need to assign it into wires
reg [7:0] FDF_reg = FREQ_DIV_FACT; 

BAUD_GENERATOR BG_inst (
    .CE(1),
    .CLK(CLK),
    .SPE(ZD_w),
    .D(FDF_reg),
    .ZD(ZD_w)
);


//////////////////////////////////////////////////////////
///// Shift register instance and logic
//////////////////////////////////////////////////////////

reg [SIZE-1:0] DATA_OUT_reg;

SHIFT_REG #(
    .SIZE(SIZE)
    ) SR_inst (
        .CLK(CLK),
        .DATA_IN(RXD_OUT_w),
        .RXEN(),// TODO: Implement control unit
        .DATA_OUT(DATA_OUT_reg)
    );


always @(posedge clk) begin

end




endmodule