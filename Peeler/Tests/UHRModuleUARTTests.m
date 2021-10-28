//
//  UHRModuleUARTTests.m
//  PeelerTests
//
//  Created by Elisa Silva on 28/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "UHRPeeler.h"
#import "UHRTestBench.h"
#import "UHRTestBenchScript.h"

@interface UHRModuleUARTTests : XCTestCase

@property UHRModuleUART *module;

@end

@implementation UHRModuleUARTTests

- (void)setUp {
    _module = [UHRModuleUART new];
}

- (void)tearDown {
    _module = nil;
}

- (void)testUARTTX {
    NSMutableDictionary *script = [NSMutableDictionary new];
    
    char *message = "hello123";
    int base = 0;
    for(int i = 0; i < 8; i++) {
        script[@(base++)] = @{
            @"applyOnRise": @[
                @(UHRModuleUARTSignalCByte), @(message[i]),
                @(UHRModuleUARTSignalCWrite), @(1)
            ]
        };
    }

    script[@(base++)] = @{
        @"applyOnRise": @[
            @(UHRModuleUARTSignalCWrite), @(0)
        ]
    };
    
    int bit = 5208;
    int halfBit = bit/2;
    int byte = bit * 10;
    int pad = byte*10;
    
    for(int i = 0; i < 8; i++) {
        for(int j = 0; j < 10; j++) {
            script[@(i * byte + j * bit + halfBit)] = @{
                @"checkOnHigh": @[
                    @(UHRModuleUARTSignalTX),
                    @(j == 0 ? 0:
                      j == 9 ? 1:
                    ((message[i] >> (j-1)) & 1)),
                ]
            };
        }
    }
    
    script[@(pad-1)] = @{
        @"pass": @{}
    };
    
    UHRTestBench *testBench = [[UHRTestBench alloc] initWithModule:_module withScript:[UHRTestBenchScript scriptFromDictionary:script]];
    
    XCTAssertTrue([testBench runTestBenchUpToTime:pad]);
}



- (void)testUARTRX {
    NSMutableDictionary *script = [NSMutableDictionary new];
    
    char *message = "hello123";
    int base = 10;
    
    int bit = 5208;
    int byte = bit * 10;
    int checkOffset = byte * 9 + 512;
    int pad = byte*10 + base;
    
    for(int i = 0; i < 8; i++) {
        for(int j = 0; j < 10; j++) {
            script[@(i * byte + j * bit + base)] = @{
                @"applyOnRise": @[
                    @(UHRModuleUARTSignalRX),
                    @(j == 0 ? 0:
                      j == 9 ? 1:
                    ((message[i] >> (j-1)) & 1)),
                ]
            };
        }
        script[@(checkOffset+i)] = @{
            @"applyOnRise": @[
                @(UHRModuleUARTSignalCRead),
                @(1),
            ],
            @"checkOnHigh": @[
                @(UHRModuleUARTSignalHByte),
                @(message[i])
            ]
        };
    }
    
    script[@(checkOffset+8)] = @{
        @"applyOnRise": @[
            @(UHRModuleUARTSignalCRead),
            @(0),
        ]
    };
    
    script[@(pad-1)] = @{
        @"pass": @{}
    };
    
    UHRTestBench *testBench = [[UHRTestBench alloc] initWithModule:_module withScript:[UHRTestBenchScript scriptFromDictionary:script]];
    
    XCTAssertTrue([testBench runTestBenchUpToTime:pad]);
}


@end
