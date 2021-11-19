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

- (void)testExecuteLUI {
    UHRTestBench *testBench = [[UHRTestBench alloc] initWithModule:_module withScript:[UHRTestBenchScript scriptFromDictionary:@{
        @(1): @{
            @"applyOnRise": @[
                @(UHRModuleCoreSignalHData), @([UHRRISCVMiniAssembler luiWithRD:0x1 imm:0x65432000]),
                @(UHRModuleCoreSignalHReady), @(1)
            ]
        },
        @(2): @{
            @"checkOnHigh": @[
                @(UHRModuleCoreSignalState), @(UHRModuleCoreStateExecute)
            ]
        },
        @(3): @{
            @"checkOnHigh": @[
                @(UHRModuleCoreSignalState), @(UHRModuleCoreStateFetch)
            ]
        },
        @(4): @{
            @"checkOnHigh": @[
                @(UHRModuleCoreSignalReg1),
                    @(0x65432000)
            ],
            @"pass": @{}
        }
    }]];
    
    XCTAssertTrue([testBench runTestBenchUpToTime:5]);
}

- (void)testExecuteAUIPC {
    UHRTestBench *testBench = [[UHRTestBench alloc] initWithModule:_module withScript:[UHRTestBenchScript scriptFromDictionary:@{
        @(1): @{
            @"applyOnRise": @[
                @(UHRModuleCoreSignalHData), @([UHRRISCVMiniAssembler aiupcWithRD:0x1 imm:0x65432000]),
                @(UHRModuleCoreSignalHReady), @(1)
            ]
        },
        @(2): @{
            @"checkOnHigh": @[
                @(UHRModuleCoreSignalState), @(UHRModuleCoreStateExecute)
            ]
        },
        @(3): @{
            @"checkOnHigh": @[
                @(UHRModuleCoreSignalState), @(UHRModuleCoreStateFetch)
            ]
        },
        @(4): @{
            @"checkOnHigh": @[
                @(UHRModuleCoreSignalReg1),
                    @(0x65432800)
            ],
            @"pass": @{}
        }
    }]];
    
    XCTAssertTrue([testBench runTestBenchUpToTime:5]);
}

- (void)testExecuteADDI {
    UHRTestBench *testBench = [[UHRTestBench alloc] initWithModule:_module withScript:[UHRTestBenchScript scriptFromDictionary:@{
        @(1): @{
            @"applyOnRise": @[
                @(UHRModuleCoreSignalHData), @([UHRRISCVMiniAssembler addiWithRD:1 rs1:1 imm:0x1F]),
                @(UHRModuleCoreSignalHReady), @(1)
            ]
        },
        @(4): @{
            @"checkOnHigh": @[
                @(UHRModuleCoreSignalReg1), @(0x1F)
            ]
        },
        @(7): @{
            @"checkOnHigh": @[
                @(UHRModuleCoreSignalReg1), @(0x3E)
            ]
        },
        @(10): @{
            @"checkOnHigh": @[
                @(UHRModuleCoreSignalReg1), @(0x5D)
            ]
        },
        @(13): @{
            @"checkOnHigh": @[
                @(UHRModuleCoreSignalReg1), @(0x7C)
            ]
        },
        @(16): @{
            @"checkOnHigh": @[
                @(UHRModuleCoreSignalReg1), @(0x9B)
            ],
            @"pass": @{}
        }
    }]];
    
    XCTAssertTrue([testBench runTestBenchUpToTime:17]);
}

- (void)testExecuteADD {
    UHRTestBench *testBench = [[UHRTestBench alloc] initWithModule:_module withScript:[UHRTestBenchScript scriptFromDictionary:@{
        @(1): @{
            @"applyOnRise": @[
                @(UHRModuleCoreSignalHData), @([UHRRISCVMiniAssembler addiWithRD:1 rs1:1 imm:0xF]),
                @(UHRModuleCoreSignalHReady), @(1)
            ]
        },
        @(4): @{
            @"applyOnRise": @[
                @(UHRModuleCoreSignalHData), @([UHRRISCVMiniAssembler addWithRD:2 rs1:2 rs2:1]),
                @(UHRModuleCoreSignalHReady), @(1)
            ]
        },
        @(7): @{
            @"checkOnHigh": @[
                @(UHRModuleCoreSignalReg1+1), @(0xF)
            ]
        },
        @(10): @{
            @"checkOnHigh": @[
                @(UHRModuleCoreSignalReg1+1), @(0x1E)
            ]
        },
        @(13): @{
            @"checkOnHigh": @[
                @(UHRModuleCoreSignalReg1+1), @(0x2D)
            ]
        },
        @(16): @{
            @"checkOnHigh": @[
                @(UHRModuleCoreSignalReg1+1), @(0x3C)
            ],
            @"pass": @{}
        }
    }]];
    
    XCTAssertTrue([testBench runTestBenchUpToTime:17]);
}

