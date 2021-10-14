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
    
    XCTAssert([manager dispatchFromSource:source
                                  request:UHRModuleDispatchRequestMemoryInterfaceDoOperation
                                     arg0:UHRMemoryInterfaceCommandRBA
                                     arg1:1
                                     arg2:0] == 'e');
    XCTAssert([manager dispatchFromSource:source
                                  request:UHRModuleDispatchRequestMemoryInterfaceDoOperation
                                     arg0:UHRMemoryInterfaceCommandRBB
                                     arg1:3
                                     arg2:0] == 'f');
    XCTAssert([manager dispatchFromSource:source
                                  request:UHRModuleDispatchRequestMemoryInterfaceDoOperation
                                     arg0:UHRMemoryInterfaceCommandRSA
                                     arg1:1
                                     arg2:0] == 0x6565);
    XCTAssert([manager dispatchFromSource:source
                                  request:UHRModuleDispatchRequestMemoryInterfaceDoOperation
                                     arg0:UHRMemoryInterfaceCommandRSB
                                     arg1:3
                                     arg2:0] == 0x6466);
    XCTAssert([manager dispatchFromSource:source
                                  request:UHRModuleDispatchRequestMemoryInterfaceDoOperation
                                     arg0:UHRMemoryInterfaceCommandRWA
                                     arg1:4
                                     arg2:0] == 0x64616564);
    XCTAssert([manager dispatchFromSource:source
                                  request:UHRModuleDispatchRequestMemoryInterfaceDoOperation
                                     arg0:UHRMemoryInterfaceCommandRWB
                                     arg1:0
                                     arg2:0] == 0x66656562);
}

- (void)testMemoryWrite {
    XCTAssert([_model ramLength] == 512);
    
    UInt32 source = [_model memoryID];
    UHRModuleDispatchManager *manager = [UHRModuleDispatchManager defaultDispatch];
    
    [manager dispatchFromSource:source
                        request:UHRModuleDispatchRequestMemoryInterfaceDoOperation
                           arg0:UHRMemoryInterfaceCommandWBA
                           arg1:0
                           arg2:0x61];
    [manager dispatchFromSource:source
                        request:UHRModuleDispatchRequestMemoryInterfaceDoOperation
                           arg0:UHRMemoryInterfaceCommandWBB
                           arg1:1
                           arg2:0x62];
    [manager dispatchFromSource:source
                        request:UHRModuleDispatchRequestMemoryInterfaceDoOperation
                           arg0:UHRMemoryInterfaceCommandWSA
                           arg1:2
                           arg2:0x6463];
    [manager dispatchFromSource:source
                        request:UHRModuleDispatchRequestMemoryInterfaceDoOperation
                           arg0:UHRMemoryInterfaceCommandWSB
                           arg1:4
                           arg2:0x6665];
    [manager dispatchFromSource:source
                        request:UHRModuleDispatchRequestMemoryInterfaceDoOperation
                           arg0:UHRMemoryInterfaceCommandWWA
                           arg1:6
                           arg2:0x6A696867];
    [manager dispatchFromSource:source
                        request:UHRModuleDispatchRequestMemoryInterfaceDoOperation
                           arg0:UHRMemoryInterfaceCommandWWB
                           arg1:10
                           arg2:0x6E6D6C6B];
    
    XCTAssert(memcmp([_model ramBytes], "abcdefghijklmn", 14) == 0);
}

- (void)testMemoryNOOP {
    UInt32 source = [_model memoryID];
    UHRModuleDispatchManager *manager = [UHRModuleDispatchManager defaultDispatch];
    
    
    XCTAssert([manager dispatchFromSource:source
                                  request:UHRModuleDispatchRequestMemoryInterfaceDoOperation
                                     arg0:UHRMemoryInterfaceCommandNOP
                                     arg1:1
                                     arg2:0] == 0);
    
    XCTAssert([manager dispatchFromSource:source
                                  request:UHRModuleDispatchRequestMemoryInterfaceDoOperation
                                     arg0:UHRMemoryInterfaceCommandDRA
                                     arg1:1
                                     arg2:0] == 0);
    
    XCTAssert([manager dispatchFromSource:source
                                  request:UHRModuleDispatchRequestMemoryInterfaceDoOperation
                                     arg0:UHRMemoryInterfaceCommandDRB
                                     arg1:1
                                     arg2:0] == 0);
    
    XCTAssert([manager dispatchFromSource:source
                                  request:UHRModuleDispatchRequestMemoryInterfaceDoOperation
                                     arg0:UHRMemoryInterfaceCommandHAW
                                     arg1:1
                                     arg2:0] == 0);
    
}

@end
