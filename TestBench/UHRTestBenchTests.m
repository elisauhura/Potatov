//
//  UHRTestBenchTests.m
//  TestBenchTests
//
//  Created by Elisa Silva on 07/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "UHRTestBench.h"
#import "UHRTestBenchScript.h"

@interface UHRTestBenchTests : XCTestCase

@property UHRTestBench *bench;
@property id mockedScript;

@end

@implementation UHRTestBenchTests

- (void)setUp {
    _mockedScript = OCMClassMock(UHRTestBenchScript.class);
    _bench = [[UHRTestBench alloc] initWithModule:nil withScript:_mockedScript];
}

- (void)testInitOfTestBench {
    XCTAssertNotNil(_bench);
    OCMVerify([_mockedScript useXCTestIntegration:YES]);
}

- (void)testCallScriptMethodsDuringRun {
    OCMStub([_mockedScript passScriptForModule:nil atTime:9]).andReturn(YES);
    XCTAssertTrue([_bench runTestBenchUpToTime:10]);
    
    OCMVerify([_mockedScript applyOnRiseChangesToModule:nil atTime:5]);
    OCMVerify([_mockedScript applyOnFallChangesToModule:nil atTime:5]);
    OCMVerify([_mockedScript checkOnHighContrainsForModule:nil atTime:5]);
    OCMVerify([_mockedScript checkOnLowContrainsForModule:nil atTime:5]);
}

- (void)testTimeoutRun {
    XCTAssertFalse([_bench runTestBenchUpToTime:10]);
}

@end
