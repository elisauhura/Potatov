//
//  UHRModuleRegisters.m
//  Peeler
//
//  Created by Elisa Silva on 14/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import "UHRModuleRegisters.h"
#import "UHRModule_Private.h"

@implementation UHRModuleRegisters

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSMutableDictionary *names = [@{
            @(UHRModuleRegistersSignalNone): @"none",
            @(UHRModuleRegistersSignalCReg1Address): @"cReg1Address",
            @(UHRModuleRegistersSignalCReg2Address): @"cReg2Address",
            @(UHRModuleRegistersSignalCRegDAddress): @"cRegDAddress",
            @(UHRModuleRegistersSignalCRegDData): @"cRegDData",
            @(UHRModuleRegistersSignalHReg1Data): @"hReg1Data",
            @(UHRModuleRegistersSignalHReg2Data): @"hReg2Data",
            @(UHRModuleRegistersSignalReset): @"reset",
            @(UHRModuleRegistersSignalClock): @"clock",
        } mutableCopy];
        
        for(int i = 1; i < 32; i++) {
            names[@(UHRModuleRegistersSignalReg + i - 1)] = [NSString stringWithFormat:@"reg%d", i];
        }
        
        self.module = UHRMakeRegisters();
        self.destroy = UHRDestroyRegisters;
        self.poke = UHRPokeRegisters;
        self.peek = UHRPeekRegisters;
        self.eval = UHREvalRegisters;
        self.clockSignal = UHRModuleRegistersSignalClock;
        self.signalNames = [names copy];
    }
    return self;
}

@end
