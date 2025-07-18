`timescale 1ns / 1ps

`include "defines.vh"

module io_device (
    input wire dig_rst,
    input wire dig_clk,
    input wire [31:0] dig_addr,
    input wire dig_we,
    input wire [31:0] dig_wdata,
    input wire led_rst,
    input wire led_clk,
    input wire [31:0] led_addr,
    input wire led_we,
    input wire [31:0] led_wdata,
    input wire sw_rst,
    input wire sw_clk,
    input wire [31:0] sw_addr,
    output wire [31:0] sw_rdata,
    input wire btn_rst,
    input wire btn_clk,
    input wire [31:0] btn_addr,
    output wire [31:0] btn_rdata,
    input wire timer_rst,
    input wire timer_clk,
    input wire [31:0] timer_addr,
    output wire [31:0] timer_rdata,
    input wire timer_set_rst,
    input wire timer_set_clk,
    input wire [31:0] timer_set_addr,
    input wire timer_set_we,
    input wire [31:0] timer_set_wdata,
    input wire [23:0] sw,
    input wire [4:0] button,
    output wire [7:0] dig_en,
    output wire DN_A,
    output wire DN_B,
    output wire DN_C,
    output wire DN_D,
    output wire DN_E,
    output wire DN_F,
    output wire DN_G,
    output wire DN_DP,
    output wire [23:0] led
);

    reg [7:0] dn_vector;

    localparam dn_0 = 8'b00000011;
    localparam dn_1 = 8'b10011111;
    localparam dn_2 = 8'b00100101;
    localparam dn_3 = 8'b00001101;
    localparam dn_4 = 8'b10011001;
    localparam dn_5 = 8'b01001001;
    localparam dn_6 = 8'b01000001;
    localparam dn_7 = 8'b00011111;
    localparam dn_8 = 8'b00000001;
    localparam dn_9 = 8'b00001001;
    localparam dn_a = 8'b00010001;
    localparam dn_b = 8'b11000001;
    localparam dn_c = 8'b01100011;
    localparam dn_d = 8'b10000101;
    localparam dn_e = 8'b01100001;
    localparam dn_f = 8'b01110001;

    reg [2:0] scan_cnt;
    reg [7:0] dig_en_in;
    reg [31:0] dig_wdata_in;
    reg [31:0] dig_timer;

    always @(posedge dig_clk or posedge dig_rst) begin
        if (dig_rst) begin
            scan_cnt <= 3'd0;
            dig_en_in <= 8'b1111_1111;
            dn_vector <= 8'b0;
            dig_wdata_in <= 32'b0;
            dig_timer <= 32'b0;
        end else begin
            if (dig_we) begin
                dig_wdata_in <= dig_wdata;
            end
            if (dig_timer < 300000) begin
                dig_timer <= dig_timer + 1'b1;
            end else begin
                dig_timer <= 32'b0;
                case (scan_cnt)
                    3'd0: begin
                        dig_en_in <= 8'b1111_1110;
                        case (dig_wdata_in[3:0])
                            4'h0: dn_vector <= dn_0;
                            4'h1: dn_vector <= dn_1;
                            4'h2: dn_vector <= dn_2;
                            4'h3: dn_vector <= dn_3;
                            4'h4: dn_vector <= dn_4;
                            4'h5: dn_vector <= dn_5;
                            4'h6: dn_vector <= dn_6;
                            4'h7: dn_vector <= dn_7;
                            4'h8: dn_vector <= dn_8;
                            4'h9: dn_vector <= dn_9;
                            4'ha: dn_vector <= dn_a;
                            4'hb: dn_vector <= dn_b;
                            4'hc: dn_vector <= dn_c;
                            4'hd: dn_vector <= dn_d;
                            4'he: dn_vector <= dn_e;
                            4'hf: dn_vector <= dn_f;
                            default: dn_vector <= 8'b1111_1111;
                        endcase
                    end
                    3'd1: begin
                        dig_en_in <= 8'b1111_1101;
                        case (dig_wdata_in[7:4])
                            4'h0: dn_vector <= dn_0;
                            4'h1: dn_vector <= dn_1;
                            4'h2: dn_vector <= dn_2;
                            4'h3: dn_vector <= dn_3;
                            4'h4: dn_vector <= dn_4;
                            4'h5: dn_vector <= dn_5;
                            4'h6: dn_vector <= dn_6;
                            4'h7: dn_vector <= dn_7;
                            4'h8: dn_vector <= dn_8;
                            4'h9: dn_vector <= dn_9;
                            4'ha: dn_vector <= dn_a;
                            4'hb: dn_vector <= dn_b;
                            4'hc: dn_vector <= dn_c;
                            4'hd: dn_vector <= dn_d;
                            4'he: dn_vector <= dn_e;
                            4'hf: dn_vector <= dn_f;
                            default: dn_vector <= 8'b1111_1111;
                        endcase
                    end
                    3'd2: begin
                        dig_en_in <= 8'b1111_1011;
                        case (dig_wdata_in[11:8])
                            4'h0: dn_vector <= dn_0;
                            4'h1: dn_vector <= dn_1;
                            4'h2: dn_vector <= dn_2;
                            4'h3: dn_vector <= dn_3;
                            4'h4: dn_vector <= dn_4;
                            4'h5: dn_vector <= dn_5;
                            4'h6: dn_vector <= dn_6;
                            4'h7: dn_vector <= dn_7;
                            4'h8: dn_vector <= dn_8;
                            4'h9: dn_vector <= dn_9;
                            4'ha: dn_vector <= dn_a;
                            4'hb: dn_vector <= dn_b;
                            4'hc: dn_vector <= dn_c;
                            4'hd: dn_vector <= dn_d;
                            4'he: dn_vector <= dn_e;
                            4'hf: dn_vector <= dn_f;
                            default: dn_vector <= 8'b1111_1111;
                        endcase
                    end
                    3'd3: begin
                        dig_en_in <= 8'b1111_0111;
                        case (dig_wdata_in[15:12])
                            4'h0: dn_vector <= dn_0;
                            4'h1: dn_vector <= dn_1;
                            4'h2: dn_vector <= dn_2;
                            4'h3: dn_vector <= dn_3;
                            4'h4: dn_vector <= dn_4;
                            4'h5: dn_vector <= dn_5;
                            4'h6: dn_vector <= dn_6;
                            4'h7: dn_vector <= dn_7;
                            4'h8: dn_vector <= dn_8;
                            4'h9: dn_vector <= dn_9;
                            4'ha: dn_vector <= dn_a;
                            4'hb: dn_vector <= dn_b;
                            4'hc: dn_vector <= dn_c;
                            4'hd: dn_vector <= dn_d;
                            4'he: dn_vector <= dn_e;
                            4'hf: dn_vector <= dn_f;
                            default: dn_vector <= 8'b1111_1111;
                        endcase
                    end
                    3'd4: begin
                        dig_en_in <= 8'b1110_1111;
                        case (dig_wdata_in[19:16])
                            4'h0: dn_vector <= dn_0;
                            4'h1: dn_vector <= dn_1;
                            4'h2: dn_vector <= dn_2;
                            4'h3: dn_vector <= dn_3;
                            4'h4: dn_vector <= dn_4;
                            4'h5: dn_vector <= dn_5;
                            4'h6: dn_vector <= dn_6;
                            4'h7: dn_vector <= dn_7;
                            4'h8: dn_vector <= dn_8;
                            4'h9: dn_vector <= dn_9;
                            4'ha: dn_vector <= dn_a;
                            4'hb: dn_vector <= dn_b;
                            4'hc: dn_vector <= dn_c;
                            4'hd: dn_vector <= dn_d;
                            4'he: dn_vector <= dn_e;
                            4'hf: dn_vector <= dn_f;
                            default: dn_vector <= 8'b1111_1111;
                        endcase
                    end
                    3'd5: begin
                        dig_en_in <= 8'b1101_1111;
                        case (dig_wdata_in[23:20])
                            4'h0: dn_vector <= dn_0;
                            4'h1: dn_vector <= dn_1;
                            4'h2: dn_vector <= dn_2;
                            4'h3: dn_vector <= dn_3;
                            4'h4: dn_vector <= dn_4;
                            4'h5: dn_vector <= dn_5;
                            4'h6: dn_vector <= dn_6;
                            4'h7: dn_vector <= dn_7;
                            4'h8: dn_vector <= dn_8;
                            4'h9: dn_vector <= dn_9;
                            4'ha: dn_vector <= dn_a;
                            4'hb: dn_vector <= dn_b;
                            4'hc: dn_vector <= dn_c;
                            4'hd: dn_vector <= dn_d;
                            4'he: dn_vector <= dn_e;
                            4'hf: dn_vector <= dn_f;
                            default: dn_vector <= 8'b1111_1111;
                        endcase
                    end
                    3'd6: begin
                        dig_en_in <= 8'b1011_1111;
                        case (dig_wdata_in[27:24])
                            4'h0: dn_vector <= dn_0;
                            4'h1: dn_vector <= dn_1;
                            4'h2: dn_vector <= dn_2;
                            4'h3: dn_vector <= dn_3;
                            4'h4: dn_vector <= dn_4;
                            4'h5: dn_vector <= dn_5;
                            4'h6: dn_vector <= dn_6;
                            4'h7: dn_vector <= dn_7;
                            4'h8: dn_vector <= dn_8;
                            4'h9: dn_vector <= dn_9;
                            4'ha: dn_vector <= dn_a;
                            4'hb: dn_vector <= dn_b;
                            4'hc: dn_vector <= dn_c;
                            4'hd: dn_vector <= dn_d;
                            4'he: dn_vector <= dn_e;
                            4'hf: dn_vector <= dn_f;
                            default: dn_vector <= 8'b1111_1111;
                        endcase
                    end
                    3'd7: begin
                        dig_en_in <= 8'b0111_1111;
                        case (dig_wdata_in[31:28])
                            4'h0: dn_vector <= dn_0;
                            4'h1: dn_vector <= dn_1;
                            4'h2: dn_vector <= dn_2;
                            4'h3: dn_vector <= dn_3;
                            4'h4: dn_vector <= dn_4;
                            4'h5: dn_vector <= dn_5;
                            4'h6: dn_vector <= dn_6;
                            4'h7: dn_vector <= dn_7;
                            4'h8: dn_vector <= dn_8;
                            4'h9: dn_vector <= dn_9;
                            4'ha: dn_vector <= dn_a;
                            4'hb: dn_vector <= dn_b;
                            4'hc: dn_vector <= dn_c;
                            4'hd: dn_vector <= dn_d;
                            4'he: dn_vector <= dn_e;
                            4'hf: dn_vector <= dn_f;
                            default: dn_vector <= 8'b1111_1111;
                        endcase
                    end
                    default: begin
                        dig_en_in <= 8'hFF;
                        dn_vector <= 8'hFF;
                    end
                endcase
                scan_cnt <= scan_cnt + 1'b1;
            end
        end
    end

    assign {DN_A, DN_B, DN_C, DN_D, DN_E, DN_F, DN_G, DN_DP} = dn_vector;
    assign dig_en = dig_en_in;

    reg [23:0] led_in;

    always @(posedge led_clk or posedge led_rst) begin
        if (led_rst) begin
            led_in <= 24'b0;
        end else begin 
            if (led_we) begin
                led_in <= led_wdata[23:0];
            end
        end
    end

    assign led = led_in;

    reg [31:0] sw_rdata_in;

    always @(posedge sw_clk or posedge sw_rst) begin
        if (sw_rst) begin
            sw_rdata_in <= 32'b0;
        end else begin
            sw_rdata_in <= {8'b0, sw[23:0]};
        end
    end

    assign sw_rdata = sw_rdata_in;

    reg [31:0] button_in;

    always @(posedge btn_clk or posedge btn_rst) begin
        if (btn_rst) begin
            button_in <= 32'b0;
        end else begin
            button_in <= {27'b0, button[4:0]};
        end
    end

    assign btn_rdata = button_in;

    reg [31:0] timer_set_wdata_in;

    always @(posedge timer_set_clk or posedge timer_set_rst) begin
        if (timer_set_rst) begin
            timer_set_wdata_in <= 32'b0;
        end else begin
            if (timer_set_we) begin
                timer_set_wdata_in <= timer_set_wdata;
            end
        end
    end

    reg [31:0] timer_rdata_in;
    reg [31:0] timer;

    always @(posedge timer_clk or posedge timer_rst) begin
        if (timer_rst) begin
            timer_rdata_in <= 32'b0;
            timer <= 32'b0;
        end else begin
            if (timer < timer_set_wdata_in) begin
                timer <= timer + 1'b1;
            end else begin
                timer <= 32'b0;
                timer_rdata_in <= timer_rdata_in + 1'b1;
            end
        end
    end

    assign timer_rdata = timer_rdata_in;

endmodule