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

reg [3:0]previousCommand;

always @(posedge clock) begin
    if(reset) begin
        hReady = 0;
        hSignal = 0;
        hData = 0;
        previousCommand = `MemoryInterfaceCommandNOP;
    end
    if(cCommand != previousCommand) begin
        previousCommand = cCommand;
        casez(cCommand)
        4`MemoryInterfaceCommandNOP: begin end
        4`MemoryInterfaceCommandHAW: begin end
        4`MemoryInterfaceCommandRB: begin end
        4`MemoryInterfaceCommandRS: begin end
        4`MemoryInterfaceCommandRW: begin end
        4`MemoryInterfaceCommandDR: begin end
        4`MemoryInterfaceCommandWB: begin end
        4`MemoryInterfaceCommandWS: begin end
        4`MemoryInterfaceCommandWW: begin end
        endcase;
    end else begin
        casez(cCommand)
        4`MemoryInterfaceCommandNOP: begin end
        4`MemoryInterfaceCommandHAW: begin end
        4`MemoryInterfaceCommandRB: begin end
        4`MemoryInterfaceCommandRS: begin end
        4`MemoryInterfaceCommandRW: begin end
        4`MemoryInterfaceCommandDR: begin end
        4`MemoryInterfaceCommandWB: begin end
        4`MemoryInterfaceCommandWS: begin end
        4`MemoryInterfaceCommandWW: begin end
        endcase;
    end
end


endmodule
