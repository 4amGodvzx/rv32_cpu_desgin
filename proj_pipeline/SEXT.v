`timescale 1ns / 1ps
`include "defines.vh"

module SEXT(
    input  wire [31:0] inst,
    input  wire [ 2:0] ext_op,
    output reg  [31:0] ext
);

    always @(*) begin
        case (ext_op)
            `EXT_I: ext = {{20{inst[31]}}, inst[31:20]};
            `EXT_S: ext = {{20{inst[31]}}, inst[31:25], inst[11:7]};
            `EXT_B: ext = {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
            `EXT_J: ext = {{12{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};
            `EXT_U: ext = {inst[31:12], 12'b0};
            default: ext = 32'b0;
        endcase
    end

endmodule

