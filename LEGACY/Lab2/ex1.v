//-----------------------------------------------------------------------------
//
// Description : Z80 Test unit
//
//-----------------------------------------------------------------------------

`timescale 10ns / 100ps

module EX1_tb();

reg clk;
wire clk_uart_tx;
wire clk_uart_rx;
reg reset;
reg tx_start;
reg [7:0] tx_data = 8'h66;
wire [7:0] rx_data;
wire rx_ready;
wire tx;
wire tx_busy;
wire error;

uart_tx tx_mod(.clk(clk_uart_tx), .reset(reset), .tx_start(tx_start), .tx_data(tx_data), .tx(tx), .tx_busy(tx_busy));
uart_rx rx_mod(.clk(clk_uart_rx), .reset(reset), .rx(tx), .rx_data(rx_data), .rx_ready(rx_ready), .error(error));
ClockDivider clk_mod_tx(.clk_50MHz(clk), .reset(reset), .clk_uart(clk_uart_tx));
ClockDivider #(.DIVISOR(250)) clk_mod_rx(.clk_50MHz(clk), .reset(reset), .clk_uart(clk_uart_rx));

always @(posedge clk) begin

end

reg [31:0] counter = 0;

task uart_tick();
	begin
		for (counter = 32'd0; counter < 32'd500; counter = counter + 32'd1) begin
			#1 clk = ~clk;
			#1 clk = ~clk;
		end
	end
endtask

initial	begin
	clk = 1'b0;
end

initial begin
	$dumpfile("ex1.vcd");
	$dumpvars(0, EX1_tb);
	$dumpon;
end


initial begin

	reset = 1'b0;
	tx_start = 1'b0;
 
	uart_tick();

	tx_start = 1'b1;

	uart_tick();

	tx_start = 1'b0;
	uart_tick();
	uart_tick();
	uart_tick();
	uart_tick();
	uart_tick();
	uart_tick();
	uart_tick();
	uart_tick();
	uart_tick();
	uart_tick();
	uart_tick();
	uart_tick();
	uart_tick();
	uart_tick();
	uart_tick();

	// reset = 1'b0; 


	// tx_start = 1'b1;

	// #10 clk = ~clk;
	// #10 clk = ~clk;

	// tx_start = 1'b0;
	
	// for (counter = 32'd0; counter < 32'd5300 * 32'd100; counter = counter + 32'd1) begin
	// 	#10 clk = ~clk;
	// 	#10 clk = ~clk;
	// end

	// if (rx_data == tx_data)
	// 	$display("Test passed, data: %h", rx_data);
	// else
	// 	$display("Test failed, rx_data: %h, tx_data: %h", rx_data, tx_data);


end

endmodule

