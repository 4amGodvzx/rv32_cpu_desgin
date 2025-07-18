`timescale 1ns / 1ps

module MEM_WB(
    input  wire         cpu_rst,
    input  wire         cpu_clk,

    input  wire [31:0]  mem_pc4,
    input  wire [31:0]  mem_inst,
    input  wire [31:0]  mem_ext,
    input  wire [1:0]   mem_s_rf_wsel,
    input  wire         mem_rf_we,
    input  wire [31:0]  mem_C,
    input  wire [31:0]  rdo,
    input  wire         valid_in,

    output reg  [31:0]  wb_pc4,
    output reg  [31:0]  wb_inst,
    output reg  [31:0]  wb_ext,
    output reg  [1:0]   wb_s_rf_wsel,
    output reg          wb_rf_we,
    output reg  [31:0]  wb_C,
    output reg  [31:0]  wb_rdo,
    output reg          valid_out
);

    always @(posedge cpu_clk or posedge cpu_rst) begin
        if (cpu_rst) begin
            wb_pc4 <= 32'b0;
            wb_inst <= 32'b0;
            wb_ext <= 32'b0;
            wb_s_rf_wsel <= 2'b0;
            wb_rf_we <= 1'b0;
            wb_C <= 32'b0;
            wb_rdo <= 32'b0;
        end else begin
            wb_pc4 <= mem_pc4;
            wb_inst <= mem_inst;
            wb_ext <= mem_ext;
            wb_s_rf_wsel <= mem_s_rf_wsel;
            wb_rf_we <= mem_rf_we;
            wb_C <= mem_C;
            wb_rdo <= rdo;
        end
    end

    always @(posedge cpu_clk or posedge cpu_rst) begin
        if (cpu_rst) begin
            valid_out <= 1'b0;
        end else begin
            valid_out <= valid_in;
        end
    end

endmodule