- (void)testExecuteSRLI {
    UHRTestBench *testBench = [[UHRTestBench alloc] initWithModule:_module withScript:[UHRTestBenchScript scriptFromDictionary:@{
        @(1): @{
            @"applyOnRise": @[
                @(UHRModuleCoreSignalHData), @([UHRRISCVMiniAssembler addiWithRD:1 rs1:0 imm:-1]),
                @(UHRModuleCoreSignalHReady), @(1)
            ]
        },
        @(4): @{
            @"applyOnRise": @[
                @(UHRModuleCoreSignalHData), @([UHRRISCVMiniAssembler srliWithRD:1 rs1:1 imm:4]),
                @(UHRModuleCoreSignalHReady), @(1)
            ],
            @"checkOnHigh": @[
                @(UHRModuleCoreSignalReg1), @(0xFFFFFFFF)
            ]
        },
        @(7): @{
            @"checkOnHigh": @[
                @(UHRModuleCoreSignalReg1), @(0x0FFFFFFF)
            ]
        },
        @(10): @{
            @"checkOnHigh": @[
                @(UHRModuleCoreSignalReg1), @(0x00FFFFFF)
            ]
        },
        @(13): @{
            @"checkOnHigh": @[
                @(UHRModuleCoreSignalReg1), @(0x000FFFFF)
            ]
        },
        @(16): @{
            @"checkOnHigh": @[
                @(UHRModuleCoreSignalReg1), @(0x0000FFFF)
            ],
            @"pass": @{}
        }
    }]];
    
    XCTAssertTrue([testBench runTestBenchUpToTime:17]);
}

- (void)testExecuteJAL {
    UHRTestBench *testBench = [[UHRTestBench alloc] initWithModule:_module withScript:[UHRTestBenchScript scriptFromDictionary:@{
        @(1): @{
            @"applyOnRise": @[
                @(UHRModuleCoreSignalHData), @([UHRRISCVMiniAssembler jalWithRD:5 imm:-0x100]),
                @(UHRModuleCoreSignalHReady), @(1)
            ]
        },
        @(4): @{
            @"checkOnHigh": @[
                @(UHRModuleCoreSignalPC), @(0x700),
                @(UHRModuleCoreSignalReg1 + 4), @(0x804)
            ],
            @"pass": @{}
        }
    }]];
    
    XCTAssertTrue([testBench runTestBenchUpToTime:5]);
}

- (void)testExecuteJALR {
    UHRTestBench *testBench = [[UHRTestBench alloc] initWithModule:_module withScript:[UHRTestBenchScript scriptFromDictionary:@{
        @(1): @{
            @"applyOnRise": @[
                @(UHRModuleCoreSignalHData), @([UHRRISCVMiniAssembler addiWithRD:2 rs1:2 imm:223]),
                @(UHRModuleCoreSignalHReady), @(1)
            ]
        },
        @(4): @{
            @"applyOnRise": @[
                @(UHRModuleCoreSignalHData), @([UHRRISCVMiniAssembler jalrWithRD:5 rs1:2 imm:-123]),
                @(UHRModuleCoreSignalHReady), @(1)
            ]
        },
        @(7): @{
            @"checkOnHigh": @[
                @(UHRModuleCoreSignalPC), @(100),
                @(UHRModuleCoreSignalReg1 + 4), @(0x808)
            ],
            @"pass": @{}
        }
    }]];
    
    XCTAssertTrue([testBench runTestBenchUpToTime:8]);
}


