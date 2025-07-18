`timescale 1ns / 1ps

module IF_ID (
    input  wire         cpu_rst,
    input  wire         cpu_clk,
    input  wire [31:0]  if_inst,
    input  wire [31:0]  if_pc,
    input  wire         suspend,
    input  wire         flush,
    input  wire [31:0]  PC4,
    input               valid_in,
    output reg  [31:0]  id_inst,
    output reg  [31:0]  id_pc,
    output reg  [31:0]  id_pc4,
    output reg          valid_out
);

    always @(posedge cpu_clk or posedge cpu_rst) begin
        if (cpu_rst) begin
            id_inst <= 32'h0000_0000;
            id_pc <= 32'h0000_0000;
            id_pc4 <= 32'h0000_0000;
        end else begin
            id_inst <= flush ? 32'h0000_0000 : (suspend ? id_inst : if_inst);
            id_pc <= flush ? 32'h0000_0000 : (suspend ? id_pc : if_pc);
            id_pc4 <= flush ? 32'h0000_0000 : (suspend ? id_pc4 : PC4);
        end
    end

    always @(posedge cpu_clk or posedge cpu_rst) begin
        if (cpu_rst) begin
            valid_out <= 1'b0;
        end else begin
            valid_out <= flush ? 1'b0 : (suspend ? valid_out : valid_in);
        end
    end

endmodule
