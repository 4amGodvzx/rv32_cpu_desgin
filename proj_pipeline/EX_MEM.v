`timescale 1ns / 1ps

module EX_MEM (
    input  wire         cpu_rst,
    input  wire         cpu_clk,
    
    input  wire [31:0]  ex_pc4,
    input  wire [31:0]  ex_inst,
    input  wire [31:0]  ex_rD2,
    input  wire [31:0]  ex_ext,
    input  wire [1:0]   ex_s_rf_wsel,
    input  wire         ex_rf_we,
    input  wire         ex_ram_we,
    input  wire [31:0]  C,
    input  wire         valid_in,

    output reg  [31:0]  mem_pc4,
    output reg  [31:0]  mem_inst,
    output reg  [31:0]  mem_rD2,
    output reg  [31:0]  mem_ext,
    output reg  [1:0]   mem_s_rf_wsel,
    output reg          mem_rf_we,
    output reg          mem_ram_we,
    output reg  [31:0]  mem_C,
    output reg          valid_out
);

    always @(posedge cpu_clk or posedge cpu_rst) begin
        if (cpu_rst) begin
            mem_pc4 <= 32'b0;
            mem_inst <= 32'b0;
            mem_rD2 <= 32'b0;
            mem_ext <= 32'b0;
            mem_s_rf_wsel <= 2'b0;
            mem_rf_we <= 1'b0;
            mem_ram_we <= 1'b0;
            mem_C <= 32'b0;
        end else begin
            mem_pc4 <= ex_pc4;
            mem_inst <= ex_inst;
            mem_rD2 <= ex_rD2;
            mem_ext <= ex_ext;
            mem_s_rf_wsel <= ex_s_rf_wsel;
            mem_rf_we <= ex_rf_we;
            mem_ram_we <= ex_ram_we;
            mem_C <= C;
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
