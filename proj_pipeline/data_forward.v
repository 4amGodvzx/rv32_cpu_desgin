`timescale 1ns / 1ps

module data_forward (
    input  wire [31:0]  id_inst,
    input  wire [31:0]  ex_inst,
    input  wire [31:0]  mem_inst,
    input  wire [31:0]  wb_inst,
    input  wire [31:0]  RF_rD1,
    input  wire [31:0]  RF_rD2,
    input  wire [31:0]  C,
    input  wire [31:0]  ex_pc4,
    input  wire [31:0]  ex_ext,
    input  wire [31:0]  mem_C,
    input  wire [31:0]  mem_pc4,
    input  wire [31:0]  mem_ext,
    input  wire [31:0]  rdo,
    input  wire [31:0]  wb_C,
    input  wire [31:0]  wb_pc4,
    input  wire [31:0]  wb_ext,
    input  wire [31:0]  wb_rdo,
    output wire          suspend,
    output wire          load_use,
    output reg  [31:0]  actual_rD1,
    output reg  [31:0]  actual_rD2
);

    wire hazard_ex_rD1;
    wire hazard_mem_rD1;
    wire hazard_wb_rD1;
    wire hazard_ex_rD2;
    wire hazard_mem_rD2;
    wire hazard_wb_rD2;

    wire ex_x0_or_not;
    wire mem_x0_or_not;
    wire wb_x0_or_not;

    reg load_use_rD1;
    reg load_use_rD2;
    reg suspend_rD1;
    reg suspend_rD2;

    assign ex_x0_or_not = (ex_inst[11:7] == 5'b00000) ? 1'b1 : 1'b0;
    assign mem_x0_or_not = (mem_inst[11:7] == 5'b00000) ? 1'b1 : 1'b0;
    assign wb_x0_or_not = (wb_inst[11:7] == 5'b00000) ? 1'b1 : 1'b0;

    assign hazard_ex_rD1 = (id_inst[19:15] == ex_inst[11:7]) && !ex_x0_or_not ? 1'b1 : 1'b0;
    assign hazard_mem_rD1 = (id_inst[19:15] == mem_inst[11:7]) && !mem_x0_or_not ? 1'b1 : 1'b0;
    assign hazard_wb_rD1 = (id_inst[19:15] == wb_inst[11:7]) && !wb_x0_or_not ? 1'b1 : 1'b0;
    assign hazard_ex_rD2 = (id_inst[24:20] == ex_inst[11:7]) && !ex_x0_or_not ? 1'b1 : 1'b0;
    assign hazard_mem_rD2 = (id_inst[24:20] == mem_inst[11:7]) && !mem_x0_or_not ? 1'b1 : 1'b0;
    assign hazard_wb_rD2 = (id_inst[24:20] == wb_inst[11:7]) && !wb_x0_or_not ? 1'b1 : 1'b0;

    always @(*) begin
        if (hazard_ex_rD1) begin
            case (ex_inst[6:0])
                7'b0110011: begin actual_rD1 = C ; load_use_rD1 = 1'b0; suspend_rD1 = 1'b0; end
                7'b0010011: begin actual_rD1 = C ; load_use_rD1 = 1'b0; suspend_rD1 = 1'b0; end
                7'b1110011: begin actual_rD1 = ex_pc4 ; load_use_rD1 = 1'b0; suspend_rD1 = 1'b0; end
                7'b1101111: begin actual_rD1 = ex_pc4 ; load_use_rD1 = 1'b0; suspend_rD1 = 1'b0; end
                7'b0110111: begin actual_rD1 = ex_ext ; load_use_rD1 = 1'b0; suspend_rD1 = 1'b0; end
                7'b0000011: begin actual_rD1 = RF_rD1 ; load_use_rD1 = 1'b1; suspend_rD1 = 1'b1; end
                default: begin actual_rD1 = RF_rD1; load_use_rD1 = 1'b0; suspend_rD1 = 1'b0; end
            endcase
        end else if (hazard_mem_rD1) begin
            case (mem_inst[6:0])
                7'b0110011: begin actual_rD1 = mem_C ; load_use_rD1 = 1'b0; suspend_rD1 = 1'b0; end
                7'b0010011: begin actual_rD1 = mem_C ; load_use_rD1 = 1'b0; suspend_rD1 = 1'b0; end
                7'b1110011: begin actual_rD1 = mem_pc4 ; load_use_rD1 = 1'b0; suspend_rD1 = 1'b0; end
                7'b1101111: begin actual_rD1 = mem_pc4 ; load_use_rD1 = 1'b0; suspend_rD1 = 1'b0; end
                7'b0110111: begin actual_rD1 = mem_ext ; load_use_rD1 = 1'b0; suspend_rD1 = 1'b0; end
                7'b0000011: begin actual_rD1 = rdo ; load_use_rD1 = 1'b0; suspend_rD1 = 1'b0; end
                default: begin actual_rD1 = RF_rD1; load_use_rD1 = 1'b0; suspend_rD1 = 1'b0; end
            endcase
        end else if (hazard_wb_rD1) begin
            case (wb_inst[6:0])
                7'b0110011: begin actual_rD1 = wb_C; load_use_rD1 = 1'b0; suspend_rD1 = 1'b0; end
                7'b0010011: begin actual_rD1 = wb_C; load_use_rD1 = 1'b0; suspend_rD1 = 1'b0; end
                7'b1110011: begin actual_rD1 = wb_pc4; load_use_rD1 = 1'b0; suspend_rD1 = 1'b0; end
                7'b1101111: begin actual_rD1 = wb_pc4; load_use_rD1 = 1'b0; suspend_rD1 = 1'b0; end
                7'b0110111: begin actual_rD1 = wb_ext; load_use_rD1 = 1'b0; suspend_rD1 = 1'b0; end
                7'b0000011: begin actual_rD1 = wb_rdo; load_use_rD1 = 1'b0; suspend_rD1 = 1'b0; end
                default: begin actual_rD1 = RF_rD1; load_use_rD1 = 1'b0; suspend_rD1 = 1'b0; end
            endcase
        end else begin
            actual_rD1 = RF_rD1;
            load_use_rD1 = 1'b0;
            suspend_rD1 = 1'b0;
        end

        if (hazard_ex_rD2) begin
            case (ex_inst[6:0])
                7'b0110011: begin actual_rD2 = C; load_use_rD2 = 1'b0; suspend_rD2 = 1'b0; end
                7'b0010011: begin actual_rD2 = C; load_use_rD2 = 1'b0; suspend_rD2 = 1'b0; end
                7'b1110011: begin actual_rD2 = ex_pc4; load_use_rD2 = 1'b0; suspend_rD2 = 1'b0; end
                7'b1101111: begin actual_rD2 = ex_pc4; load_use_rD2 = 1'b0; suspend_rD2 = 1'b0; end
                7'b0110111: begin actual_rD2 = ex_ext; load_use_rD2 = 1'b0; suspend_rD2 = 1'b0; end
                7'b0000011: begin actual_rD2 = RF_rD2; load_use_rD2 = 1'b1; suspend_rD2 = 1'b1; end
                default: begin actual_rD2 = RF_rD2; load_use_rD2 = 1'b0; suspend_rD2 = 1'b0; end
            endcase
        end else if (hazard_mem_rD2) begin
            case (mem_inst[6:0])
                7'b0110011: begin actual_rD2 = mem_C; load_use_rD2 = 1'b0; suspend_rD2 = 1'b0; end
                7'b0010011: begin actual_rD2 = mem_C; load_use_rD2 = 1'b0; suspend_rD2 = 1'b0; end
                7'b1110011: begin actual_rD2 = mem_pc4; load_use_rD2 = 1'b0; suspend_rD2 = 1'b0; end
                7'b1101111: begin actual_rD2 = mem_pc4; load_use_rD2 = 1'b0; suspend_rD2 = 1'b0; end
                7'b0110111: begin actual_rD2 = mem_ext; load_use_rD2 = 1'b0; suspend_rD2 = 1'b0; end
                7'b0000011: begin actual_rD2 = rdo; load_use_rD2 = 1'b0; suspend_rD2 = 1'b0; end
                default: begin actual_rD2 = RF_rD2; load_use_rD2 = 1'b0; suspend_rD2 = 1'b0; end
            endcase
        end else if (hazard_wb_rD2) begin
            case (wb_inst[6:0])
                7'b0110011: begin actual_rD2 = wb_C; load_use_rD2 = 1'b0; suspend_rD2 = 1'b0; end
                7'b0010011: begin actual_rD2 = wb_C; load_use_rD2 = 1'b0; suspend_rD2 = 1'b0; end
                7'b1110011: begin actual_rD2 = wb_pc4; load_use_rD2 = 1'b0; suspend_rD2 = 1'b0; end
                7'b1101111: begin actual_rD2 = wb_pc4; load_use_rD2 = 1'b0; suspend_rD2 = 1'b0; end
                7'b0110111: begin actual_rD2 = wb_ext; load_use_rD2 = 1'b0; suspend_rD2 = 1'b0; end
                7'b0000011: begin actual_rD2 = wb_rdo; load_use_rD2 = 1'b0; suspend_rD2 = 1'b0; end
                default: begin actual_rD2 = RF_rD2; load_use_rD2 = 1'b0; suspend_rD2 = 1'b0; end
            endcase
        end else begin
            actual_rD2 = RF_rD2;
            load_use_rD2 = 1'b0;
            suspend_rD2 = 1'b0;
        end
    end

    assign load_use = load_use_rD1 || load_use_rD2;
    assign suspend = suspend_rD1 || suspend_rD2;

endmodule
