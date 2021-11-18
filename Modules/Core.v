//  Core.v
//
//  Created by Elisa Silva on 14/10/21.
//  Copyright © 2021 Uhura. All rights reserved.

`define CoreStateInit            'd0
`define CoreStateFetch           'd1
`define CoreStateExecute         'd2
`define CoreStateReadWriteHandle 'd3
`define CoreStateTrapHandle      'd4
`define CoreStateStall           'd5

`include "MemoryInterface.v"
`include "InstructionFetch.v"
`include "ALU.v"
`include "Registers.v"

module Core(
    cCommand,
    cAddress,
    cData,
    hReady,
    hSignal,
    hData,
    reset,
    clock
);

// Memory Interface Client
output reg  [2:0]cCommand;
output reg [31:0]cAddress;
output     [31:0]cData;

// Memory Interface Host
input       hReady;
input       hSignal;
input [31:0]hData;

// Shared signals
input reset;
input clock;

// Core Context
reg [2:0]state /* verilator public */;
reg [63:0]tickCount;

reg [31:0]PC /* verilator public */;
reg [31:0]Instruction /* verilator public */;
reg [31:0]oldPC;
wire [31:0]altPC;

assign altPC = oldPC + immediate;

// Control Bits
reg writeBack;
reg addImmToALUB;
reg addPCToALUA;
reg branchToAltPC;
reg jumpToReg2Imm;
reg jumpToAltIfAluIsTrue;
reg jumpToAltIfAluIsFalse;
reg const4ReplacesAluB;
reg PCReplacesReg2;
// TODO improve this
reg LCSet;
// Load Compute Write State Control bits
reg LCWLoad;
reg [1:0]LCWLoadWidth;
reg LCWLoadUnsigned;
reg [4:0]LCWLoadTarget;
reg LCWLoadWriteBackFromTemp;
reg [31:0]LCWLoadTemp;

ALU alu(
    .a(alu_a),
    .b(alu_b),
    .funct3(alu_funct3),
    .funct7_5b(alu_funct7_5b),
    .out()
);

wire [31:0]alu_a;
wire [31:0]alu_b;
wire [31:0]reg2Imm;
reg [2:0]alu_funct3;
reg alu_funct7_5b;
wire aluBool;

assign alu_a = (addPCToALUA ? oldPC : 0) + registers.hReg1Data;
assign alu_b = const4ReplacesAluB ? 4 : reg2Imm;
assign aluBool = !(alu.out == 0);

assign reg2Imm = (addImmToALUB ? immediate : 0) + (PCReplacesReg2 ? oldPC : registers.hReg2Data);

