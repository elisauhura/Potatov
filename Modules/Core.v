//  Core.v
//
//  Created by Elisa Silva on 14/10/21.
//  Copyright © 2021 Uhura. All rights reserved.

`include "MemoryInterface.v"
`include "Registers.v"
`include "InstructionFetch.v"

`define CoreStateInit 0
`define CoreStateFetch 1
`define CoreStateFetchWaitReady 2
`define CoreStateStall 999

module Core(
    cCommand,
    cAddress,
    cData,
    hReady,
    hSignal,
    hData,
    reset,
    clock
);

output reg [3:0]cCommand;
output    [31:0]cAddress;
output    [31:0]cData;
input       hReady;
input       hSignal;
input [31:0]hData;
input reset;
input clock;

Registers registers(
    .cReg1Address(),
    .cReg2Address(),
    .cRegDAddress(registers_cRegDAddress),
    .cRegDData(),
    .hReg1Data(),
    .hReg2Data(),
    .reset(reset),
    .clock(clock)
);

wire [4:0]registers_cRegDAddress;
assign registers_cRegDAddress = (clock && writeBack) ? rd : 0;

reg [31:0]PC /* verilator public */;
reg [31:0]nextPC;
reg [31:0]instruction /* verilator public */;
reg [31:0]state /* verilator public */;

// CPU state control
reg writeBack;
reg side;

// Instruction decoding
wire [31:0]immediate;
wire [6:0]opcode;
wire [4:0]rs1;
wire [4:0]rs2;
wire [4:0]rd;
wire [2:0]funct3;
wire [6:0]funct7;
wire [4:0]shamt;
assign immediate = IFDecodeImmediate(instruction, IFDecodeType(instruction));
assign opcode = instruction[6:0];
assign rs1 = instruction[19:15];
assign rs2 = instruction[24:20];
assign rd = instruction[11:7];
assign funct3 = instruction[14:12];
assign funct7 = instruction[31:25];
assign shamt = instruction[24:20];


always @(posedge clock) begin
    writeBack = 0;
    if(reset) begin
        PC = 'h0;
        state = `CoreStateInit;
        side = 0;
        cCommand = `MemoryInterfaceCommandNOP;
    end
    case(state)
    `CoreStateInit: begin
        cCommand = `MemoryInterfaceCommandNOP;
        nextPC = 'h800; // entry point
        state = `CoreStateFetch;
    end
    `CoreStateFetch: begin
        PC = nextPC;
        cCommand = side == 0 ? `MemoryInterfaceCommandRWA : `MemoryInterfaceCommandRWB;
        side = !side;
        if(hReady) begin
            instruction = hData;
            state = process_instruction();
        end else begin
            state = `CoreStateFetchWaitReady;
        end
    end
    `CoreStateFetchWaitReady: begin
        if(hReady) begin
            instruction = hData;
            state = process_instruction();
        end else begin
            state = `CoreStateFetchWaitReady;
        end
    end
    `CoreStateStall: begin end
    default:
        state = `CoreStateInit;
    endcase;
end

function [31:0]process_instruction();
case(opcode)
default: begin end
endcase;
nextPC = PC + 4;
process_instruction = `CoreStateFetch;
endfunction;

endmodule
