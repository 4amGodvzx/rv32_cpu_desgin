`timescale 1ns / 1ps

module Ctrl(
    input  wire [6:0] opcode,
    input  wire [6:0] funct7,
    input  wire [2:0] funct3,
    output reg  [0:0] s_npc_offset,
    output reg  [1:0] npc_op,
    output reg  [1:0] s_rf_wsel,
    output reg  [0:0] rf_we,
    output reg  [2:0] ext_op,
    output reg  [2:0] alu_op,
    output reg  [0:0] s_alub_sel,
    output reg  [0:0] ram_we
);

    always @(*) begin
        if (opcode == 7'b1100111) begin
            s_npc_offset = 1;
        end else begin
            s_npc_offset = 0;
        end
    end

    always @(*) begin
        if (opcode == 7'b1100011) begin
            npc_op = `NPC_BEQ;
        end else if (opcode == 7'b1101111 || opcode == 7'b1100111) begin
            npc_op = `NPC_JMP;
        end else begin
            npc_op = `NPC_PC4;
        end
    end

    always @(*) begin
        case (opcode)
            7'b0110111: s_rf_wsel = `WB_EXT;
            7'b1101111: s_rf_wsel = `WB_PC4;
            7'b1100111: s_rf_wsel = `WB_PC4;
            7'b0000011: s_rf_wsel = `WB_DRAM;
            default:    s_rf_wsel = `WB_ALU;
        endcase
    end

    always @(*) begin
        if (opcode == 7'b0100011 || opcode == 7'b1100011) begin
            rf_we = 0;
        end else begin
            rf_we = 1;
        end
    end

    always @(*) begin
        case (opcode)
            7'b0010011: ext_op = `EXT_I;
            7'b0000011: ext_op = `EXT_I;
            7'b1100111: ext_op = `EXT_I;
            7'b0100011: ext_op = `EXT_S;
            7'b1100011: ext_op = `EXT_B;
            7'b1101111: ext_op = `EXT_J;
            7'b0110111: ext_op = `EXT_U;
            default:    ext_op = 3'b000;
        endcase
    end

    always @(*) begin
        case (opcode)
            7'b0110011: begin
                case (funct3)
                    3'b000: alu_op = (funct7[5] == 1'b0) ? `ALU_ADD : `ALU_SUB;
                    3'b111: alu_op = `ALU_AND;
                    3'b110: alu_op = `ALU_OR;
                    3'b100: alu_op = `ALU_XOR;
                    3'b001: alu_op = `ALU_SLL;
                    3'b101: alu_op = (funct7[5] == 1'b0) ? `ALU_SRL : `ALU_SRA;
                    default: alu_op = 3'b000;
                endcase
            end
            7'b0010011: begin
                case (funct3)
                    3'b000: alu_op = `ALU_ADD;
                    3'b111: alu_op = `ALU_AND;
                    3'b110: alu_op = `ALU_OR;
                    3'b100: alu_op = `ALU_XOR;
                    3'b001: alu_op = `ALU_SLL;
                    3'b101: alu_op = (funct7[5] == 1'b0) ? `ALU_SRL : `ALU_SRA;
                    default: alu_op = 3'b000;
                endcase
            end
            7'b0000011: alu_op = `ALU_ADD;
            7'b0100011: alu_op = `ALU_ADD;
            7'b1100011: alu_op = `ALU_SUB;
            7'b1100111: alu_op = `ALU_ADD;
            default:    alu_op = 3'b000;
        endcase
    end

    always @(*) begin
        if (opcode == 7'b0110011) begin
            s_alub_sel = 1'b0;
        end else if (opcode == 7'b1100011) begin
            s_alub_sel = 1'b0;
        end else begin
            s_alub_sel = 1'b1;
        end
    end

    always @(*) begin
        if (opcode == 7'b0100011) begin
            ram_we = 1'b1;
        end else begin
            ram_we = 1'b0;
        end
    end

endmodule
