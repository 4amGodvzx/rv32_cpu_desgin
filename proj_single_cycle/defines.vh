// Annotate this macro before synthesis
//`define RUN_TRACE

// TODO: 在此处定义你的宏
`define NPC_PC4 2'b00
`define NPC_BEQ 2'b01
`define NPC_JMP 2'b10

// (ALU.f) = 0: BEQ分支且BLT不分支
// (ALU.f) = 1: BEQ不分支且BLT分支
// (ALU.f) = 2: BEQ不分支且BLT不分支

`define WB_ALU  2'b00
`define WB_PC4  2'b01
`define WB_EXT  2'b10
`define WB_DRAM 2'b11

`define EXT_I 3'b000
`define EXT_S 3'b001
`define EXT_B 3'b010
`define EXT_J 3'b011
`define EXT_U 3'b100

`define ALU_ADD 3'b000
`define ALU_SUB 3'b001
`define ALU_AND 3'b010
`define ALU_OR  3'b011
`define ALU_XOR 3'b100
`define ALU_SLL 3'b101
`define ALU_SRL 3'b110
`define ALU_SRA 3'b111

// ALUB_RS2 = 2'b00
// ALUB_EXT = 2'b01

// 外设I/O接口电路的端口地址
`define PERI_ADDR_DIG   32'hFFFF_F000
`define PERI_ADDR_LED   32'hFFFF_F060
`define PERI_ADDR_SW    32'hFFFF_F070
`define PERI_ADDR_BTN   32'hFFFF_F078
`define PERI_ADDR_TIMER 32'hFFFF_F020
`define PERI_ADDR_TIMER_SET 32'hFFFF_F024
