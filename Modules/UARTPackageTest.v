//  UARTPackageTest.v
//
//  Created by Elisa Silva on 28/10/21.
//  Copyright © 2021 Uhura. All rights reserved.

`include "UART.v"

module UARTPackageTest(
    tx,
    rx,
    reset,
    clock
);

output tx;
input rx;
input reset;
input clock;

reg [7:0]byte;
reg write;
reg read;

UART uart(
    .cByte(byte),
    .cRead(),
    .cWrite(write),
    .hByte(),
    .hCanRead(),
    .hCanWrite(),
    .tx(tx),
    .rx(rx),
    .reset(reset),
    .clock(clock)
);

always @(posedge clock) begin
    if(uart.hCanRead) begin
        read <= 1;
    end
    if(read == 1) begin
        read <= 0;
        byte <= (uart.hByte > 96 && uart.hByte < 123) ? uart.hByte - 32 : uart.hByte;
        write <= 1;
    end
    if(write == 1) begin
        write <= 0;
    end
end


endmodule
