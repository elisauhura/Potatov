//
//  UHRRISCVMiniAssembler.m
//  Peeler
//
//  Created by Elisa Silva on 01/11/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import "UHRRISCVMiniAssembler.h"

typedef NS_ENUM(UHRWord, UHRRISCVOPCode) {
    UHRRISCVOPCodeLUI    = 0b0110111,
    UHRRISCVOPCodeAIUPC  = 0b0010111,
    UHRRISCVOPCodeOPIMM  = 0b0010011,
    UHRRISCVOPCodeOP     = 0b0110011,
    UHRRISCVOPCodeJAL    = 0b1101111,
    UHRRISCVOPCodeJALR   = 0b1100111,
    UHRRISCVOPCodeBRANCH = 0b1100011,
    UHRRISCVOPCodeLOAD   = 0b0000011,
    UHRRISCVOPCodeSTORE  = 0b0100011,
};

typedef NS_ENUM(UHRWord, UHRRISCVF3) {
    UHRRISCVF3ADD    = 0b000,
    UHRRISCVF3SUB    = 0b000,
    UHRRISCVF3ADDSUB = 0b000,
    UHRRISCVF3SLL    = 0b001,
    UHRRISCVF3SLT    = 0b010,
    UHRRISCVF3SLTU   = 0b011,
    UHRRISCVF3XOR    = 0b100,
    UHRRISCVF3SRL    = 0b101,
    UHRRISCVF3SRA    = 0b101,
    UHRRISCVF3SRLSRA = 0b101,
    UHRRISCVF3OR     = 0b110,
    UHRRISCVF3AND    = 0b111,
    UHRRISCVF3JALR   = 0b000,
    UHRRISCVF3BEQ    = 0b000,
    UHRRISCVF3BNE    = 0b001,
    UHRRISCVF3BLT    = 0b100,
    UHRRISCVF3BGE    = 0b101,
    UHRRISCVF3BLTU   = 0b110,
    UHRRISCVF3BGEU   = 0b111,
    UHRRISCVF3LB     = 0b000,
    UHRRISCVF3LBU    = 0b100,
    UHRRISCVF3LH     = 0b001,
    UHRRISCVF3LHU    = 0b101,
    UHRRISCVF3LW     = 0b010,
};

typedef NS_ENUM(UHRWord, UHRRISCVF7) {
    UHRRISCVF7ADD    = 0,
    UHRRISCVF7SUB    = 32,
    UHRRISCVF7SLL    = 0,
    UHRRISCVF7SLT    = 0,
    UHRRISCVF7SLTU   = 0,
    UHRRISCVF7XOR    = 0,
    UHRRISCVF7SRL    = 0,
    UHRRISCVF7SRA    = 32,
    UHRRISCVF7OR     = 0,
    UHRRISCVF7AND    = 0,
};

typedef NS_ENUM(UHRWord, UHRRISCVF7B5) {
    UHRRISCVF7B5ADD    = 0b0,
    UHRRISCVF7B5SUB    = 0b1,
    UHRRISCVF7B5SLL    = 0b0,
    UHRRISCVF7B5SRL    = 0b0,
    UHRRISCVF7B5SRA    = 0b1,
};

const unsigned int UHRRISCKVREGMASK = 0b11111;

UHRWord generateUType(UHRWord opcode, UHRWord reg, UHRWord imm) {
    UHRWord ret = imm >> 12;
    ret = (ret << 5) | (reg & UHRRISCKVREGMASK);
    ret = (ret << 7) | opcode;
    
    return ret;
}

UHRWord generateIType(UHRWord opcode, UHRWord f3, UHRWord rd, UHRWord rs1, UHRWord imm) {
    UHRWord ret = imm;
    ret = (ret << 5) | (rs1 & UHRRISCKVREGMASK);
    ret = (ret << 3) | (f3 & 0b111);
    ret = (ret << 5) | (rd & UHRRISCKVREGMASK);
    ret = (ret << 7) | opcode;
    
    return ret;
}

UHRWord generateISType(UHRWord opcode, UHRWord f3, UHRWord f7_b5, UHRWord rd, UHRWord rs1, UHRWord imm) {
    UHRWord ret = f7_b5 ? 32 : 0;
    ret = (ret << 5) | (imm & UHRRISCKVREGMASK);
    ret = (ret << 5) | (rs1 & UHRRISCKVREGMASK);
    ret = (ret << 3) | (f3 & 0b111);
    ret = (ret << 5) | (rd & UHRRISCKVREGMASK);
    ret = (ret << 7) | opcode;
    
    return ret;
}

UHRWord generateRType(UHRWord opcode, UHRWord f3, UHRWord f7, UHRWord rd, UHRWord rs1, UHRWord rs2) {
    UHRWord ret = f7;
    ret = (ret << 5) | (rs2 & UHRRISCKVREGMASK);
    ret = (ret << 5) | (rs1 & UHRRISCKVREGMASK);
    ret = (ret << 3) | (f3 & 0b111);
    ret = (ret << 5) | (rd & UHRRISCKVREGMASK);
    ret = (ret << 7) | opcode;
    
    return ret;
}

