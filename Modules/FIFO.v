//  FIFO.v
//
//  Created by Elisa Silva on 26/10/21.
//  Copyright © 2021 Uhura. All rights reserved.

module FIFO(
    cByte,
    cPush,
    cPop,
    hByte,
    hFull,
    hEmpty,
    reset,
    clock
);

// client
input [7:0]cByte;
input      cPush;
input      cPop;

// host
output reg [7:0]hByte;
output          hFull;
output          hEmpty;

// shared
input reset;
input clock;

// Requirements
// FIFOSize must be a power of 2

parameter FIFOSize = 8;
localparam FIFOWidth = $clog2(FIFOSize);

reg [7:0]buffer[FIFOSize-1:0];
reg [FIFOWidth-1:0]readHead;
reg [FIFOWidth-1:0]writeHead;
wire [FIFOWidth-1:0]writeHeadNext;
reg full;

assign hFull = full;
assign hEmpty = readHead == writeHead && !full;
assign writeHeadNext = writeHead + 1;

always @(posedge clock) begin
    if(reset) begin
        readHead <= 0;
        writeHead <= 0;
        full <= 0;
    end else begin
        if(cPop && cPush) begin
            hByte <= (hEmpty) ?
                cByte : buffer[readHead];
            readHead <= readHead + 1;
            buffer[writeHead] <= cByte;
            writeHead <= writeHeadNext;
        end else if(cPop) begin
            if(writeHead != readHead || full) begin
                hByte <= buffer[readHead];
                readHead <= readHead + 1;
                full <= 0;
            end
        end else if(cPush) begin
            if(!full) begin
                buffer[writeHead] <= cByte;
                full <= writeHeadNext == readHead;
                writeHead <= writeHeadNext;
            end
        end
    end
end

endmodule
