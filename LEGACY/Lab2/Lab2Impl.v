module Lab2Impl(
	input clk,
	input [7:0] tx_data,
	input tx_start,
	output tx,
	input rx,
	output [7:0] rx_data,
	output rx_ready,
	output error,
	output rx_led,
	output tx_led
);
		
	wire clk_uart_tx;
	wire clk_uart_rx;
	reg reset = 1'b0;
	wire tx_busy;
	
	assign rx_led = rx;
	assign tx_led = tx;
	//assign rx_data = 8'b11111111;
	
	uart_tx tx_mod(.clk(clk_uart_tx), .reset(reset), .tx_start(!tx_start), .tx_data(tx_data), .tx(tx), .tx_busy(tx_busy));
	uart_rx rx_mod(.clk(clk_uart_rx), .reset(reset), .rx(rx), .rx_data(rx_data), .rx_ready(rx_ready), .error(error));
	ClockDivider clk_mod_tx(.clk_50MHz(clk), .reset(reset), .clk_uart(clk_uart_tx));
	ClockDivider clk_mod_rx(.clk_50MHz(clk), .reset(reset), .clk_uart(clk_uart_rx));

	always @(posedge clk) begin
		// Do nothing
	end

endmodule