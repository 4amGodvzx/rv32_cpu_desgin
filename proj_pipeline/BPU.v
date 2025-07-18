`timescale 1ns / 1ps

// 采用总是预测分支不跳转

module BPU (
    input  wire [31:0] ex_inst,
    input  wire [31:0] ex_pc,
    input  wire [31:0] ex_ext,
    input  wire [31:0] ex_rD1,
    input  wire [ 1:0] f,
    input  wire [1: 0] ex_npc_op,
    output reg         flush,
    output reg  [31:0] flush_pc
    
);

    wire beq_or_not = (ex_inst[14:12] == 3'b000) ? 1'b1 : 1'b0;
    wire bne_or_not = (ex_inst[14:12] == 3'b001) ? 1'b1 : 1'b0;
    wire blt_or_not = (ex_inst[14:12] == 3'b100) ? 1'b1 : 1'b0;
    wire br = (beq_or_not == 1 && f == 2'b00) || (bne_or_not == 1 && (f == 2'b01 || f == 2'b10)) || (blt_or_not == 1 && f == 2'b01);

    always @(*) begin
        case (ex_npc_op)
            `NPC_JALR: begin flush_pc = ex_rD1 + ex_ext; flush = 1'b1; end
            `NPC_BEQ: begin
                case (br)
                    1'b0: begin flush_pc = ex_pc + 32'h0000_0004; flush = 1'b0; end
                    1'b1: begin flush_pc = ex_pc + ex_ext; flush = 1'b1; end
                    default: begin flush_pc = ex_pc + 32'h0000_0004; flush = 1'b0; end
                endcase
            end
            `NPC_JAL: begin flush_pc = ex_pc + ex_ext; flush = 1'b1; end
            default: begin flush_pc = ex_pc + 32'h0000_0004; flush = 1'b0; end
        endcase
    end

endmodule
