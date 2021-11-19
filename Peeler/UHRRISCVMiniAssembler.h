//
//  UHRRISCVMiniAssembler.h
//  Peeler
//
//  Created by Elisa Silva on 01/11/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UHRPeelerTypes.h"

@interface UHRRISCVMiniAssembler : NSObject

+ (UHRWord)luiWithRD:(UHREnum)aRegister imm:(UHRWord)aImmediate;
+ (UHRWord)aiupcWithRD:(UHREnum)aRegister imm:(UHRWord)aImmediate;

+ (UHRWord)addiWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister imm:(UHRWord)aImmediate;
+ (UHRWord)sltiWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister imm:(UHRWord)aImmediate;
+ (UHRWord)sltiuWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister imm:(UHRWord)aImmediate;
+ (UHRWord)xoriWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister imm:(UHRWord)aImmediate;
+ (UHRWord)oriWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister imm:(UHRWord)aImmediate;
+ (UHRWord)andiWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister imm:(UHRWord)aImmediate;
+ (UHRWord)slliWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister imm:(UHRWord)aImmediate;
+ (UHRWord)srliWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister imm:(UHRWord)aImmediate;
+ (UHRWord)sraiWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister imm:(UHRWord)aImmediate;

+ (UHRWord)addWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister1 rs2:(UHREnum)sourceRegister2;
+ (UHRWord)subWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister1 rs2:(UHREnum)sourceRegister2;
+ (UHRWord)sllWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister1 rs2:(UHREnum)sourceRegister2;
+ (UHRWord)sltWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister1 rs2:(UHREnum)sourceRegister2;
+ (UHRWord)sltuWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister1 rs2:(UHREnum)sourceRegister2;
+ (UHRWord)xorWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister1 rs2:(UHREnum)sourceRegister2;
+ (UHRWord)srlWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister1 rs2:(UHREnum)sourceRegister2;
+ (UHRWord)sraWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister1 rs2:(UHREnum)sourceRegister2;
+ (UHRWord)orWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister1 rs2:(UHREnum)sourceRegister2;
+ (UHRWord)andWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister1 rs2:(UHREnum)sourceRegister2;

+ (UHRWord)jalWithRD:(UHREnum)destinationRegister imm:(UHRWord)aImmediate;
+ (UHRWord)jalrWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister1 imm:(UHRWord)aImmediate;

+ (UHRWord)beqWithRS1:(UHREnum)sourceRegister1 rs2:(UHREnum)sourceRegister2 imm:(UHRWord)aImmediate;
+ (UHRWord)bneWithRS1:(UHREnum)sourceRegister1 rs2:(UHREnum)sourceRegister2 imm:(UHRWord)aImmediate;
+ (UHRWord)bltWithRS1:(UHREnum)sourceRegister1 rs2:(UHREnum)sourceRegister2 imm:(UHRWord)aImmediate;
+ (UHRWord)bgeWithRS1:(UHREnum)sourceRegister1 rs2:(UHREnum)sourceRegister2 imm:(UHRWord)aImmediate;
+ (UHRWord)bltuWithRS1:(UHREnum)sourceRegister1 rs2:(UHREnum)sourceRegister2 imm:(UHRWord)aImmediate;
+ (UHRWord)bgeuWithRS1:(UHREnum)sourceRegister1 rs2:(UHREnum)sourceRegister2 imm:(UHRWord)aImmediate;

+ (UHRWord)lbWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister imm:(UHRWord)aImmediate;
+ (UHRWord)lhWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister imm:(UHRWord)aImmediate;
+ (UHRWord)lwWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister imm:(UHRWord)aImmediate;
+ (UHRWord)lbuWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister imm:(UHRWord)aImmediate;
+ (UHRWord)lhuWithRD:(UHREnum)destinationRegister rs1:(UHREnum)sourceRegister imm:(UHRWord)aImmediate;

+ (UHRWord)sbWithRS1:(UHREnum)sourceRegister1 rs2:(UHREnum)sourceRegister2 imm:(UHRWord)aImmediate;
+ (UHRWord)shWithRS1:(UHREnum)sourceRegister1 rs2:(UHREnum)sourceRegister2 imm:(UHRWord)aImmediate;
+ (UHRWord)swWithRS1:(UHREnum)sourceRegister1 rs2:(UHREnum)sourceRegister2 imm:(UHRWord)aImmediate;

@end
