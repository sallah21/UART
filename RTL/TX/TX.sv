`timescale 1ns/100ps
module TX #(
    parameter int SIZE = 8
) (
    input [SIZE-1:0] TXDATA,
    output TX_BUSY,
    input TX_RQ,
    input TXC,
    output TXD
);

////////////////////////////////////////////////////////////////
//////// Bit address selecting section 
////////////////////////////////////////////////////////////////

wire inc_ce =  ~(Q_w[0] & Q_w[3]);
wire inc_r = ~inc_ce & TX_RQ;

wire [$clog2(SIZE):0] Q_w;

INC #(.SIZE(4)) inc_inst (
    .CLK(TXC),
    .CE(inc_ce),
    .R(inc_r),
    .Q(Q_w)
);

////////////////////////////////////////////////////////////////
//////// TX DATA MUX section 
////////////////////////////////////////////////////////////////

wire D_w;

// Assemble frame: Start bit (0), Data (LSB first), Stop bit (1)
wire [SIZE+1:0] tx_frame = {1'b1, TXDATA, 1'b0};

MUX #(.SIZE(8)) MUX_inst (
     .TX_DATA(tx_frame),
     .ADDR(Q_w),
     .D(D_w)
);

////////////////////////////////////////////////////////////////
//////// OUTPUT REG LOGIC 
////////////////////////////////////////////////////////////////

reg TXD_r = 1;
always @(posedge TXC) begin
    TXD_r <= D_w;
end

assign TXD = TXD_r;
assign TX_BUSY = inc_ce;
endmodule