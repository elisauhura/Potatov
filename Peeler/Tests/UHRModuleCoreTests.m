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
        @(1): @{
            @"applyOnRise": @[
                @(UHRModuleCoreSignalHData), @(0b1111000100110111),
                @(UHRModuleCoreSignalHReady), @(1)
            ],
            @"checkOnHigh": @[
                @(UHRModuleCoreSignalCCommand), @(UHRMemoryInterfaceCommandReadWord),
                @(UHRModuleCoreSignalState), @(UHRModuleCoreStateFetch)
            ]
        },
        @(2): @{
            @"checkOnHigh": @[
                @(UHRModuleCoreSignalCCommand), @(UHRMemoryInterfaceCommandNOP),
                @(UHRModuleCoreSignalInstruction), @(0b1111000100110111)
            ]
        },
        @(3): @{
            @"pass": @{}
        }
    }]];
    
    XCTAssertTrue([testBench runTestBenchUpToTime:4]);
}

@end
