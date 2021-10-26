//
//  UHRModuleRegistersTests.m
//  PeelerTests
//
//  Created by Elisa Silva on 14/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//


#import <XCTest/XCTest.h>

#import "UHRPeeler.h"
#import "UHRTestBench.h"
#import "UHRTestBenchScript.h"

@interface UHRModuleRegistersTests : XCTestCase

@property UHRModuleRegisters *module;

@end

@implementation UHRModuleRegistersTests

- (void)setUp {
    _module = [UHRModuleRegisters new];
}

- (void)tearDown {
    _module = nil;
}

- (void)testRegisters {
    NSMutableDictionary *script = [NSMutableDictionary new];
    
    for(int i = 0; i < 32; i++) {
        script[@(i)] = @{
            @"applyOnRise": @[
                @(UHRModuleRegistersSignalCRegDAddress), @(i),
                @(UHRModuleRegistersSignalCRegDData), @(42+i),
                @(UHRModuleRegistersSignalCReg1Address), @(i),
                @(UHRModuleRegistersSignalCReg2Address), @(i>1?i-1:0)
            ],
            @"checkOnLow": @[
                @(UHRModuleRegistersSignalHReg1Data), @(i == 0 ? 0 : 42+i),
                @(UHRModuleRegistersSignalHReg2Data), @(i > 1 ? 41+i : 0)
            ]
        };
    }
    
    script[@(32)] = @{
        @"applyOnRise": @[
            @(UHRModuleRegistersSignalReset), @(1),
            @(UHRModuleRegistersSignalCRegDData), @(0)
        ],
        @"callback": ^BOOL(id module, UInt32 time) {
            for(int i = 0; i < 31; i++) {
                XCTAssert([self->_module peekSignal:UHRModuleRegistersSignalReg1 + i] == 0);
            }
            return YES;
        },
        @"pass": @{}
    };
    
    UHRTestBench *testBench = [[UHRTestBench alloc] initWithModule:_module withScript:[UHRTestBenchScript scriptFromDictionary:script]];
    
    XCTAssertTrue([testBench runTestBenchUpToTime:33]);
}

@end
