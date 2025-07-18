`timescale 1ns / 1ps
/*
module NPC(
    input  wire [31:0] if_pc,
    input  wire [31:0] id_pc,
    input  wire [31:0] offset,
    input  wire [ 0:0] br,
    input  wire [ 1:0] npc_op,
    output reg  [31:0] npc,
    output reg  [31:0] PC4
);

    always @(*) begin
        case (npc_op)
            `NPC_JMP: npc = id_pc + offset; // 直接跳转指令
            `NPC_BEQ: begin
                case (br)
                    1'b0: npc = id_pc + 32'h0000_0004;
                    1'b1: npc = id_pc + offset;
                    default: npc = id_pc + 32'h0000_0004; // 默认跳转到下一条指令
                endcase
            end
            default: npc = id_pc + 32'h0000_0004;
        endcase
    end

    always @(*) begin
        PC4 = if_pc + 32'h0000_0004; // PC+4
    end 
    
endmodule
*/