UHRWord generateJType(UHRWord opcode, UHRWord rd, UHRWord imm) {
    UHRWord ret = imm >> 20;
    ret = (ret << 10) | ((imm >> 1) & 0b1111111111);
    ret = (ret << 1) | ((imm >> 11) & 0b1);
    ret = (ret << 8) | ((imm >> 12) & 0b11111111);
    ret = (ret << 5) | (rd & UHRRISCKVREGMASK);
    ret = (ret << 7) | opcode;
    
    return ret;
}

UHRWord generateBType(UHRWord opcode, UHRWord f3, UHRWord rs1, UHRWord rs2, UHRWord imm) {
    UHRWord ret = imm >> 12;
    ret = (ret << 6) | ((imm >> 5) & 0b111111);
    ret = (ret << 5) | (rs2 & UHRRISCKVREGMASK);
    ret = (ret << 5) | (rs1 & UHRRISCKVREGMASK);
    ret = (ret << 3) | (f3 & 0b111);
    ret = (ret << 4) | ((imm >> 1) & 0b1111);
    ret = (ret << 1) | ((imm >> 11) & 0b1);
    ret = (ret << 7) | opcode;
    
    return ret;
}

@implementation UHRRISCVMiniAssembler

+ (UHRWord)luiWithRD:(UHREnum)aRegister imm:(UHRWord)aImmediate {
    return generateUType(UHRRISCVOPCodeLUI, aRegister, aImmediate);
}


+ (UHRWord)aiupcWithRD:(UHREnum)aRegister imm:(UHRWord)aImmediate {
    return generateUType(UHRRISCVOPCodeAIUPC, aRegister, aImmediate);
}

+ (UHRWord)addiWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister imm:(UHRWord)aImmediate{
    return generateIType(UHRRISCVOPCodeOPIMM, UHRRISCVF3ADD, destinationRegister, sourceRegister, aImmediate);
}

+ (UHRWord)sltiWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister imm:(UHRWord)aImmediate{
    return generateIType(UHRRISCVOPCodeOPIMM, UHRRISCVF3SLT, destinationRegister, sourceRegister, aImmediate);
}

+ (UHRWord)sltiuWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister imm:(UHRWord)aImmediate{
    return generateIType(UHRRISCVOPCodeOPIMM, UHRRISCVF3SLTU, destinationRegister, sourceRegister, aImmediate);
}

+ (UHRWord)xoriWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister imm:(UHRWord)aImmediate{
    return generateIType(UHRRISCVOPCodeOPIMM, UHRRISCVF3XOR, destinationRegister, sourceRegister, aImmediate);
}

+ (UHRWord)oriWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister imm:(UHRWord)aImmediate{
    return generateIType(UHRRISCVOPCodeOPIMM, UHRRISCVF3OR, destinationRegister, sourceRegister, aImmediate);
}

+ (UHRWord)andiWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister imm:(UHRWord)aImmediate{
    return generateIType(UHRRISCVOPCodeOPIMM, UHRRISCVF3AND, destinationRegister, sourceRegister, aImmediate);
}

+ (UHRWord)slliWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister imm:(UHRWord)aImmediate{
    return generateISType(UHRRISCVOPCodeOPIMM, UHRRISCVF3SLL, UHRRISCVF7B5ADD,destinationRegister, sourceRegister, aImmediate);
}

+ (UHRWord)srliWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister imm:(UHRWord)aImmediate{
    return generateISType(UHRRISCVOPCodeOPIMM, UHRRISCVF3SRL, UHRRISCVF7B5SRL, destinationRegister, sourceRegister, aImmediate);
}

+ (UHRWord)sraiWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister imm:(UHRWord)aImmediate{
    return generateISType(UHRRISCVOPCodeOPIMM, UHRRISCVF3SRA, UHRRISCVF7B5SRA, destinationRegister, sourceRegister, aImmediate);
}

+ (UHRWord)addWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister1 rs2:(UHREnum)sourceRegister2 {
    return generateRType(UHRRISCVOPCodeOP, UHRRISCVF3ADD, UHRRISCVF7ADD, destinationRegister, sourceRegister1, sourceRegister2);
}

+ (UHRWord)subWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister1 rs2:(UHREnum)sourceRegister2 {
    return generateRType(UHRRISCVOPCodeOP, UHRRISCVF3SUB, UHRRISCVF7SUB, destinationRegister, sourceRegister1, sourceRegister2);
}

+ (UHRWord)sllWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister1 rs2:(UHREnum)sourceRegister2 {
    return generateRType(UHRRISCVOPCodeOP, UHRRISCVF3SLL, UHRRISCVF7SLL, destinationRegister, sourceRegister1, sourceRegister2);
}

+ (UHRWord)sltWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister1 rs2:(UHREnum)sourceRegister2 {
    return generateRType(UHRRISCVOPCodeOP, UHRRISCVF3SLT, UHRRISCVF7SLT, destinationRegister, sourceRegister1, sourceRegister2);
}

+ (UHRWord)sltuWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister1 rs2:(UHREnum)sourceRegister2 {
    return generateRType(UHRRISCVOPCodeOP, UHRRISCVF3SLTU, UHRRISCVF7SLTU, destinationRegister, sourceRegister1, sourceRegister2);
}

