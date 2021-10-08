//
//  UHRModuleCounterTests.m
//  PeelerTests
//
//  Created by Elisa Silva on 07/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "UHRPeeler.h"
#import "UHRTestBench.h"
#import "UHRTestBenchScript.h"

@interface UHRModuleCounterTests : XCTestCase

@property UHRModuleCounter *module;

@end

@implementation UHRModuleCounterTests

- (void)setUp {
    _module = [[UHRModuleCounter alloc] init];
}

- (void)tearDown {
    _module = nil;
}

- (void)testCountTo10 {
    UHRTestBench *testBench = [[UHRTestBench alloc] initWithModule:_module withScript:[UHRTestBenchScript scriptFromDictionary:@{
        @(9): @{
            @"checkOnLow": @[
                @(UHRModuleCounterSignalCounter), @(10)
            ]
        },
        @(10): @{
            @"pass": @{}
        }
    }]];
    
    XCTAssertTrue([testBench runTestBenchUpToTime:11]);
}

@end
