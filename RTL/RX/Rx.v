`timescale 1ns / 100ps

module uart_rx (
    input CLK,
    input RXD,
    input RXC,
    input TX_BUSY,
    output RX_READY,
    output [7:0] DQ,
    output FRAME_ERROR
  );

  //////////////////////////////////////////////////////////
  ///// Local Parameters
  //////////////////////////////////////////////////////////
  localparam SIZE = 8;
  localparam FREQ_DIV_FACT = 0; // Frequency Division factor

  //////////////////////////////////////////////////////////
  ///// Input filter instance and logic
  //////////////////////////////////////////////////////////

  wire RXD_OUT_w;
  wire ZD_w; // May need to assign it into wires
  wire RX_EN_IF = RXEN_w;

  // INPUT_FILTER IP_inst (
  //                .RXD_IN(RXD),
  //                .RXC(RXC),
  //                .RXEN(RX_EN_IF),
  //                .CLK(CLK),
  //                .RXD_OUT(RXD_OUT_w)
  //              );

  MEDIAN_FILTER IP_inst (
    .RXD_IN(RXD),
    .RXC(RXC),
    .RXEN(RX_EN_IF),
    .CLK(CLK),
    .RXD_OUT(RXD_OUT_w)
  );

  //////////////////////////////////////////////////////////
  ///// Baud generator instance and logic
  //////////////////////////////////////////////////////////

  reg [$clog2(FREQ_DIV_FACT):0] FDF_reg = FREQ_DIV_FACT;
  BAUD_GENERATOR #(
                   .FREQ_DIV_FACT(FREQ_DIV_FACT)
                 ) BG_inst(
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
              .RXEN(RXEN_w), 
              .DATA_OUT(DATA_OUT_w)
            );

  //////////////////////////////////////////////////////////
  ///// Control unit instance and logic
  //////////////////////////////////////////////////////////

  wire RXRDY_w;
  wire FRAME_ERROR_w;

  CONTROL_UNIT #(
                 .SIZE(SIZE)
               ) CU_inst (
                 .CLK(CLK),
                 .RXC(ZD_w),
                 .TX_BUSY(TX_BUSY),
                 .RXD(RXD_OUT_w),
                 .RXRDY(RXRDY_w),
                 .RXEN(RXEN_w),
                 .FRAME_ERROR(FRAME_ERROR_w)
               );

  assign RX_READY = RXRDY_w;
  assign FRAME_ERROR = FRAME_ERROR_w;
endmodule