- (void)testExecuteBranch {
    NSMutableDictionary *script = [@{
        @(1): @{
            @"applyOnRise": @[
                @(UHRModuleCoreSignalHData), @([UHRRISCVMiniAssembler addiWithRD:2 rs1:2 imm:100]),
                @(UHRModuleCoreSignalHReady), @(1)
            ]
        },
        @(4): @{
            @"applyOnRise": @[
                @(UHRModuleCoreSignalHData), @([UHRRISCVMiniAssembler addiWithRD:3 rs1:3 imm:100]),
                @(UHRModuleCoreSignalHReady), @(1)
            ]
        },
        @(7): @{
            @"applyOnRise": @[
                @(UHRModuleCoreSignalHData), @([UHRRISCVMiniAssembler addiWithRD:4 rs1:4 imm:-100]),
                @(UHRModuleCoreSignalHReady), @(1)
            ]
        },
        @(10): @{
            @"applyOnRise": @[
                @(UHRModuleCoreSignalHData), @([UHRRISCVMiniAssembler jalrWithRD:0 rs1:0 imm:0]),
                @(UHRModuleCoreSignalHReady), @(1)
            ]
        }
    } mutableCopy];
    
    // x2 == 100, x3 == 100, x4 == -100
    
    UHRWord checks[] = {
        [UHRRISCVMiniAssembler beqWithRS1:2  rs2:3  imm:  8],   8,
        [UHRRISCVMiniAssembler beqWithRS1:2  rs2:4  imm:  4],  12,
        [UHRRISCVMiniAssembler bneWithRS1:2  rs2:3  imm: 10],  16,
        [UHRRISCVMiniAssembler bneWithRS1:2  rs2:4  imm: 24],  40,
        [UHRRISCVMiniAssembler bneWithRS1:2  rs2:3  imm: 24],  44,
        [UHRRISCVMiniAssembler bltWithRS1:4  rs2:2  imm: 40],  84,
        [UHRRISCVMiniAssembler bltWithRS1:2  rs2:2  imm: 40],  88,
        [UHRRISCVMiniAssembler bltWithRS1:0  rs2:2  imm:-68],  20,
        [UHRRISCVMiniAssembler bgeWithRS1:4  rs2:2  imm:  8],  24,
        [UHRRISCVMiniAssembler bgeWithRS1:2  rs2:2  imm:  8],  32,
        [UHRRISCVMiniAssembler bgeuWithRS1:4 rs2:2  imm: 80], 112,
        [UHRRISCVMiniAssembler bltuWithRS1:4 rs2:2  imm: 80], 116,
        [UHRRISCVMiniAssembler bgeWithRS1:0  rs2:2  imm: 12], 120,
    };
    
    int numberOfChecks = (sizeof checks/sizeof checks[0])/2;
    int offset = 13;
    int end = offset + numberOfChecks * 3 + 2;
    
    for(int i = 0; i < numberOfChecks; i++) {
        script[@(offset+i*3)] = @{
            @"applyOnRise": @[
                @(UHRModuleCoreSignalHData), @(checks[i*2]),
                @(UHRModuleCoreSignalHReady), @(1)
            ]
        };
        script[@(offset+i*3+4)] = @{
            @"checkOnHigh": @[
                @(UHRModuleCoreSignalPC), @(checks[i*2+1]),
            ],
        };
    }
    
    script[@(end)] = @{
        @"pass": @{}
    };
    
    UHRTestBench *testBench = [[UHRTestBench alloc] initWithModule:_module withScript:[UHRTestBenchScript scriptFromDictionary:script]];
    
    XCTAssertTrue([testBench runTestBenchUpToTime:end + 1]);
}

- (void)testExecuteLOAD {
    NSMutableDictionary *script = [NSMutableDictionary new];
    
    UHRWord checks[] = {
        /*-Intstruction------------------------------------|-Value-----|-Reg-|-Value-Loaded-|-Adress-*/
        [UHRRISCVMiniAssembler lbuWithRD:1 rs1:0 imm:0xFF],  0x80,       0x1,  0x80,          0xFF,
        [UHRRISCVMiniAssembler lbWithRD:2 rs1:1 imm:-0xF],   0x80,       0x2,  0xFFFFFF80,    0x71,
        [UHRRISCVMiniAssembler lhWithRD:3 rs1:1 imm:-0x10],  0xFABC,     0x3,  0xFFFFFABC,    0x70,
        [UHRRISCVMiniAssembler lhuWithRD:4 rs1:1 imm:0],     0xFABC,     0x4,  0xFABC,        0x80,
        [UHRRISCVMiniAssembler lwWithRD:5 rs1:1 imm:0x20],   0xDEADBEEF, 0x5,  0xDEADBEEF,    0xA0,
    };
    
    int args = 5;
    int numberOfChecks = (sizeof checks/sizeof checks[0])/args;
    int offset = 1;
    int duration = 6;
    int end = offset + numberOfChecks * duration + 2;
    
    for(int i = 0; i < numberOfChecks; i++) {
        script[@(offset+i*duration)] = @{
            @"applyOnRise": @[
                @(UHRModuleCoreSignalHData), @(checks[i*args]),
                @(UHRModuleCoreSignalHReady), @(1)
            ]
        };
        script[@(offset+i*duration+4)] = @{
            @"applyOnRise": @[
                @(UHRModuleCoreSignalHData), @(checks[i*args + 1]),
                @(UHRModuleCoreSignalHReady), @(0)
            ],
            @"checkOnHigh": @[
                @(UHRModuleCoreSignalCAddress), @(checks[i*args+4])
            ]
        };
        script[@(offset+i*duration+5)] = @{
            @"applyOnRise": @[
                @(UHRModuleCoreSignalHReady), @(1)
            ]
        };
        
        script[@(offset+i*duration+7)] = @{
            @"checkOnHigh": @[
                @(UHRModuleCoreSignalReg1 + checks[i*args+2] - 1), @(checks[i*args+3])
            ]
        };
    }
    
    script[@(end)] = @{
        @"pass": @{}
    };
    
    UHRTestBench *testBench = [[UHRTestBench alloc] initWithModule:_module withScript:[UHRTestBenchScript scriptFromDictionary:script]];
    
    XCTAssertTrue([testBench runTestBenchUpToTime:end + 1]);
}

