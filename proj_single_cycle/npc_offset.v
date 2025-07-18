`timescale 1ns / 1ps

module npc_offset(
    input  wire        s_npc_offset,
    input  wire [31:0] ext,
    input  wire [31:0] C,
    input  wire [31:0] pc,
    output wire [31:0] offset
);

    assign offset = s_npc_offset ? C - pc : ext;

endmodule
