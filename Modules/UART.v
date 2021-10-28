//  UART.v
//
//  Created by Elisa Silva on 26/10/21.
//  Copyright © 2021 Uhura. All rights reserved.

`include "FIFO.v"

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

parameter CLOCK = 50_000_000;
parameter BAUD = 9_600;
localparam PERIOD = CLOCK/BAUD;
localparam PERIODWIDTH = $clog2(PERIOD);

reg [9:0]transmissionByte;
reg [PERIODWIDTH-1:0]count;
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
                transmissionByte <= {1'1, cByte, 1'0};
                state <= 10;
                count <= PERIODWIDTH'(PERIOD - 1);
            end
        end else begin
            if(count == 0) begin
                state <= state - 1;
                count <= PERIODWIDTH'(PERIOD - 1);
                transmissionByte <= {1'1, transmissionByte[9:1]};
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
output reg      hRead;
input rx;
input reset;
input clock;

parameter CLOCK = 50_000_000;
parameter BAUD = 9_600;
localparam PERIOD = CLOCK/BAUD;
localparam PERIODWIDTH = $clog2(PERIOD);
localparam HALF_PERIOD = PERIOD/2;

reg [PERIODWIDTH-1:0]count;
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
                count <= PERIODWIDTH'(HALF_PERIOD - 1);
            end
        end else if(state > 0) begin
            if(count == 0) begin
                if(state == 1) begin
                    read <= 1;
                end
                rxByte <= {rx, rxByte[8:1]};
                count <= PERIODWIDTH'(PERIOD - 1);
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

parameter CLOCK = 50_000_000;
parameter BAUD = 9_600;

wire [7:0]rxByte;
wire rxRead;
wire popToTX;
reg writeToTX;

UART_RX #(
    .CLOCK(CLOCK),
    .BAUD(BAUD)
) _rx(
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
    .hByte(),
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

UART_TX #(
    .CLOCK(CLOCK),
    .BAUD(BAUD)
) _tx(
    .cByte(txFIFO.hByte),
    .cWrite(writeToTX),
    .hCanWrite(),
    .tx(tx),
    .reset(reset),
    .clock(clock)
);

assign hByte = rxFIFO.hByte;
assign hCanRead = !rxFIFO.hEmpty;
assign hCanWrite = !txFIFO.hFull;

assign popToTX = !txFIFO.hEmpty && _tx.hCanWrite && !writeToTX;

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
