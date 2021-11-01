//  SoftMemory.v
//
//  Created by Elisa Silva on 08/10/21.
//  Copyright © 2021 Uhura. All rights reserved.

`include "MemoryInterface.v"
`include "ModuleDispatch.v"

module SoftMemory(
    cCommand,
    cAddress,
    cData,
    hReady,
    hSignal,
    hData,
    reset,
    clock
);

input  [2:0]cCommand;
input [31:0]cAddress;
input [31:0]cData;
output reg       hReady;
output reg       hSignal;
output reg [31:0]hData;
input reset;
input clock;

reg [31:0]ID /* verilator public */;
reg [31:0]counter;
reg [2:0]previousCommand;

wire [31:0]wideCommand;
assign wideCommand = {29'b0, cCommand};

always @(posedge clock) begin
    if(reset) begin
        hReady <= 1;
        hSignal <= 0;
        hData <= 0;
        counter <= 0;
        previousCommand <= `MemoryInterfaceCommandNOP;
    end else if(cCommand == `MemoryInterfaceCommandNOP) begin
        hReady <= 1;
        counter <= 0;
        previousCommand <= cCommand;
    end else if(cCommand != `MemoryInterfaceCommandNOP) begin
        if(previousCommand == `MemoryInterfaceCommandNOP) begin
            counter <= UHRModuleDispatch(ID, `DispatchMemoryInterfaceGetDelayFor, wideCommand, cAddress, cData);
            if(UHRModuleDispatch(ID, `DispatchMemoryInterfaceGetDelayFor, wideCommand, cAddress, cData) == 0) begin
                hData <= UHRModuleDispatch(ID, `DispatchMemoryInterfaceDoOperation, wideCommand, cAddress, cData);
                hReady <= 1;
            end else begin
                hReady <= 0;
            end
        end else begin
            if(counter == 1) begin
                hData <= UHRModuleDispatch(ID, `DispatchMemoryInterfaceDoOperation, wideCommand, cAddress, cData);
                hReady <= 1;
            end
            counter <= counter == 0 ? 0 : counter - 1;
        end
        previousCommand <= cCommand;
    end
end


endmodule