Registers registers(
    .cReg1Address(reg1Address),
    .cReg2Address(reg2Address),
    .cRegDAddress(writeBack ? destinationRegister : 5'b0),
    .cRegDData(LCWLoadWriteBackFromTemp ? LCWLoadTemp : alu.out),
    .hReg1Data(),
    .hReg2Data(),
    .reset(reset),
    .clock(clock)
);

reg [4:0]reg1Address;
reg [4:0]reg2Address;
reg [4:0]destinationRegister;

// wire [31:0]destinationData;
// assign destinationData = alu.out;

// Instruction decoding
wire [31:0]immediate;
wire [6:0]opcode;
wire [4:0]rs1;
wire [4:0]rs2;
wire [4:0]rd;
wire [2:0]funct3;
wire [6:0]funct7;
wire [4:0]shamt;
wire [6:0]nshamt;
wire      isCompressed;

assign immediate = IFDecodeImmediate(Instruction, IFDecodeType(Instruction));
assign opcode = Instruction[6:0];
assign rs1 = Instruction[19:15];
assign rs2 = Instruction[24:20];
assign rd = Instruction[11:7];
assign funct3 = Instruction[14:12];
assign funct7 = Instruction[31:25];
assign shamt = Instruction[24:20];
assign nshamt = Instruction[31:25];
assign isCompressed = Instruction[1:0] != 'b11;

// Debug helpers
// This holds a 1cycle delay of the state to help debugging
// as the cycle the state changes is only reflected in the next cycle;
reg [2:0]effectiveState;

always @(posedge clock) begin
    writeBack <= 0;
    addImmToALUB <= 0;
    addPCToALUA <= 0;
    oldPC <= PC;
    effectiveState <= state;
    const4ReplacesAluB <= 0;
    jumpToReg2Imm <= 0;
    PCReplacesReg2 <= 0;
    jumpToAltIfAluIsTrue <= 0;
    jumpToAltIfAluIsFalse <= 0;
    LCWLoadWriteBackFromTemp <= 0;
    
// ----- RESET --------------------------------------------------
    if(reset) begin
        state <= `CoreStateInit;
        cCommand <= `MemoryInterfaceCommandNOP;
    end else begin

// ----- INIT ---------------------------------------------------
        if(state == `CoreStateInit) begin
            PC <= 'h800;
            cCommand <= `MemoryInterfaceCommandNOP;
            state <= `CoreStateFetch;
            LCSet <= 0;
            LCWLoad <= 0;

// ----- FETCH --------------------------------------------------
        end else if(state == `CoreStateFetch) begin
            if(cCommand == `MemoryInterfaceCommandNOP) begin
                if(hReady == 1) begin
                    if(jumpToReg2Imm) begin
                        PC <= reg2Imm;
                        cAddress <= reg2Imm;
                    end else if(jumpToAltIfAluIsTrue) begin
                        PC <= aluBool ? altPC : PC;
                        cAddress <= aluBool ? altPC : PC;
                    end else if(jumpToAltIfAluIsFalse) begin
                        PC <= aluBool ? PC : altPC;
                        cAddress <= aluBool ? PC : altPC;
                    end else begin
                        cAddress <= PC;
                    end
                    cCommand <= `MemoryInterfaceCommandReadWord;
                end
            end else if(cCommand == `MemoryInterfaceCommandReadWord) begin
                if(hReady == 1) begin
                    Instruction <= hData;
                    cCommand <= `MemoryInterfaceCommandNOP;
                    state <= `CoreStateExecute;
                end
            end

// ----- EXECUTE ------------------------------------------------
        end else if(state == `CoreStateExecute) begin
            if(isCompressed) begin
                // TODO: Handle compressed instructions
                state <= `CoreStateStall;
            end else begin
                case(opcode)
                
                // --- LUI --------------------------------------
                    `InstructionFetchOPLUI: begin
                        writeBack <= 1;
                        addImmToALUB <= 1;
                        
                        destinationRegister <= rd;
                        reg1Address <= 0;
                        reg2Address <= 0;
                        
                        alu_funct3 <= `InstructionFetchF3ADD;
                        alu_funct7_5b <= `InstructionFetchF7ADD;
                        
                        PC <= PC + 4;
                        
                        state <= `CoreStateFetch;
                    end
                
                // --- AUIPC ------------------------------------
                    `InstructionFetchOPAUIPC: begin
                        writeBack <= 1;
                        addImmToALUB <= 1;
                        addPCToALUA <= 1;
                        
                        destinationRegister <= rd;
                        reg1Address <= 0;
                        reg2Address <= 0;
                        
                        alu_funct3 <= `InstructionFetchF3ADD;
                        alu_funct7_5b <= `InstructionFetchF7ADD;
                        
                        PC <= PC + 4;
                        
                        state <= `CoreStateFetch;
                    end
                
                // --- OPIMM -------------------------------------
                    `InstructionFetchOPOPIMM: begin
                        if((funct3 == 3'b001 && nshamt != 0) ||
                         (funct3 == 3'b101 && (nshamt != 0 && nshamt != 32))) begin
                         
                         //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                         // TODO: Add exception for bad instruction
                         //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                         
                            state <= `CoreStateStall;
                            
                        end else begin
                            writeBack <= 1;
                            addImmToALUB <= 1;
                            addPCToALUA <= 0;
                            
                            destinationRegister <= rd;
                            reg1Address <= rs1;
                            reg2Address <= 0;
                            
                            alu_funct3 <= funct3;
                            alu_funct7_5b <= funct3[1:0] == 2'b01 ? nshamt[5] : 0;
                            
                            PC <= PC + 4;
                        
                            state <= `CoreStateFetch;
                        end
                    end
                    
                // --- OP ----------------------------------------
                    `InstructionFetchOPOP: begin
                        if(funct7 != 0 &&
                            !(funct7 == 32 &&
                                (funct3 == `InstructionFetchF3ADDSUB
                                 || funct3 == `InstructionFetchF3SRLSRA)))
                        begin
                         
                         //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                         // TODO: Add exception for bad instruction
                         //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                         
                            state <= `CoreStateStall;
                            
                        end else begin
                            writeBack <= 1;
                            addImmToALUB <= 0;
                            addPCToALUA <= 0;
                            
                            destinationRegister <= rd;
                            reg1Address <= rs1;
                            reg2Address <= rs2;
                            
                            alu_funct3 <= funct3;
                            alu_funct7_5b <= funct7[5];
                            
                            PC <= PC + 4;
                        
                            state <= `CoreStateFetch;
                        end
                    end
                    
                // --- JAL ---------------------------------------
                    `InstructionFetchOPJAL: begin
                        writeBack <= 1;
                        addImmToALUB <= 1;
                        addPCToALUA <= 1;
                        const4ReplacesAluB <= 1;
                        jumpToReg2Imm <= 1;
                        PCReplacesReg2 <= 1;
                        
                        destinationRegister <= rd;
                        reg1Address <= 0;
                        reg2Address <= 0;
                        
                        alu_funct3 <= `InstructionFetchF3ADD;
                        alu_funct7_5b <= `InstructionFetchF7ADD;
                    
                        state <= `CoreStateFetch;
                    end
                    
                // --- JALR --------------------------------------
                    `InstructionFetchOPJALR: begin
                        if(funct3 != 3'b000) begin
                         
                         //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                         // TODO: Add exception for bad instruction
                         //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                         
                            state <= `CoreStateStall;
                            
                        end else begin
                            writeBack <= 1;
                            addImmToALUB <= 1;
                            addPCToALUA <= 1;
                            const4ReplacesAluB <= 1;
                            jumpToReg2Imm <= 1;
                            PCReplacesReg2 <= 0;
                            
                            destinationRegister <= rd;
                            reg1Address <= 0;
                            reg2Address <= rs1;
                            
                            alu_funct3 <= `InstructionFetchF3ADD;
                            alu_funct7_5b <= `InstructionFetchF7ADD;
                        
                            state <= `CoreStateFetch;
                        end
                    end
                    
                // --- BRANCH -------------------------------------
                    `InstructionFetchOPBRANCH: begin
                        PC <= PC + 4;
                        state <= `CoreStateFetch;
                        
                        case(funct3)
                        `InstructionFetchF3BEQ: begin
                            jumpToAltIfAluIsTrue <= 0;
                            jumpToAltIfAluIsFalse <= 1;
                            
                            reg1Address <= rs1;
                            reg2Address <= rs2;
                            
                            
                            alu_funct3 <= `InstructionFetchF3XOR;
                            alu_funct7_5b <= 0;
                        end
                        
                        `InstructionFetchF3BNE: begin
                            jumpToAltIfAluIsTrue <= 1;
                            jumpToAltIfAluIsFalse <= 0;
                            
                            reg1Address <= rs1;
                            reg2Address <= rs2;
                            
                            
                            alu_funct3 <= `InstructionFetchF3XOR;
                            alu_funct7_5b <= 0;
                        end
                        
                        `InstructionFetchF3BLT: begin
                            jumpToAltIfAluIsTrue <= 1;
                            jumpToAltIfAluIsFalse <= 0;
                            
                            reg1Address <= rs1;
                            reg2Address <= rs2;
                            
                            
                            alu_funct3 <= `InstructionFetchF3SLT;
                            alu_funct7_5b <= 0;
                        end
                        
                        `InstructionFetchF3BGE: begin
                            jumpToAltIfAluIsTrue <= 1;
                            jumpToAltIfAluIsFalse <= 0;
                            
                            reg1Address <= rs1;
                            reg2Address <= rs2;
                            
                            
                            alu_funct3 <= `InstructionFetchF3SLT;
                            alu_funct7_5b <= 1;
                        end
                        
                        `InstructionFetchF3BLTU: begin
                            jumpToAltIfAluIsTrue <= 1;
                            jumpToAltIfAluIsFalse <= 0;
                            
                            reg1Address <= rs1;
                            reg2Address <= rs2;
                            
                            
                            alu_funct3 <= `InstructionFetchF3SLTU;
                            alu_funct7_5b <= 0;
                        end
                        
                        `InstructionFetchF3BGEU: begin
                            jumpToAltIfAluIsTrue <= 1;
                            jumpToAltIfAluIsFalse <= 0;
                            
                            reg1Address <= rs1;
                            reg2Address <= rs2;
                            
                            
                            alu_funct3 <= `InstructionFetchF3SLTU;
                            alu_funct7_5b <= 1;
                        end
                        
                        default: begin
                         //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                         // TODO: Add exception for bad instruction
                         //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                         
                            state <= `CoreStateStall;
                        
                        end
                        endcase
                    end
                    
                
                // --- LOAD ----------------------------------------
                    `InstructionFetchOPLOAD: begin
                        if(funct3[2:1] == 2'b11 || funct3[1:0] == 2'b11) begin
                         //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                         // TODO: Add exception for bad instruction
                         //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

                            state <= `CoreStateStall;
                            
                        end else begin
                            LCWLoad <= 1;
                            LCWLoadWidth <= funct3[1:0] + 1'b01;
                            LCWLoadUnsigned <= funct3[2];
                            LCWLoadTarget <= rd;

                            addImmToALUB <= 1;
                            
                            reg1Address <= rs1;
                            reg2Address <= 0;

                            alu_funct3 <= `InstructionFetchF3ADD;
                            alu_funct7_5b <= `InstructionFetchF7ADD;
                        
                            state <= `CoreStateReadWriteHandle;
                        end
                    
                        
                    end
                    
                // --- DEFAULT -----------------------------------
                    default: begin
                        state <= `CoreStateStall;
                    end
                endcase
            end
            
// ----- READ WRITE ---------------------------------------------
        end else if(state == `CoreStateReadWriteHandle) begin
            if(LCWLoad) begin
                if(cCommand == `MemoryInterfaceCommandNOP) begin
                    if(hReady == 1) begin
                        cCommand <= { 1'b0, LCWLoadWidth };
                        cAddress <= alu.out;
                    end 
                end else if(hReady == 1) begin
                    destinationRegister <= LCWLoadTarget;
                    writeBack <= 1;

                    LCWLoadTemp <= 
                        (LCWLoadWidth == 'b01) ? {{24{LCWLoadUnsigned ? 1'b0 : hData[7]}}, hData[7:0]} :
                        (LCWLoadWidth == 'b10) ? {{16{LCWLoadUnsigned ? 1'b0 : hData[15]}}, hData[15:0]} :
                     /* (LCWLoadWidth == 'b11) */ hData;

                    LCWLoadWriteBackFromTemp <= 1;
                    LCWLoad <= 0;
                    
                    cCommand <= `MemoryInterfaceCommandNOP;

                    PC <= PC + 4;
                    state <= `CoreStateFetch;
                end
            end
// ----- TRAP ---------------------------------------------------
        end else if(state == `CoreStateTrapHandle) begin
            
// ----- STALL --------------------------------------------------
        end else if(state == `CoreStateStall) begin
        
        end
        
        tickCount <= state == `CoreStateInit ? 0 : tickCount + 1;
    end
end

endmodule
