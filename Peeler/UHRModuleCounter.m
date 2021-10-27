//
//  UHRModuleCounter.m
//  Peeler
//
//  Created by Elisa Silva on 07/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import "UHRModuleCounter.h"
#import "UHRModule_Private.h"

@implementation UHRModuleCounter

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.module = UHRMakeCounter();
        self.destroy = UHRDestroyCounter;
        self.poke = UHRPokeCounter;
        self.peek = UHRPeekCounter;
        self.eval = UHREvalCounter;
        self.clockSignal = UHRModuleCounterSignalClock;
        self.signalNames = @{
            @(UHRModuleCounterSignalNone): @"none",
            @(UHRModuleCounterSignalCounter): @"counter",
            @(UHRModuleCounterSignalReset): @"reset",
            @(UHRModuleCounterSignalClock): @"clock"
        };
    }
    return self;
}

@end
