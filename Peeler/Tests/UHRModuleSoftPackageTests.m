//
//  UHRModuleSoftPackageTests.m
//  PeelerTests
//
//  Created by Elisa Silva on 15/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "UHRPeeler.h"
#import "UHRSoftRamModel.h"
#import "UHRTestBench.h"
#import "UHRTestBenchScript.h"
#import "UHRLoadProgram.h"

@interface UHRModuleSoftPackageTests : XCTestCase

@property UHRModuleSoftPackage *module;

@end

@implementation UHRModuleSoftPackageTests

- (void)setUp {
    _module = [UHRModuleSoftPackage new];
}

- (void)tearDown {
    _module = nil;
}

- (void)testLUIInstructionWithDelayOf2 {
    UHRSoftRamModel *ram = [[UHRSoftRamModel alloc] initWithRAMSize:512 delay:2];
    [ram loadDataToRAM:[UHRLoadProgram dataForProgramNamed:@"LUI.bin"]];
    [_module pokeSignal:UHRModuleSoftPackageSignalMemoryID withValue:[ram memoryID]];
    UHRTestBench *testBench = [[UHRTestBench alloc] initWithModule:_module withScript:[UHRTestBenchScript scriptFromDictionary:@{
        @(6): @{
            @"pass": @{}
        }
    }]];
    
    XCTAssert([testBench runTestBenchUpToTime:7]);
}

@end