+ (UHRWord)xorWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister1 rs2:(UHREnum)sourceRegister2 {
    return generateRType(UHRRISCVOPCodeOP, UHRRISCVF3XOR, UHRRISCVF7XOR, destinationRegister, sourceRegister1, sourceRegister2);
}

+ (UHRWord)srlWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister1 rs2:(UHREnum)sourceRegister2 {
    return generateRType(UHRRISCVOPCodeOP, UHRRISCVF3SRL, UHRRISCVF7SRL, destinationRegister, sourceRegister1, sourceRegister2);
}

+ (UHRWord)sraWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister1 rs2:(UHREnum)sourceRegister2 {
    return generateRType(UHRRISCVOPCodeOP, UHRRISCVF3SRA, UHRRISCVF7SRA, destinationRegister, sourceRegister1, sourceRegister2);
}

+ (UHRWord)orWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister1 rs2:(UHREnum)sourceRegister2 {
    return generateRType(UHRRISCVOPCodeOP, UHRRISCVF3OR, UHRRISCVF7OR, destinationRegister, sourceRegister1, sourceRegister2);
}

+ (UHRWord)andWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister1 rs2:(UHREnum)sourceRegister2 {
    return generateRType(UHRRISCVOPCodeOP, UHRRISCVF3AND, UHRRISCVF7AND, destinationRegister, sourceRegister1, sourceRegister2);
}

+ (UHRWord)jalWithRD:(UHREnum)destinationRegister imm:(UHRWord)aImmediate {
    return generateJType(UHRRISCVOPCodeJAL, destinationRegister, aImmediate);
}

+ (UHRWord)jalrWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister1 imm:(UHRWord)aImmediate {
    return generateIType(UHRRISCVOPCodeJALR, UHRRISCVF3JALR, destinationRegister, sourceRegister1, aImmediate);
}

+ (UHRWord)beqWithRS1:(UHREnum)sourceRegister1 rs2:(UHREnum)sourceRegister2 imm:(UHRWord)aImmediate {
    return generateBType(UHRRISCVOPCodeBRANCH, UHRRISCVF3BEQ, sourceRegister1, sourceRegister2, aImmediate);
}

+ (UHRWord)bneWithRS1:(UHREnum)sourceRegister1 rs2:(UHREnum)sourceRegister2 imm:(UHRWord)aImmediate {
    return generateBType(UHRRISCVOPCodeBRANCH, UHRRISCVF3BNE, sourceRegister1, sourceRegister2, aImmediate);
}

+ (UHRWord)bltWithRS1:(UHREnum)sourceRegister1 rs2:(UHREnum)sourceRegister2 imm:(UHRWord)aImmediate {
    return generateBType(UHRRISCVOPCodeBRANCH, UHRRISCVF3BLT, sourceRegister1, sourceRegister2, aImmediate);
}

+ (UHRWord)bgeWithRS1:(UHREnum)sourceRegister1 rs2:(UHREnum)sourceRegister2 imm:(UHRWord)aImmediate {
    return generateBType(UHRRISCVOPCodeBRANCH, UHRRISCVF3BGE, sourceRegister1, sourceRegister2, aImmediate);
}

+ (UHRWord)bltuWithRS1:(UHREnum)sourceRegister1 rs2:(UHREnum)sourceRegister2 imm:(UHRWord)aImmediate {
    return generateBType(UHRRISCVOPCodeBRANCH, UHRRISCVF3BLTU, sourceRegister1, sourceRegister2, aImmediate);
}

+ (UHRWord)bgeuWithRS1:(UHREnum)sourceRegister1 rs2:(UHREnum)sourceRegister2 imm:(UHRWord)aImmediate {
    return generateBType(UHRRISCVOPCodeBRANCH, UHRRISCVF3BGEU, sourceRegister1, sourceRegister2, aImmediate);
}

+ (UHRWord)lbWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister imm:(UHRWord)aImmediate {
    return generateIType(UHRRISCVOPCodeLOAD, UHRRISCVF3LB, destinationRegister, sourceRegister, aImmediate);
}

+ (UHRWord)lhWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister imm:(UHRWord)aImmediate {
    return generateIType(UHRRISCVOPCodeLOAD, UHRRISCVF3LH, destinationRegister, sourceRegister, aImmediate);
}

+ (UHRWord)lwWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister imm:(UHRWord)aImmediate {
    return generateIType(UHRRISCVOPCodeLOAD, UHRRISCVF3LW, destinationRegister, sourceRegister, aImmediate);
}

+ (UHRWord)lbuWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister imm:(UHRWord)aImmediate {
    return generateIType(UHRRISCVOPCodeLOAD, UHRRISCVF3LBU, destinationRegister, sourceRegister, aImmediate);
}

+ (UHRWord)lhuWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister imm:(UHRWord)aImmediate {
    return generateIType(UHRRISCVOPCodeLOAD, UHRRISCVF3LHU, destinationRegister, sourceRegister, aImmediate);
}



@end
