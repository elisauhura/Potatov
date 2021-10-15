//
//  UHRModuleCoreTests.m
//  PeelerTests
//
//  Created by Elisa Silva on 14/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//


#import <XCTest/XCTest.h>

#import "UHRPeeler.h"
#import "UHRTestBench.h"
#import "UHRTestBenchScript.h"

#import "UHRMemoryInterface.h"

@interface UHRModuleCoreTests : XCTestCase

@property UHRModuleCore *module;

@end

@implementation UHRModuleCoreTests

- (void)setUp {
    _module = [UHRModuleCore new];
}

- (void)tearDown {
    _module = nil;
}

- (void)testFetchWithZeroDelay {
    UHRTestBench *testBench = [[UHRTestBench alloc] initWithModule:_module withScript:[UHRTestBenchScript scriptFromDictionary:@{
        @(0): @{
            @"applyOnRise": @[
                @(UHRModuleCoreSignalHData), @(42),
            ],
            @"checkOnHigh": @[
                @(UHRModuleCoreSignalState), @(UHRModuleCoreStateFetch)
            ]
        },
        @(1): @{
            @"applyOnRise": @[
                @(UHRModuleCoreSignalHReady), @(1),
            ],
            @"checkOnHigh": @[
                @(UHRModuleCoreSignalCCommand), @(UHRMemoryInterfaceCommandRWA),
                @(UHRModuleCoreSignalInstruction), @(42)
            ]
        },
        @(2): @{
            @"pass": @{}
        }
    }]];
    
    XCTAssertTrue([testBench runTestBenchUpToTime:3]);
}

@end
