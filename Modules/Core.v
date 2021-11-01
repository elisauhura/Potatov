//  Core.v
//
//  Created by Elisa Silva on 14/10/21.
//  Copyright © 2021 Uhura. All rights reserved.

`define CoreStateInit            'd0
`define CoreStateFetch           'd1
`define CoreStateExecute         'd2
`define CoreStateReadWriteHandle 'd3
`define CoreStateTrapHandle      'd4
`define CoreStateStall           'd5

`include "MemoryInterface.v"

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

// Memory Interface Client
output reg  [2:0]cCommand;
output reg [31:0]cAddress;
output     [31:0]cData;

// Memory Interface Host
input       hReady;
input       hSignal;
input [31:0]hData;

// Shared signals
input reset;
input clock;

// Core Context
reg [2:0]state /* verilator public */;
reg [63:0]tickCount;

reg [31:0]PC /* verilator public */;
reg [31:0]Instruction /* verilator public */;

always @(posedge clock) begin
    if(reset) begin
        state <= `CoreStateInit;
        cCommand <= `MemoryInterfaceCommandNOP;
    end else begin
        if(state == `CoreStateInit) begin
            PC <= 'h800;
            cCommand <= `MemoryInterfaceCommandNOP;
            state <= `CoreStateFetch;
        end else if(state == `CoreStateFetch) begin
            if(cCommand == `MemoryInterfaceCommandNOP) begin
                if(hReady == 1) begin
                    cAddress <= PC;
                    cCommand <= `MemoryInterfaceCommandReadWord;
                end
            end else if(cCommand == `MemoryInterfaceCommandReadWord) begin
                if(hReady == 1) begin
                    Instruction <= hData;
                    cCommand <= `MemoryInterfaceCommandNOP;
                    state <= `CoreStateStall;
                end
            end
        end else if(state == `CoreStateExecute) begin
        
        end else if(state == `CoreStateReadWriteHandle) begin
        
        end else if(state == `CoreStateTrapHandle) begin
        
        end else if(state == `CoreStateStall) begin
        
        end
        
        tickCount <= state == `CoreStateInit ? 0 : tickCount + 1;
    end
end

endmodule
