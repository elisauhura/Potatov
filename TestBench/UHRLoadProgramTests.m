//
//  UHRLoadProgramTests.m
//  TestBenchTests
//
//  Created by Elisa Silva on 15/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "UHRLoadProgram.h"


@interface UHRLoadProgramTests : XCTestCase

@end

@implementation UHRLoadProgramTests

- (void)testLoadSAMPLEProgram {
    NSData *data = [UHRLoadProgram dataForProgramNamed:@"SAMPLE.bin"];
    XCTAssert(data.length == 4);
    XCTAssert(((char *)data.bytes)[0] == 0x37);
    XCTAssert(((char *)data.bytes)[1] == 0x0);
    XCTAssert(((char *)data.bytes)[2] == 0x0);
    XCTAssert(((char *)data.bytes)[3] == 0x0);
}

- (void)testLoadInvalidProgram {
    NSData *data = [UHRLoadProgram dataForProgramNamed:@"thisProgramDoesNotExists"];
    XCTAssert(data == nil);
}

@end
