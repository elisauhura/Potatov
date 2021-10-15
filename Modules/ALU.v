//  ALU.v
//
//  Created by Elisa Silva on 14/10/21.
//  Copyright © 2021 Uhura. All rights reserved.

module ALU(
    a,
    b,
    funct3,
    funct7_5b,
    out
);

input [31:0]a;
input [31:0]b;
input [2:0]funct3;
input      funct7_5b;
output [31:0]out;

assign out = 
    (funct3 == 3'b000) ? (funct7_5b ? a - b : a + b) : // SUB : ADD
    (funct3 == 3'b001) ? (a << b[4:0]) : // SLL (shift left logical)
    (funct3 == 3'b010) ? ($signed(a) < $signed(b) ? 1 : 0) : // SLT (set less than [signed])
    (funct3 == 3'b011) ? (a < b ? 1 : 0) : // SLTU (set less than unsigned)
    (funct3 == 3'b100) ? (a ^ b) : // XOR
    (funct3 == 3'b101) ? (funct7_5b ? $signed($signed(a) >>> b[4:0]) : a >> b[4:0]) : // SRA : SRL
    (funct3 == 3'b110) ? (a | b) : // OR
 /* (funct3 == 3'b111) */ (a & b); // AND

endmodule
