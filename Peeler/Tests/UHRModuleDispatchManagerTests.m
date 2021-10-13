//
//  UHRModuleDispatchManagerTests.m
//  PeelerTests
//
//  Created by Elisa Silva on 11/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "UHRModuleDispatchManager.h"

@interface UHRModuleDispatchManagerTests : XCTestCase

@property UHRModuleDispatchManager *dispatch;

@end

unsigned int contextIs42AndReturn6 (unsigned int source, unsigned int request, unsigned int arg0, unsigned int arg1, unsigned int arg2, void * context);

unsigned int returnSum (unsigned int source, unsigned int request, unsigned int arg0, unsigned int arg1, unsigned int arg2, void * context);

unsigned int failTestIfCalled (unsigned int source, unsigned int request, unsigned int arg0, unsigned int arg1, unsigned int arg2, void * context);

@implementation UHRModuleDispatchManagerTests

- (void)setUp {
    self.dispatch = UHRModuleDispatchManager.defaultDispatch;
}

- (void)testDispatch {
    UInt32 ID = [_dispatch registerHandler:contextIs42AndReturn6
                                withContex:(void*)42
                                     forID:UHRModuleDisptachDefaultID];
    XCTAssert(ID != 0);
    XCTAssert([_dispatch dispatchFromSource:ID
                                    request:0
                                       arg0:0
                                       arg1:0
                                       arg2:0] == 6);
    [_dispatch removeHandlerForID:ID];
    XCTAssert([_dispatch dispatchFromSource:ID
                                    request:0
                                       arg0:0
                                       arg1:0
                                       arg2:0] == 0);
}

- (void)testDispatchUsingAPI {
    
    UInt32 ID = UHRModuleDispatchRegisterHandlerForID(UHRModuleDisptachDefaultID, contextIs42AndReturn6, (void *)42);
    XCTAssert(ID != 0);
    
    XCTAssert(UHRModuleDispatch(ID, 0, 0, 0, 0) == 6);
    UHRModuleDispatchRemoveHandlerForID(ID);
    XCTAssert(UHRModuleDispatch(ID, 0, 0, 0, 0) == 0);
}

- (void)testDispatchWithMultipleIDs {
    UInt32 ID42 = [_dispatch registerHandler:contextIs42AndReturn6
                                withContex:(void *)42
                                     forID:UHRModuleDisptachDefaultID];
    UInt32 IDSum = [_dispatch registerHandler:returnSum
                                withContex:(void *)0
                                     forID:UHRModuleDisptachDefaultID];
    UInt32 IDUnused = [_dispatch registerHandler:failTestIfCalled
                                withContex:(void *)0
                                     forID:UHRModuleDisptachDefaultID];
    
    XCTAssert([_dispatch dispatchFromSource:ID42
                                    request:0
                                       arg0:0
                                       arg1:0
                                       arg2:0] == 6);
    
    XCTAssert([_dispatch dispatchFromSource:IDSum
                                    request:0
                                       arg0:5
                                       arg1:6
                                       arg2:7] == 18);
    
    XCTAssert([_dispatch removeHandlerForID:ID42] == 0);
    XCTAssert([_dispatch removeHandlerForID:IDSum] == 0);
    XCTAssert([_dispatch removeHandlerForID:IDUnused] == 0);
    
    XCTAssert([_dispatch dispatchFromSource:IDUnused
                                    request:0
                                       arg0:0
                                       arg1:0
                                       arg2:0] == 0);
}

- (void)testBadDispatchRegister {
    UInt32 ID = [_dispatch registerHandler:contextIs42AndReturn6
                                withContex:(void*)42
                                     forID:(UInt32)-1];
    XCTAssert(ID == 0);
    XCTAssert([_dispatch dispatchFromSource:ID
                                    request:0
                                       arg0:0
                                       arg1:0
                                       arg2:0] == 0);
    XCTAssert([_dispatch removeHandlerForID:ID] == 1);
    XCTAssert([_dispatch dispatchFromSource:ID
                                    request:0
                                       arg0:0
                                       arg1:0
                                       arg2:0] == 0);
}

- (void)testRemoveInvalidID {
    XCTAssert([_dispatch removeHandlerForID:0] == 1);
    XCTAssert([_dispatch removeHandlerForID:(UInt32)-1] == 1);
}


@end


unsigned int contextIs42AndReturn6 (unsigned int source, unsigned int request, unsigned int arg0, unsigned int arg1, unsigned int arg2, void * context) {
    XCTAssert(context == (void *)42);
    return 6;
}

unsigned int returnSum (unsigned int source, unsigned int request, unsigned int arg0, unsigned int arg1, unsigned int arg2, void * context) {
    return arg0 + arg1 + arg2;
}

unsigned int failTestIfCalled (unsigned int source, unsigned int request, unsigned int arg0, unsigned int arg1, unsigned int arg2, void * context) {
    XCTFail();
    return 0;
}
