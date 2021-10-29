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

wire [7:0]byte;
reg write;
reg read;

UART uart(
    .cByte(byte),
    .cRead(read),
    .cWrite(write),
    .hByte(),
    .hCanRead(),
    .hCanWrite(),
    .tx(tx),
    .rx(rx),
    .reset(reset == 0),
    .clock(clock)
);

always @(posedge clock) begin
    if(uart.hCanRead) begin
        read <= 1;
    end
    if(read == 1) begin
        read <= 0;
        write <= 1;
    end
    if(write == 1) begin
        write <= 0;
    end
end

assign byte = (uart.hByte >= 'd97 && uart.hByte <= 'd122) ? uart.hByte - 'd32 : uart.hByte;

endmodule
