//  Registers.v
//
//  Created by Elisa Silva on 14/10/21.
//  Copyright © 2021 Uhura. All rights reserved.

module Registers(
    cReg1Address,
    cReg2Address,
    cRegDAddress,
    cRegDData,
    hReg1Data,
    hReg2Data,
    reset,
    clock
);
input  [4:0]cReg1Address;
input  [4:0]cReg2Address;
input  [4:0]cRegDAddress;
input [31:0]cRegDData;
output [31:0]hReg1Data;
output [31:0]hReg2Data;
input reset;
input clock;

reg [31:0]registers[31:1] /* verilator public */;

always @(posedge clock) begin
    int i;
    if(reset)
        for(i=1; i<=32; i++) registers[i] = 0;
    if(cRegDAddress != 0) registers[cRegDAddress] = cRegDData;
end

assign hReg1Data = cReg1Address != 0 ? registers[cReg1Address] : 0;
assign hReg2Data = cReg2Address != 0 ? registers[cReg2Address] : 0;

endmodule
