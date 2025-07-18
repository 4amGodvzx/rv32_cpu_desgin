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

    // TODO: 完成你自己的流水线CPU设计

    wire [31:0] id_inst;
    wire [ 1:0] npc_op; 
    wire [ 1:0] s_rf_wsel;   
//    wire [0:0] s_npc_offset; 
    wire        rf_we;
    wire [ 2:0] ext_op;
    wire [ 2:0] alu_op;
    wire        s_alub_sel;
    wire        ram_we;

    wire        suspend;
    wire        flush;

    wire [31:0] pc;
    wire [31:0] PC4;
    wire [31:0] flush_pc;

    wire [31:0] id_pc;
    wire [31:0] id_pc4;
    
    wire [31:0] rD1, rD2;
    wire [31:0] wD;
    wire        wb_rf_we;
    wire [31:0] wb_inst;

    wire [31:0] ext;

    wire [31:0] B;

    wire [31:0] ex_inst;
    wire [31:0] ex_pc;
    wire [31:0] ex_pc4;
    wire [31:0] ex_rD1;
    wire [31:0] ex_rD2;
    wire [31:0] ex_ext;
    wire [31:0] ex_B;
    wire [ 2:0] ex_alu_op;
    wire [ 1:0] ex_s_rf_wsel;
    wire        ex_rf_we;
    wire        ex_ram_we;
    wire [ 1:0] ex_npc_op;
    
    wire [31:0] C;
    wire [ 1:0] f;

    wire [31:0] mem_pc4;
    wire [31:0] mem_inst;
    wire [31:0] mem_rD2;
    wire [31:0] mem_ext;
    wire [ 1:0] mem_s_rf_wsel;
    wire        mem_rf_we;
    wire        mem_ram_we;
    wire [31:0] mem_C;

    wire [31:0] wb_pc4;
    wire [31:0] wb_ext;
    wire [ 1:0] wb_s_rf_wsel;
    wire [31:0] wb_C;
    wire [31:0] wb_rdo;

    wire [31:0] actual_rD1;
    wire [31:0] actual_rD2;
    wire        load_use;

    wire        valid; // debug signal to indicate if PC is valid
    wire        valid_out_if_id;
    wire        valid_out_id_ex;
    wire        valid_out_ex_mem;
    wire        valid_out_mem_wb;

    assign inst_addr = pc[15:2];    // PC是字节地址
    assign Bus_addr = mem_C;            // 访问数据存储器时，地址由ALU计算得到
    assign Bus_wdata = mem_rD2;         // 写数据存储器时，数据由寄存器rD2提供
    assign Bus_we = mem_ram_we;         // 写数据存储器时，写使能由EX/MEM寄存器提供

    Ctrl U_Ctrl (
        .opcode(id_inst[6:0]),
        .funct7(id_inst[31:25]),
        .funct3(id_inst[14:12]),
//        .s_npc_offset(s_npc_offset),
        .npc_op(npc_op),
        .s_rf_wsel(s_rf_wsel),
        .rf_we(rf_we),
        .ext_op(ext_op),
        .alu_op(alu_op),
        .s_alub_sel(s_alub_sel),
        .ram_we(ram_we)
    );

//    npc_offset U_npc_offset (
//        .s_npc_offset(s_npc_offset),
//        .ext(ext),
//        .C(C),
//        .pc(id_pc),
//        .offset(offset)
//    );
    
    PC U_PC (
        .cpu_rst(cpu_rst),
        .cpu_clk(cpu_clk),
        .suspend(suspend),
        .flush(flush),
        .flush_pc(flush_pc),
        .pc(pc),
        .PC4(PC4),
        .valid(valid) // debug signal to indicate if PC is valid
    );

    IF_ID U_IF_ID (
        .cpu_rst(cpu_rst),
        .cpu_clk(cpu_clk),
        .if_inst(inst),
        .if_pc(pc),
        .suspend(suspend),
        .flush(flush),
        .PC4(PC4),
        .valid_in(valid),
        .id_inst(id_inst),
        .id_pc(id_pc),
        .id_pc4(id_pc4),
        .valid_out(valid_out_if_id)
    );