- (void)testExecuteSTORE {
    NSMutableDictionary *script = [NSMutableDictionary new];
    
    UHRWord checks[] = {
     /*|-Padding-|-Width-|-SourceReg-|-AddressReg-|-Source-----|-Address-|-Offset-|=*/
        0x0,       32,     0x2,        0x1,         0xDEADBEEF,  0xABCD,   0x0,
        0x0,       32,     0x3,        0x2,         -0x42,       0xABCE,   -0x1,
        0x0,       16,     0xF,        0x3,         0xDEAD,      0xFFFF,   0xFF,
        0x0,       16,     0x10,       0xA,         0xBEEF,      0xFFFF,   0xFF,
        0x0,       8,      0x1F,       0xB,         0xEF,        0xA,      0x0,
        0x0,       8,      0x1E,       0xC,         0x42,        0xB,      -0x666,
        0x0,       8,      0x1D,       0xD,         0x33,        0xC,      -0x9,
    };
    
    int args = 7;
    int numberOfChecks = (sizeof checks/sizeof checks[0])/args;
    int offset = 1;
    int duration = 6;
    int end = offset + numberOfChecks * duration + 1;
    
    for(int i = 0; i < numberOfChecks; i++) {
        checks[i*args] =
            checks[i*args+1] == 32 ? [UHRRISCVMiniAssembler swWithRS1:checks[i*args+3] rs2:checks[i*args+2] imm:checks[i*args+6]]:
            checks[i*args+1] == 16 ? [UHRRISCVMiniAssembler shWithRS1:checks[i*args+3] rs2:checks[i*args+2] imm:checks[i*args+6]]:
         /* checks[i*args+1] ==  8 */[UHRRISCVMiniAssembler sbWithRS1:checks[i*args+3] rs2:checks[i*args+2] imm:checks[i*args+6]];
        
        script[@(offset+i*duration)] = @{
            @"applyOnRise": @[
                @(UHRModuleCoreSignalHData), @(checks[i*args]),
                @(UHRModuleCoreSignalReg1+checks[i*args+3]-1), @(checks[i*args+5] - checks[i*args+6]),
                @(UHRModuleCoreSignalReg1+checks[i*args+2]-1), @(checks[i*args+4]),
                @(UHRModuleCoreSignalHReady), @(1)
            ]
        };
        script[@(offset+i*duration+4)] = @{
            @"applyOnRise": @[
                @(UHRModuleCoreSignalHReady), @(0)
            ],
            @"checkOnHigh": @[
                @(UHRModuleCoreSignalCAddress), @(checks[i*args+5]),
                @(UHRModuleCoreSignalCData), @(checks[i*args+4])
            ]
        };
        script[@(offset+i*duration+5)] = @{
            @"applyOnRise": @[
                @(UHRModuleCoreSignalHReady), @(1)
            ]
        };
    }
    
    script[@(end)] = @{
        @"pass": @{}
    };
    
    UHRTestBench *testBench = [[UHRTestBench alloc] initWithModule:_module withScript:[UHRTestBenchScript scriptFromDictionary:script]];
    
    XCTAssertTrue([testBench runTestBenchUpToTime:end + 1]);
}

@end
