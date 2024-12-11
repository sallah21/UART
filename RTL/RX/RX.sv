`timescale 1ns / 100ps

module RX (
    input CLK,
    input RXD,
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
  wire ZD_w; // May need to assign it into wires

  INPUT_FILTER IP_inst (
                 .RXD_IN(RXD),
                 .RXC(ZD_w),
                 .CLK(CLK),
                 .RXD_OUT(RXD_OUT_w)
               );

  //////////////////////////////////////////////////////////
  ///// Baud generator instance and logic
  //////////////////////////////////////////////////////////

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

  wire [SIZE-1:0] DATA_OUT_w;
  wire RXEN_w;
  assign DQ = DATA_OUT_w;
  SHIFT_REG #(
              .SIZE(SIZE)
            ) SR_inst (
              .CLK(CLK),
              .DATA_IN(RXD_OUT_w),
              .RXEN(RXEN_w), // Implemented control unit
              .DATA_OUT(DATA_OUT_w)
            );

  //////////////////////////////////////////////////////////
  ///// Control unit instance and logic
  //////////////////////////////////////////////////////////

  wire RXRDY_w;


  CONTROL_UNIT #(
                 .SIZE(SIZE)
               ) CU_inst (
                 .CLK(CLK),
                 .RXC(ZD_w),
                 .RXD(RXD_OUT_w),
                 .RXRDY(RXRDY_w),
                 .RXEN(RXEN_w)
               );

  assign RX_READY = RXRDY_w;


endmodule
