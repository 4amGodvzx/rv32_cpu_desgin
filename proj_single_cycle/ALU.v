`timescale 1ns / 1ps
`include "defines.vh"

module ALU(
    input  wire [ 2:0] op,
    input  wire [31:0] A,
    input  wire [31:0] B,
    output reg  [31:0] C,
    output reg  [ 1:0] f
);

    wire [4:0] shamt = B[4:0];

    always @(*) begin
        case (op)
            `ALU_ADD: C = A + B;
            `ALU_SUB: C = $signed(A - B);
            `ALU_AND: C = A & B;
            `ALU_OR:  C = A | B;
            `ALU_XOR: C = A ^ B;
            `ALU_SLL: C = A << shamt;
            `ALU_SRL: C = A >> shamt;
            `ALU_SRA: C = $signed(A) >>> shamt;
            default: C = 32'b0;
        endcase
    end

    always @(*) begin
        if (C[31] == 1'b1) begin
            f = 2'b01;
        end else if (C[31] == 1'b0 && C != 32'b0) begin
            f = 2'b10;
        end else begin
            f = 2'b00;
        end
    end

endmodule

