`timescale 1ns / 100ps

module DDS #(
    parameter PHASE_WIDTH = 32    // Width of the phase accumulator
)(
    input  logic                    clk,
    input  logic                    rst_n,
    input  logic [PHASE_WIDTH-1:0]  phase_increment,  // Controls output frequency
    output logic                    dds_clk           // Generated clock output
);

    // Phase accumulator
    logic [PHASE_WIDTH-1:0] phase_acc;
    logic dds_clk_reg;

    // Phase accumulator implementation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            phase_acc <= '0;
            dds_clk_reg <= 1'b0;
        end else begin
            phase_acc <= phase_acc + phase_increment;
            // Generate output clock from MSB of phase accumulator
            dds_clk_reg <= phase_acc[PHASE_WIDTH-1];
        end
    end

    // Output assignment
    assign dds_clk = dds_clk_reg;

endmodule
