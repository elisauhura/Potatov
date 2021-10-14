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

input  [3:0]cCommand;
input [31:0]cAddress;
input [31:0]cData;
output reg       hReady;
output reg       hSignal;
output reg [31:0]hData;
input reset;
input clock;

reg [31:0]ID /* verilator public */;
reg [31:0]counter;
reg [3:0]previousCommand;

wire [31:0]wideCommand;
assign wideCommand = {28'b0, cCommand};

always @(posedge clock) begin
    integer delay;
    
    if(reset) begin
        hReady = 0;
        hSignal = 0;
        hData = 0;
        counter = 0;
        previousCommand = `MemoryInterfaceCommandNOP;
    end
    if(cCommand != previousCommand) begin
        previousCommand = cCommand;
        delay = UHRModuleDispatch(ID, `DispatchMemoryInterfaceGetDelayFor, wideCommand, cAddress, cData);
        if(delay == 0) begin
            hReady = 1;
            hData = UHRModuleDispatch(ID, `DispatchMemoryInterfaceDoOperation, wideCommand, cAddress, cData);
        end else begin
            counter = delay;
            hReady = 0;
        end
    end else begin
        if(counter > 0) begin
            if(counter == 1) begin
                hReady = 1;
                hData = UHRModuleDispatch(ID, `DispatchMemoryInterfaceDoOperation, wideCommand, cAddress, cData);
            end 
            counter = counter - 1;
        end
    end
end


endmodule
