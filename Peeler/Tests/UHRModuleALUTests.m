//
//  UHRModuleALUTests.m
//  PeelerTests
//
//  Created by Elisa Silva on 14/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "UHRPeeler.h"
#import "UHRTestBench.h"
#import "UHRTestBenchScript.h"

@interface UHRModuleALUTests : XCTestCase

@property UHRModuleALU *module;

@end

enum ALUInstructions{
    ADD = 0,
    SLL,
    SLT,
    SLTU,
    XOR,
    SRL,
    OR,
    AND,
    SUB,
    SGE = 10,
    SGEU,
    SRA = 13
};

@implementation UHRModuleALUTests

- (void)setUp {
    _module = [UHRModuleALU new];
}

- (void)tearDown {
    _module = nil;
}

- (void)testALUOperations {
    NSMutableDictionary *script = [NSMutableDictionary new];
    
    int operations[] = {
    //  A   OP   B  = C
         5, ADD,  8, 13,
        10, SUB,  5,  5,
         2, SUB,  5, -3,
        -1, ADD,  1,  0,
         3, SLL,  3, 24,
         3, SLT, -5,  0,
         3, SLT,  5,  1,
         3, SLTU,-5,  1,
        -3, SLTU, 5,  0,
         7, XOR, 96, 103,
        24, SRL,  3,  3,
         3, OR ,  4,  7,
         7, AND,  4,  4,
       -24, SRA,  4, -2,
       -10, SGE,-11, 1,
       -10, SGE, 10, 0,
       -10, SGEU,-1, 0,
        -1, SGEU,-1, 1,
        -1, SGE ,-1, 1,
    };
    
    int numberOfOperations = (sizeof operations/sizeof operations[0])/4;
    
    for(int i = 0; i < numberOfOperations; i++) {
        script[@(i)] = @{
            @"applyOnRise": @[
                @(UHRModuleALUSignalA), @(operations[i*4]),
                @(UHRModuleALUSignalB), @(operations[i*4+2]),
                @(UHRModuleALUSignalFunct3), @(operations[i*4+1]&7),
                @(UHRModuleALUSignalFunct7_5b), @(operations[i*4+1]>>3)
            ],
            @"checkOnHigh": @[
                @(UHRModuleALUSignalOut), @(operations[i*4+3])
            ]
        };
    }
    
    script[@(numberOfOperations)] = @{ @"pass": @{} };
    
    UHRTestBench *testBench = [[UHRTestBench alloc] initWithModule:_module withScript:[UHRTestBenchScript scriptFromDictionary:script]];
    
    XCTAssertTrue([testBench runTestBenchUpToTime:numberOfOperations+1]);
}

@end
