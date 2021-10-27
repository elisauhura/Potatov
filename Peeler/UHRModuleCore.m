//
//  UHRModuleCore.m
//  Peeler
//
//  Created by Elisa Silva on 14/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import "UHRModuleCore.h"
#import "UHRModule_Private.h"

@implementation UHRModuleCore

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.module = UHRMakeCore();
        self.destroy = UHRDestroyCore;
        self.poke = UHRPokeCore;
        self.peek = UHRPeekCore;
        self.eval = UHREvalCore;
        self.clockSignal = UHRModuleCoreSignalClock;
        self.signalNames = @{
            @(UHRModuleCoreSignalNone): @"none",
            @(UHRModuleCoreSignalCCommand): @"cCommand",
            @(UHRModuleCoreSignalCAddress): @"cAddress",
            @(UHRModuleCoreSignalCData): @"cData",
            @(UHRModuleCoreSignalHReady): @"hReady",
            @(UHRModuleCoreSignalHSignal): @"hSignal",
            @(UHRModuleCoreSignalHData): @"hData",
            @(UHRModuleCoreSignalReset): @"reset",
            @(UHRModuleCoreSignalClock): @"clock",
            @(UHRModuleCoreSignalPC): @"pc",
            @(UHRModuleCoreSignalState): @"state",
            @(UHRModuleCoreSignalInstruction): @"instruction",
        };
    }
    return self;
}

@end
