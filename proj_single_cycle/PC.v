`timescale 1ns / 1ps

module PC(
    input  wire        cpu_rst,
    input  wire        cpu_clk,
    input  wire [31:0] din,
    output reg  [31:0] pc
);

    always @(posedge cpu_clk or posedge cpu_rst) begin
        if (cpu_rst) begin
            pc <= 32'h0000_0000 - 32'h0000_0004; // Reset时将PC设置为0xFFFFFFFC
        end else begin
            pc <= din;
        end
    end

endmodule
