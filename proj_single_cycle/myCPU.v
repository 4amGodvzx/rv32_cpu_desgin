`timescale 1ns / 1ps

`include "defines.vh"

module myCPU (
    input  wire         cpu_rst,
    input  wire         cpu_clk,

    // Interface to IROM
`ifdef RUN_TRACE
    output wire [15:0]  inst_addr,
`else
    output wire [13:0]  inst_addr,
`endif
    input  wire [31:0]  inst,
    
    // Interface to Bridge
    output wire [31:0]  Bus_addr,
    input  wire [31:0]  Bus_rdata,
    output wire         Bus_we,
    output wire [31:0]  Bus_wdata

`ifdef RUN_TRACE
    ,// Debug Interface
    output wire         debug_wb_have_inst,
    output wire [31:0]  debug_wb_pc,
    output              debug_wb_ena,
    output wire [ 4:0]  debug_wb_reg,
    output wire [31:0]  debug_wb_value
`endif
);

    // TODO: 完成你自己的单周期CPU设计

    wire [31:0] pc;
    wire [31:0] npc;
    wire [1:0] f;
    wire [1:0] npc_op;
    wire [1:0] s_npc_offset;
    wire [2:0] s_rf_wsel;
    wire rf_we;
    wire [2:0] ext_op;
    wire [3:0] alu_op;
    wire s_alub_sel;
    wire [31:0] rD1, rD2;
    wire [31:0] wD;
    wire [31:0] C;
    wire [31:0] B;
    wire [31:0] PC4;
    wire [31:0] offset;
    wire [31:0] ext;

    assign inst_addr = pc[15:2];    // PC是字节地址
    assign Bus_addr = C;            // 访问数据存储器时，地址由ALU计算得到
    assign Bus_wdata = rD2;         // 写数据存储器时，数据由寄存器rD2提供

    Ctrl U_Ctrl (
        .opcode(inst[6:0]),
        .funct7(inst[31:25]),
        .funct3(inst[14:12]),
        .s_npc_offset(s_npc_offset),
        .npc_op(npc_op),
        .s_rf_wsel(s_rf_wsel),
        .rf_we(rf_we),
        .ext_op(ext_op),
        .alu_op(alu_op),
        .s_alub_sel(s_alub_sel),
        .ram_we(Bus_we)
    );

    npc_offset U_npc_offset (
        .s_npc_offset(s_npc_offset),
        .ext(ext),
        .C(C),
        .pc(pc),
        .offset(offset)
    );
    
    PC U_PC (
        .cpu_rst(cpu_rst),
        .cpu_clk(cpu_clk),
        .din(npc),
        .pc(pc)
    );

    wire beq_or_not = (inst[14:12] == 3'b000) ? 1'b1 : 1'b0;
    wire bne_or_not = (inst[14:12] == 3'b001) ? 1'b1 : 1'b0;
    wire blt_or_not = (inst[14:12] == 3'b100) ? 1'b1 : 1'b0;

    NPC U_NPC (
        .pc(pc),
        .offset(offset),
        .br((beq_or_not == 1 && f == 2'b00) || (bne_or_not == 1 && (f == 2'b01 || f == 2'b10)) || (blt_or_not == 1 && f == 2'b01)),
        .npc_op(npc_op),
        .npc(npc),
        .PC4(PC4)
    );

    rf_wsel U_rf_wsel (
        .ext(ext),
        .C(C),
        .PC4(PC4),
        .s_rf_wsel(s_rf_wsel),
        .rdo(Bus_rdata),
        .wD(wD)
    );

    RF U_RF (
        .cpu_clk(cpu_clk),
        .cpu_rst(cpu_rst),
        .rR1(inst[19:15]),
        .rD1(rD1),
        .rR2(inst[24:20]),
        .rD2(rD2),
        .we(rf_we),
        .wR(inst[11:7]),
        .wD(wD)
    );

    SEXT U_SEXT (
        .inst(inst),
        .ext_op(ext_op),
        .ext(ext)
    );

    alub_sel U_alub_sel (
        .ext(ext),
        .rD2(rD2),
        .s_alub_sel(s_alub_sel),
        .B(B)
    );

    ALU U_ALU (
        .op(alu_op),
        .A(rD1),
        .B(B),
        .C(C),
        .f(f)
    );

`ifdef RUN_TRACE
    // Debug Interface
    assign debug_wb_have_inst = ~cpu_rst; // 对于单周期CPU，复位后恒置1
    assign debug_wb_pc        = pc;    // 当前写回的指令的PC
    assign debug_wb_ena       = rf_we; // 指令写回时，寄存器堆的写使能
    assign debug_wb_reg       = inst[11:7]; // 指令写回时，写入的寄存器号
    assign debug_wb_value     = wD;    // 指令写回时，写入寄存器的值
`endif

endmodule
