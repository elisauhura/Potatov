//  UART.v
//
//  Created by Elisa Silva on 26/10/21.
//  Copyright © 2021 Uhura. All rights reserved.

`include "FIFO.v"

`define CLOCK 50_000_000
`define BAUD 9_600
`define PERIOD 5_208
`define HALF_PERIOD 2_604
`define PERIODWIDTH 13

module UART_TX(
    cByte,
    cWrite,
    hCanWrite,
    tx,
    reset,
    clock
);

input [7:0]cByte;
input      cWrite;
output hCanWrite;
output tx;
input reset;
input clock;

reg [9:0]transmissionByte;
reg [`PERIODWIDTH-1:0]count;
reg [3:0]state;

assign hCanWrite = state == 0;
assign tx = state == 0 ? 1 : transmissionByte[0];

always @(posedge clock) begin
    if(reset) begin
        state <= 0;
        transmissionByte <= 1;
    end else begin
        if(state == 0) begin
            if(cWrite) begin
                transmissionByte <= {1'b1, cByte, 1'b0};
                state <= 10;
                count <= (`PERIOD - 1);
            end
        end else begin
            if(count == 0) begin
                state <= state - 1;
                count <= (`PERIOD - 1);
                transmissionByte <= {1'b1, transmissionByte[9:1]};
            end else begin
                count <= count - 1;
            end
        end
    end
end

endmodule

module UART_RX(
    hByte,
    hRead,
    rx,
    reset,
    clock
);

output [7:0]hByte;
output      hRead;
input rx;
input reset;
input clock;

reg [`PERIODWIDTH-1:0]count;
reg [3:0]state;
reg [8:0]rxByte;
reg      read;
reg [7:0]readBuffer;

assign hByte = rxByte[7:0];
assign hRead = read;

always @(posedge clock) begin
    readBuffer <= {readBuffer[6:0], !rx};
    if(reset) begin
        state <= 0;
        read <= 0;
    end else begin
        if(state == 0) begin
            read <= 0;
            if(readBuffer == 8'b11111111) begin
                state <= 10;
                count <= (`HALF_PERIOD - 1);
            end
        end else if(state > 0) begin
            if(count == 0) begin
                if(state == 1) begin
                    read <= 1;
                end
                rxByte <= {rx, rxByte[8:1]};
                count <= (`PERIOD - 1);
                state <= state - 1;
            end else begin
                count <= count - 1;
            end
        end
    end
end

endmodule

module UART(
    cByte,
    cRead,
    cWrite,
    hByte,
    hCanRead,
    hCanWrite,
    tx,
    rx,
    reset,
    clock
);

input [7:0]cByte;
input      cRead;
input      cWrite;
output [7:0]hByte;
output      hCanRead;
output      hCanWrite;
output tx;
input rx;
input reset;
input clock;

wire [7:0]rxByte;
wire rxRead;
wire popToTX;
reg writeToTX;

UART_RX _rx(
    .hByte(rxByte),
    .hRead(rxRead),
    .rx(rx),
    .reset(reset),
    .clock(clock)
);

FIFO rxFIFO(
    .cByte(rxByte),
    .cPush(rxRead),
    .cPop(cRead),
    .hByte(hByte),
    .hFull(),
    .hEmpty(),
    .reset(reset),
    .clock(clock)
);

FIFO txFIFO(
    .cByte(cByte),
    .cPush(cWrite),
    .cPop(popToTX),
    .hByte(),
    .hFull(),
    .hEmpty(),
    .reset(reset),
    .clock(clock)
);

UART_TX _tx(
    .cByte(txFIFO.hByte),
    .cWrite(writeToTX),
    .hCanWrite(),
    .tx(tx),
    .reset(reset),
    .clock(clock)
);

assign hCanRead = !rxFIFO.hEmpty;
assign hCanWrite = !txFIFO.hFull;

assign popToTX = _tx.hCanWrite && !txFIFO.hEmpty && !writeToTX;

always @(posedge clock) begin
    if(reset) begin
        writeToTX <= 0;
    end else begin
        if(popToTX) begin
            writeToTX <= 1;
        end else begin
            writeToTX <= 0;
        end
    end
end

endmodule
