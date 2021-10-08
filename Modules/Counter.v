//  Counter.v
//
//  Created by Elisa Silva on 07/10/21.
//  Copyright © 2021 Uhura. All rights reserved.

module Counter(
    counter,
    reset,
    clock
);

output reg [31:0]counter;
input reset;
input clock;

always @(posedge clock) counter = reset ? 0 : counter + 1;

endmodule
