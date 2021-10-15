//  InstructionFetch.v
//
//  Created by Elisa Silva on 14/10/21.
//  Copyright © 2021 Uhura. All rights reserved.

`ifndef INSTRUCTION_FETCH_V
`define INSTRUCTION_FETCH_V

`define InstructionFetchTypeR          'd0
`define InstructionFetchTypeI          'd1
`define InstructionFetchTypeS          'd2
`define InstructionFetchTypeB          'd3
`define InstructionFetchTypeU          'd4
`define InstructionFetchTypeJ          'd5
`define InstructionFetchTypeR4         'd6
`define InstructionFetchTypeCR         'd7
`define InstructionFetchTypeCI         'd8
`define InstructionFetchTypeCSS        'd9
`define InstructionFetchTypeCIW        'd10
`define InstructionFetchTypeCL         'd11
`define InstructionFetchTypeCS         'd12
`define InstructionFetchTypeCA         'd13
`define InstructionFetchTypeCB         'd14
`define InstructionFetchTypeCJ         'd15

`define InstructionFetchF3ADD          'd0
`define InstructionFetchF3SUB          'd0
`define InstructionFetchF3ADDI         'd0
`define InstructionFetchF3SRLSRA       'd3

`define InstructionFetchF7ADD          'd0
`define InstructionFetchF7SUB          'd32
`define InstructionFetchF7SRL          'd0
`define InstructionFetchF7SRA          'd32


`define InstructionFetchOPLOAD         'b0000011
`define InstructionFetchOPFENCE        'b0001111
`define InstructionFetchOPOPIMM        'b0010011
`define InstructionFetchOPAUIPC        'b0010111
`define InstructionFetchOPSTORE        'b0100011
`define InstructionFetchOPOP           'b0110011
`define InstructionFetchOPLUI          'b0110111
`define InstructionFetchOPBRANCH       'b1100011
`define InstructionFetchOPJALR         'b1100111
`define InstructionFetchOPJAL          'b1101111
`define InstructionFetchOPJAL_JALR     'b110?111
`define InstructionFetchOPSYSTEM       'b1110011


function [3:0]IFDecodeType([31:0]instruction);
case(instruction[6:0])
    7'b0110111: IFDecodeType = `InstructionFetchTypeU;
    7'b0010111: IFDecodeType = `InstructionFetchTypeU;
    7'b1101111: IFDecodeType = `InstructionFetchTypeJ;
    7'b1100111: IFDecodeType = `InstructionFetchTypeI;
    7'b1100011: IFDecodeType = `InstructionFetchTypeB;
    7'b0000011: IFDecodeType = `InstructionFetchTypeI;
    7'b0100011: IFDecodeType = `InstructionFetchTypeS;
    7'b0010011: IFDecodeType = `InstructionFetchTypeI;
    7'b0110011: IFDecodeType = `InstructionFetchTypeR;
    7'b0001111: IFDecodeType = `InstructionFetchTypeI;
    7'b1110011: IFDecodeType = `InstructionFetchTypeI;
    default: IFDecodeType = `InstructionFetchTypeR;
endcase
endfunction

function [31:0]IFDecodeImmediate([31:0]instruction, [3:0]instructionType);
case(instructionType)
    `InstructionFetchTypeI:IFDecodeImmediate = {{21{instruction[31]}}, instruction[30:20]};
    `InstructionFetchTypeS:IFDecodeImmediate = {{21{instruction[31]}}, instruction[30:25], instruction[11:7]};
    `InstructionFetchTypeB:IFDecodeImmediate = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
    `InstructionFetchTypeU:IFDecodeImmediate = {instruction[31:12],12'b0};
    `InstructionFetchTypeJ:IFDecodeImmediate = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
    default: IFDecodeImmediate = 0;
endcase
endfunction

`endif
