`timescale 1ns / 1ps

module PC(
    input  wire        cpu_rst,
    input  wire        cpu_clk,
    input  wire        suspend,
    input  wire        flush,
    input  wire [31:0] flush_pc,
    output reg  [31:0] pc,
    output reg  [31:0] PC4,
    output reg         valid // debug signal to indicate if PC is valid
);

    always @(posedge cpu_clk or posedge cpu_rst) begin
        if (cpu_rst) begin
            pc <= 32'h0000_0000; // Reset时PC初始化为0xFFFFFFFC
        end else begin
            pc <= flush ? flush_pc : (suspend ? pc : pc + 32'h0000_0004);
        end
    end

    always @(*) begin
        PC4 = pc + 32'h0000_0004; // PC+4
        valid = 1;
    end

endmodule
