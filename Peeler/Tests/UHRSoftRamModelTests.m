//
//  UHRSoftRamModelTests.m
//  PeelerTests
//
//  Created by Elisa Silva on 13/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UHRSoftRamModel.h"
#import "UHRModuleDispatchManager.h"
#import "UHRMemoryInterface.h"

@interface UHRSoftRamModelTests : XCTestCase

@property UHRSoftRamModel *model;

@end

@implementation UHRSoftRamModelTests

- (void)setUp {
    _model = [[UHRSoftRamModel alloc] initWithRAMSize:512 delay:2];
}

- (void)tearDown {
    _model = nil;
}

- (void)testLoad {
    XCTAssert([_model ramLength] == 512);
    NSData *data = [[NSData alloc] initWithBytes:"beef" length:4];
    NSMutableData *biggerData = [NSMutableData dataWithCapacity:516];
    for(int i = 0; i < 129; i++) {
        [biggerData appendData:data];
    }
    [_model loadDataToRAM:data];
    XCTAssert(memcmp([_model ramBytes], [data bytes], 4) == 0);
    [_model loadDataToRAM:biggerData];
    XCTAssert(memcmp([_model ramBytes], [biggerData bytes], 512) == 0);
}

- (void)testMemoryDelay {
    UInt32 source = [_model memoryID];
    UHRModuleDispatchManager *manager = [UHRModuleDispatchManager defaultDispatch];
    XCTAssert([manager dispatchFromSource:source
                                  request:UHRModuleDispatchRequestMemoryInterfaceGetDelayFor
                                     arg0:UHRMemoryInterfaceCommandRBA
                                     arg1:0
                                     arg2:0] == 2);
    XCTAssert([manager dispatchFromSource:source
                                  request:UHRModuleDispatchRequestMemoryInterfaceGetDelayFor
                                     arg0:UHRMemoryInterfaceCommandNOP
                                     arg1:0
                                     arg2:0] == 2);
    XCTAssert([manager dispatchFromSource:source
                                  request:UHRModuleDispatchRequestMemoryInterfaceGetDelayFor
                                     arg0:UHRMemoryInterfaceCommandWWB
                                     arg1:0
                                     arg2:0] == 2);
}

- (void)testMemoryRead {
    XCTAssert([_model ramLength] == 512);
    
    UInt32 source = [_model memoryID];
    UHRModuleDispatchManager *manager = [UHRModuleDispatchManager defaultDispatch];
    
    NSData *data = [[NSData alloc] initWithBytes:"beefdead" length:8];
    [_model loadDataToRAM:data];
    
}

@end
