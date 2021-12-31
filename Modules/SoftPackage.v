//  SoftPackage.v
//
//  Created by Elisa Silva on 14/10/21.
//  Copyright © 2021 Uhura. All rights reserved.

`include "Core.v"
`include "SoftMemory.v"

module SoftPackage(
    reset,
    clock
);

input clock;
input reset;

wire  [2:0]cCommand /* verilator public */;
wire [31:0]cAddress /* verilator public */;
wire [31:0]cData    /* verilator public */;
wire       hReady   /* verilator public */;
wire       hSignal  /* verilator public */;
wire [31:0]hData    /* verilator public */;


Core core(
    .cCommand(cCommand),
    .cAddress(cAddress),
    .cData(cData),
    .hReady(hReady),
    .hSignal(hSignal),
    .hData(hData),
    .reset(reset),
    .clock(clock)
);

SoftMemory memory(
    .cCommand(cCommand),
    .cAddress(cAddress),
    .cData(cData),
    .hReady(hReady),
    .hSignal(hSignal),
    .hData(hData),
    .reset(reset),
    .clock(clock)
);


endmodule;
