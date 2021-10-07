//
//  UHRTestBenchTests.m
//  Tests
//
//  Created by Elisa Silva on 07/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "UHRTestBench.h"
#import "UHRTestBenchScript.h"

@interface UHRTestBenchTests : XCTestCase

@end

@implementation UHRTestBenchTests

- (void)testInitOfTestBench {
    id mockedScript = OCMClassMock(UHRTestBenchScript.class);
    
    UHRTestBench *bench = [[UHRTestBench alloc] initWithModule:nil withScript:mockedScript];
    XCTAssertNotNil(bench);
    
    OCMVerify([mockedScript useXCTestIntegration:YES]);
}

@end
