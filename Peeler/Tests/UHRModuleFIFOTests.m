//
//  UHRModuleFIFOTests.m
//  PeelerTests
//
//  Created by Elisa Silva on 26/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "UHRPeeler.h"
#import "UHRTestBench.h"
#import "UHRTestBenchScript.h"

@interface UHRModuleFIFOTests : XCTestCase

@property UHRModuleFIFO *module;

@end

@implementation UHRModuleFIFOTests

- (void)setUp {
    _module = [UHRModuleFIFO new];
}

- (void)tearDown {
    _module = nil;
}

- (void)testFIFOPush {
    NSMutableDictionary *script = [NSMutableDictionary new];
    
    int base = 0;
    for(int i = 0; i < 8; i++) {
        script[@(base++)] = @{
            @"applyOnRise": @[
                @(UHRModuleFIFOSignalCByte), @(i),
                @(UHRModuleFIFOSignalCPush), @(1)
            ]
        };
    }
    
    script[@(base++)] = @{
        @"applyOnRise": @[
            @(UHRModuleFIFOSignalCPush), @(0)
        ],
        @"checkOnHigh": @[
            @(UHRModuleFIFOSignalHFull), @(1)
        ]
    };
    
    for(int i = 0; i < 8; i++) {
        script[@(base++)] = @{
            @"applyOnRise": @[
                @(UHRModuleFIFOSignalCPop), @(1)
            ],
            @"checkOnHigh": @[
                @(UHRModuleFIFOSignalHByte), @(i)
            ]
        };
    }
    
    script[@(base++)] = @{
        @"applyOnRise": @[
            @(UHRModuleFIFOSignalCPop), @(0)
        ],
        @"checkOnHigh": @[
            @(UHRModuleFIFOSignalHEmpty), @(1)
        ],
        @"pass": @{}
    };
    
    UHRTestBench *testBench = [[UHRTestBench alloc] initWithModule:_module withScript:[UHRTestBenchScript scriptFromDictionary:script]];
    
    XCTAssertTrue([testBench runTestBenchUpToTime:base]);
}

- (void)testFIFORotation {
    NSMutableDictionary *script = [NSMutableDictionary new];
    
    // rotate 20
    int base = 0;
    for(int i = 0; i < 20; i++) {
        script[@(base++)] = @{
            @"applyOnRise": @[
                @(UHRModuleFIFOSignalCByte), @(i),
                @(UHRModuleFIFOSignalCPush), @(1),
                @(UHRModuleFIFOSignalCPop), @(1)
            ],
            @"checkOnHigh": @[
                @(UHRModuleFIFOSignalHEmpty), @(1),
                @(UHRModuleFIFOSignalHFull), @(0),
                @(UHRModuleFIFOSignalHByte), @(i),
            ]
        };
    }
    
    script[@(base++)] = @{
        @"applyOnRise": @[
            @(UHRModuleFIFOSignalCPush), @(0),
            @(UHRModuleFIFOSignalCPop), @(0)
        ]
    };
    
    // push to fill
    for(int i = 0; i < 20; i++) {
        script[@(base++)] = @{
            @"applyOnRise": @[
                @(UHRModuleFIFOSignalCByte), @(i),
                @(UHRModuleFIFOSignalCPush), @(1)
            ]
        };
    }
    
    script[@(base++)] = @{
        @"applyOnRise": @[
            @(UHRModuleFIFOSignalCPush), @(0),
        ],
        @"checkOnHigh": @[
            @(UHRModuleFIFOSignalHFull), @(1)
        ]
    };
    
    // pop half
    for(int i = 0; i < 4; i++) {
        script[@(base++)] = @{
            @"applyOnRise": @[
                @(UHRModuleFIFOSignalCPop), @(1)
            ],
            @"checkOnHigh": @[
                @(UHRModuleFIFOSignalHByte), @(i),
            ]
        };
    }
    
    script[@(base++)] = @{
        @"applyOnRise": @[
            @(UHRModuleFIFOSignalCPop), @(0),
        ],
        @"checkOnHigh": @[
            @(UHRModuleFIFOSignalHFull), @(0)
        ]
    };
    
    // push to fill
    for(int i = 0; i < 4; i++) {
        script[@(base++)] = @{
            @"applyOnRise": @[
                @(UHRModuleFIFOSignalCByte), @(i+128),
                @(UHRModuleFIFOSignalCPush), @(1)
            ]
        };
    }
    
    // pop upper half
    for(int i = 0; i < 4; i++) {
        script[@(base++)] = @{
            @"applyOnRise": @[
                @(UHRModuleFIFOSignalCPop), @(1)
            ],
            @"checkOnHigh": @[
                @(UHRModuleFIFOSignalHByte), @(i+4),
            ]
        };
    }
    
    // pop rest
    for(int i = 0; i < 4; i++) {
        script[@(base++)] = @{
            @"applyOnRise": @[
                @(UHRModuleFIFOSignalCPop), @(1)
            ],
            @"checkOnHigh": @[
                @(UHRModuleFIFOSignalHByte), @(i+128),
            ]
        };
    }
    
    script[@(base++)] = @{
        @"applyOnRise": @[
            @(UHRModuleFIFOSignalCPop), @(0),
        ],
        @"checkOnHigh": @[
            @(UHRModuleFIFOSignalHEmpty), @(0)
        ],
        @"pass": @{}
    };
    
    UHRTestBench *testBench = [[UHRTestBench alloc] initWithModule:_module withScript:[UHRTestBenchScript scriptFromDictionary:script]];
    
    XCTAssertTrue([testBench runTestBenchUpToTime:base]);
}

@end

