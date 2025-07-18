`timescale 1ns / 1ps

module alub_sel(
    input  wire [31:0] ext,
    input  wire [31:0] rD2,
    input  wire        s_alub_sel,
    output reg  [31:0] B
);

    always @(*) begin
        case (s_alub_sel)
            2'b00: B = rD2;
            2'b01: B = ext;
            default: B = 32'b0;
        endcase
    end

endmodule

