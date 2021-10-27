//
//  UHRModuleSoftMemory.m
//  Peeler
//
//  Created by Elisa Silva on 13/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import "UHRModuleSoftMemory.h"
#import "UHRModule_Private.h"

@implementation UHRModuleSoftMemory

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.module = UHRMakeSoftMemory();
        self.destroy = UHRDestroySoftMemory;
        self.poke = UHRPokeSoftMemory;
        self.peek = UHRPeekSoftMemory;
        self.eval = UHREvalSoftMemory;
        self.clockSignal = UHRModuleSoftMemorySignalClock;
        self.signalNames = @{
            @(UHRModuleSoftMemorySignalNone):@"none",
            @(UHRModuleSoftMemorySignalCCommand):@"cCommand",
            @(UHRModuleSoftMemorySignalCAddress):@"cAddress",
            @(UHRModuleSoftMemorySignalCData):@"cData",
            @(UHRModuleSoftMemorySignalHReady):@"hReady",
            @(UHRModuleSoftMemorySignalHSignal):@"hSignal",
            @(UHRModuleSoftMemorySignalHData):@"hData",
            @(UHRModuleSoftMemorySignalReset):@"reset",
            @(UHRModuleSoftMemorySignalClock):@"clock",
        };
    }
    return self;
}

@end
