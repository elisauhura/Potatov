//
//  UHRModuleALU.m
//  Peeler
//
//  Created by Elisa Silva on 14/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import "UHRModuleALU.h"
#import "UHRModule_Private.h"

@implementation UHRModuleALU

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.module = UHRMakeALU();
        self.destroy = UHRDestroyALU;
        self.poke = UHRPokeALU;
        self.peek = UHRPeekALU;
        self.eval = UHREvalALU;
        self.clockSignal = UHRModuleALUSignalNone;
        self.signalNames = @{
            @(UHRModuleALUSignalNone): @"none",
            @(UHRModuleALUSignalA): @"a",
            @(UHRModuleALUSignalB): @"b",
            @(UHRModuleALUSignalOut): @"out",
            @(UHRModuleALUSignalFunct3): @"funct3",
            @(UHRModuleALUSignalFunct7_5b): @"funct7_5b"
        };
    }
    return self;
}

@end