//    NPC U_NPC (
//        .pc(pc),
//        .offset(offset),
//        .br((beq_or_not == 1 && f == 2'b00) || (bne_or_not == 1 && (f == 2'b01 || f == 2'b10)) || (blt_or_not == 1 && f == 2'b01)),
//        .npc_op(npc_op),
//        .npc(npc)
//    );

    RF U_RF (
        .cpu_clk(cpu_clk),
        .cpu_rst(cpu_rst),
        .rR1(id_inst[19:15]),
        .rD1(rD1),
        .rR2(id_inst[24:20]),
        .rD2(rD2),
        .we(wb_rf_we),
        .wR(wb_inst[11:7]),
        .wD(wD)
    );

    SEXT U_SEXT (
        .inst(id_inst),
        .ext_op(ext_op),
        .ext(ext)
    );

    alub_sel U_alub_sel (
        .ext(ext),
        .rD2(actual_rD2),
        .s_alub_sel(s_alub_sel),
        .B(B)
    );

    ID_EX U_ID_EX (
        .cpu_rst(cpu_rst),
        .cpu_clk(cpu_clk),
        .id_inst(id_inst),
        .id_pc(id_pc),
        .id_pc4(id_pc4),
        .rD1(actual_rD1),
        .rD2(actual_rD2),
        .ext(ext),
        .B(B),
        .alu_op(alu_op),
        .s_rf_wsel(s_rf_wsel),
        .rf_we(rf_we),
        .ram_we(ram_we),
        .npc_op(npc_op),
        .suspend(suspend),
        .flush(flush),
        .load_use(load_use),
        .valid_in(valid_out_if_id),
        .ex_inst(ex_inst),
        .ex_pc(ex_pc),
        .ex_pc4(ex_pc4),
        .ex_rD1(ex_rD1),
        .ex_rD2(ex_rD2),
        .ex_ext(ex_ext),
        .ex_B(ex_B),
        .ex_alu_op(ex_alu_op),
        .ex_s_rf_wsel(ex_s_rf_wsel),
        .ex_rf_we(ex_rf_we),
        .ex_ram_we(ex_ram_we),
        .ex_npc_op(ex_npc_op),
        .valid_out(valid_out_id_ex)
    );

    ALU U_ALU (
        .op(ex_alu_op),
        .A(ex_rD1),
        .B(ex_B),
        .C(C),
        .f(f)
    );

    BPU U_BPU (
        .ex_inst(ex_inst),
        .ex_pc(ex_pc),
        .ex_ext(ex_ext),
        .ex_rD1(ex_rD1),
        .f(f),
        .ex_npc_op(ex_npc_op),
        .flush(flush),
        .flush_pc(flush_pc)
    );

    EX_MEM U_EX_MEM (
        .cpu_rst(cpu_rst),
        .cpu_clk(cpu_clk),
        .ex_pc4(ex_pc4),
        .ex_inst(ex_inst),
        .ex_rD2(ex_rD2),
        .ex_ext(ex_ext),
        .ex_s_rf_wsel(ex_s_rf_wsel),
        .ex_rf_we(ex_rf_we),
        .ex_ram_we(ex_ram_we),
        .C(C),
        .valid_in(valid_out_id_ex),
        .mem_pc4(mem_pc4),
        .mem_inst(mem_inst),
        .mem_rD2(mem_rD2),
        .mem_ext(mem_ext),
        .mem_s_rf_wsel(mem_s_rf_wsel),
        .mem_rf_we(mem_rf_we),
        .mem_ram_we(mem_ram_we),
        .mem_C(mem_C),
        .valid_out(valid_out_ex_mem)
    );

    MEM_WB U_MEM_WB (
        .cpu_rst(cpu_rst),
        .cpu_clk(cpu_clk),
        .mem_pc4(mem_pc4),
        .mem_inst(mem_inst),
        .mem_ext(mem_ext),
        .mem_s_rf_wsel(mem_s_rf_wsel),
        .mem_rf_we(mem_rf_we),
        .mem_C(mem_C),
        .rdo(Bus_rdata),
        .valid_in(valid_out_ex_mem),
        .wb_pc4(wb_pc4),
        .wb_inst(wb_inst),
        .wb_ext(wb_ext),
        .wb_s_rf_wsel(wb_s_rf_wsel),
        .wb_rf_we(wb_rf_we),
        .wb_C(wb_C),
        .wb_rdo(wb_rdo),
        .valid_out(valid_out_mem_wb)
    );

    rf_wsel U_rf_wsel (
        .ext(wb_ext),
        .C(wb_C),
        .PC4(wb_pc4),
        .s_rf_wsel(wb_s_rf_wsel),
        .rdo(wb_rdo),
        .wD(wD)
    );

    data_forward U_data_forward (
        .id_inst(id_inst),
        .ex_inst(ex_inst),
        .mem_inst(mem_inst),
        .wb_inst(wb_inst),
        .RF_rD1(rD1),
        .RF_rD2(rD2),
        .C(C),
        .ex_pc4(ex_pc4),
        .ex_ext(ex_ext),
        .mem_C(mem_C),
        .mem_pc4(mem_pc4),
        .mem_ext(mem_ext),
        .rdo(Bus_rdata),
        .wb_C(wb_C),
        .wb_pc4(wb_pc4),
        .wb_ext(wb_ext),
        .wb_rdo(wb_rdo),
        .suspend(suspend),
        .load_use(load_use),
        .actual_rD1(actual_rD1),
        .actual_rD2(actual_rD2)
    );

`ifdef RUN_TRACE
    // Debug Interface
    assign debug_wb_have_inst = valid_out_mem_wb; // 指示当前写回的指令是否有效
    assign debug_wb_pc        = wb_pc4 - 32'h0000_0004; // 当前写回的指令的PC
    assign debug_wb_ena       = wb_rf_we; // 指令写回时，寄存器堆的写使能
    assign debug_wb_reg       = wb_inst[11:7]; // 指令写回时，写入的寄存器号
    assign debug_wb_value     = wD;    // 指令写回时，写入寄存器的值
`endif

endmodule
