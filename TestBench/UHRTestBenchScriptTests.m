//
//  UHRTestBenchScriptTests.m
//  TestBenchTests
//
//  Created by Elisa Silva on 07/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "UHRTestBenchScript.h"

@interface UHRTestBenchScriptTests : XCTestCase

@property UHRTestBenchScript *script;

@end

@implementation UHRTestBenchScriptTests

- (void)setUp {
    _script = [UHRTestBenchScript scriptFromDictionary:@{
        @(1): @{
            @"applyOnRise": @[
                @(3), @(4),
                @(0), @(1)
            ],
            @"applyOnFall": @[
                @(4), @(1),
                @(99), @(1)
            ]
        },
        @(5): @{
            @"checkOnHigh": @[
                @(3), @(4),
                @(0), @(1)
            ],
            @"checkOnLow": @[
                @(4), @(1),
                @(99), @(1)
            ]
        },
        @(10): @{
            @"pass": @{}
        }
    }];
}

- (void)testApply {
    id mockedModule = OCMProtocolMock(@protocol(UHRModuleInterface));
    [_script applyOnRiseChangesToModule:mockedModule atTime:1];
    [_script applyOnFallChangesToModule:mockedModule atTime:1];
    
    OCMVerify([mockedModule pokeSignal:3 withValue:4]);
    OCMVerify([mockedModule pokeSignal:0 withValue:1]);
    OCMVerify([mockedModule pokeSignal:4 withValue:1]);
    OCMVerify([mockedModule pokeSignal:99 withValue:1]);
}

- (void)testCheck {
    id mockedModule = OCMProtocolMock(@protocol(UHRModuleInterface));
    
    OCMStub([mockedModule peekSignal:3]).andReturn(4);
    OCMStub([mockedModule peekSignal:0]).andReturn(1);
    OCMStub([mockedModule peekSignal:4]).andReturn(1);
    OCMStub([mockedModule peekSignal:99]).andReturn(1);
    
    XCTAssertTrue([_script checkOnHighContrainsForModule:mockedModule atTime:5]);
    XCTAssertTrue([_script checkOnLowContrainsForModule:mockedModule atTime:5]);
}

- (void)testCheckFailure {
    id mockedModule = OCMProtocolMock(@protocol(UHRModuleInterface));
    
    OCMStub([mockedModule peekSignal:3]).andReturn(4);
    OCMStub([mockedModule peekSignal:0]).andReturn(2);
    OCMStub([mockedModule peekSignal:4]).andReturn(1);
    OCMStub([mockedModule peekSignal:99]).andReturn(3);
    
    XCTAssertFalse([_script checkOnHighContrainsForModule:mockedModule atTime:5]);
    XCTAssertFalse([_script checkOnLowContrainsForModule:mockedModule atTime:5]);
}

- (void)testUseXCTestIntegration {
    [_script useXCTestIntegration:YES];
    
    id mockedModule = OCMProtocolMock(@protocol(UHRModuleInterface));
    
    OCMStub([mockedModule peekSignal:3]).andReturn(4);
    OCMStub([mockedModule peekSignal:0]).andReturn(2);
    OCMStub([mockedModule peekSignal:4]).andReturn(1);
    OCMStub([mockedModule peekSignal:99]).andReturn(3);
    
    XCTExpectedFailureOptions *options = [[XCTExpectedFailureOptions alloc] init];
    options.strict = YES;
    options.issueMatcher = ^ BOOL(XCTIssue *issue) {
        if(issue.type == XCTIssueTypeAssertionFailure &&
           ([issue.compactDescription isEqualTo:@"failed - checkOnHigh failed @5; signal 0 returned 2 when expecting 1."] ||
           [issue.compactDescription isEqualTo:@"failed - checkOnLow failed @5; signal 99 returned 3 when expecting 1."])) {
            return YES;
        }
        return NO;
    };
    
    XCTExpectFailureWithOptions(@"Must fail when running with XCTest", options);
    
    XCTAssertTrue([_script checkOnHighContrainsForModule:mockedModule atTime:5]);
    XCTAssertTrue([_script checkOnLowContrainsForModule:mockedModule atTime:5]);
}

- (void)testPass {
    XCTAssertTrue([_script passScriptForModule:nil atTime:10]);
    XCTAssertFalse([_script passScriptForModule:nil atTime:9]);
}

@end
