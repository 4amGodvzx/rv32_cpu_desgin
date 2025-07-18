`timescale 1ns / 1ps

module ID_EX (
    input  wire         cpu_rst,
    input  wire         cpu_clk,
    input  wire [31:0]  id_inst,
    input  wire [31:0]  id_pc,
    input  wire [31:0]  id_pc4,
    input  wire [31:0]  rD1,
    input  wire [31:0]  rD2,
    input  wire [31:0]  ext,
    input  wire [31:0]  B,
    input  wire [2:0]   alu_op,
    input  wire [1:0]   s_rf_wsel,
    input  wire         rf_we,
    input  wire         ram_we,
    input  wire [1:0]   npc_op,
    input  wire         suspend,
    input  wire         flush,
    input  wire         load_use,
    input  wire         valid_in,
    output reg  [31:0]  ex_inst,
    output reg  [31:0]  ex_pc,
    output reg  [31:0]  ex_pc4,
    output reg  [31:0]  ex_rD1,
    output reg  [31:0]  ex_rD2,
    output reg  [31:0]  ex_ext,
    output reg  [31:0]  ex_B,
    output reg  [2:0]   ex_alu_op,
    output reg  [1:0]   ex_s_rf_wsel,
    output reg          ex_rf_we,
    output reg          ex_ram_we,
    output reg  [1:0]   ex_npc_op,
    output reg          valid_out
);

    always @(posedge cpu_clk or posedge cpu_rst) begin
        if (cpu_rst) begin
            ex_inst <= 32'b0;
            ex_pc <= 32'b0;
            ex_pc4 <= 32'b0;
            ex_rD1 <= 32'b0;
            ex_rD2 <= 32'b0;
            ex_ext <= 32'b0;
            ex_B <= 32'b0;
            ex_alu_op <= 3'b0;
            ex_s_rf_wsel <= 2'b0;
            ex_rf_we <= 1'b0;
            ex_npc_op <= 2'b0;
            ex_ram_we <= 1'b0;
        end else if (flush || load_use) begin
            ex_inst <= 32'b0;
            ex_pc <= 32'b0;
            ex_pc4 <= 32'b0;
            ex_rD1 <= 32'b0;
            ex_rD2 <= 32'b0;
            ex_ext <= 32'b0;
            ex_B <= 32'b0;
            ex_alu_op <= 3'b0;
            ex_s_rf_wsel <= 2'b0;
            ex_rf_we <= 1'b0;
            ex_npc_op <= 2'b0;
            ex_ram_we <= 1'b0;
        end else if (suspend) begin
            ex_inst <= ex_inst;
            ex_pc <= ex_pc;
            ex_pc4 <= ex_pc4;
            ex_rD1 <= ex_rD1;
            ex_rD2 <= ex_rD2;
            ex_ext <= ex_ext;
            ex_B <= ex_B;
            ex_alu_op <= ex_alu_op;
            ex_s_rf_wsel <= ex_s_rf_wsel;
            ex_rf_we <= ex_rf_we;
            ex_npc_op <= ex_npc_op;
            ex_ram_we <= ex_ram_we;
        end else begin
            ex_inst <= id_inst;
            ex_pc <= id_pc;
            ex_pc4 <= id_pc4;
            ex_rD1 <= rD1;
            ex_rD2 <= rD2;
            ex_ext <= ext;
            ex_B <= B;
            ex_alu_op <= alu_op;
            ex_s_rf_wsel <= s_rf_wsel;
            ex_rf_we <= rf_we;
            ex_npc_op <= npc_op;
            ex_ram_we <= ram_we;
        end
    end

    always @(posedge cpu_clk or posedge cpu_rst) begin
        if (cpu_rst) begin
            valid_out <= 1'b0;
        end else begin
            valid_out <= flush ? 1'b0 : (suspend ? 1'b0 : valid_in);
        end
    end

endmodule