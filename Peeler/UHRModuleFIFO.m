//
//  UHRModuleFIFO.m
//  Peeler
//
//  Created by Elisa Silva on 26/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import "UHRModuleFIFO.h"
#import "UHRModule_Private.h"

@implementation UHRModuleFIFO

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.module = UHRMakeFIFO();
        self.destroy = UHRDestroyFIFO;
        self.poke = UHRPokeFIFO;
        self.peek = UHRPeekFIFO;
        self.eval = UHREvalFIFO;
        self.clockSignal = UHRModuleFIFOSignalClock;
        self.signalNames = @{
            @(UHRModuleFIFOSignalNone):@"none",
            @(UHRModuleFIFOSignalCByte):@"cByte",
            @(UHRModuleFIFOSignalCPush):@"cPush",
            @(UHRModuleFIFOSignalCPop):@"cPop",
            @(UHRModuleFIFOSignalHByte):@"hByte",
            @(UHRModuleFIFOSignalHFull):@"hFull",
            @(UHRModuleFIFOSignalHEmpty):@"hEmpty",
            @(UHRModuleFIFOSignalReset):@"reset",
            @(UHRModuleFIFOSignalClock):@"clock",
        };
    }
    return self;
}

@end
