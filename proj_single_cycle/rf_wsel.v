`timescale 1ns / 1ps

module rf_wsel(
    input  wire [31:0] ext,
    input  wire [31:0] C,
    input  wire [31:0] PC4,
    input  wire [31:0] rdo,
    input  wire [ 1:0] s_rf_wsel,
    output reg  [31:0] wD
);

    always @(*) begin
        case (s_rf_wsel)
            `WB_ALU: wD = C;
            `WB_PC4: wD = PC4;
            `WB_EXT: wD = ext;
            `WB_DRAM: wD = rdo;
            default: wD = 32'b0;
        endcase
    end

endmodule
