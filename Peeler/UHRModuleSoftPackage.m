//
//  UHRModuleSoftPackage.m
//  Peeler
//
//  Created by Elisa Silva on 15/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import "UHRModuleSoftPackage.h"
#import "UHRModule_Private.h"

@implementation UHRModuleSoftPackage

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSMutableDictionary *signals = [@{
            @(UHRModuleSoftPackageSignalNone):@"none",
            @(UHRModuleSoftPackageSignalCCommand):@"cCommand",
            @(UHRModuleSoftPackageSignalCAddress):@"cAddress",
            @(UHRModuleSoftPackageSignalCData):@"cData",
            @(UHRModuleSoftPackageSignalHReady):@"hReady",
            @(UHRModuleSoftPackageSignalHSignal):@"hSignal",
            @(UHRModuleSoftPackageSignalHData):@"hData",
            @(UHRModuleSoftPackageSignalReset):@"reset",
            @(UHRModuleSoftPackageSignalClock):@"clock",
            @(UHRModuleSoftPackageSignalPC):@"pc",
            @(UHRModuleSoftPackageSignalState):@"state",
            @(UHRModuleSoftPackageSignalInstruction):@"instruction",
            @(UHRModuleSoftPackageSignalMemoryID):@"memoryID",
        } mutableCopy];
        
        for(int i = 1; i < 32; i++) {
            signals[@(UHRModuleSoftPackageSignalReg1 + i - 1)] = [NSString stringWithFormat:@"x%02d", i];
        }
        
        self.module = UHRMakeSoftPackage();
        self.destroy = UHRDestroySoftPackage;
        self.poke = UHRPokeSoftPackage;
        self.peek = UHRPeekSoftPackage;
        self.eval = UHREvalSoftPackage;
        self.clockSignal = UHRModuleSoftPackageSignalClock;
        self.signalNames = [signals copy];
    }
    return self;
}

@end
