`timescale 1ns / 1ps

module RF(
    input  wire        cpu_clk,
    input  wire        cpu_rst,

    input  wire [ 4:0] rR1,
    output reg  [31:0] rD1,
    
    input  wire [ 4:0] rR2,
    output reg  [31:0] rD2,
    
    input  wire        we,
    input  wire [ 4:0] wR,
    input  wire [31:0] wD
);

    reg [31:0] rf [31:0];

    always @(*) begin
        if (rR1 == 5'b0) begin
            rD1 = 32'b0;
        end else begin
            rD1 = rf[rR1];
        end
        
        if (rR2 == 5'b0) begin
            rD2 = 32'b0;
        end else begin
            rD2 = rf[rR2];
        end
    end

    always @(posedge cpu_clk or posedge cpu_rst) begin
        if (cpu_rst) begin
            rf[0] <= 32'b0;
            rf[1] <= 32'b0;
            rf[2] <= 32'b0;
            rf[3] <= 32'b0;
            rf[4] <= 32'b0;
            rf[5] <= 32'b0;
            rf[6] <= 32'b0;
            rf[7] <= 32'b0;
            rf[8] <= 32'b0;
            rf[9] <= 32'b0;
            rf[10] <= 32'b0;
            rf[11] <= 32'b0;
            rf[12] <= 32'b0;
            rf[13] <= 32'b0;
            rf[14] <= 32'b0;
            rf[15] <= 32'b0;
            rf[16] <= 32'b0;
            rf[17] <= 32'b0;
            rf[18] <= 32'b0;
            rf[19] <= 32'b0;
            rf[20] <= 32'b0;
            rf[21] <= 32'b0;
            rf[22] <= 32'b0;
            rf[23] <= 32'b0;
            rf[24] <= 32'b0;
            rf[25] <= 32'b0;
            rf[26] <= 32'b0;
            rf[27] <= 32'b0;
            rf[28] <= 32'b0;
            rf[29] <= 32'b0;
            rf[30] <= 32'b0;
            rf[31] <= 32'b0;
        end else begin
            if (we && wR != 5'b0) begin
                rf[wR] <= wD;
            end
        end
    end

endmodule
