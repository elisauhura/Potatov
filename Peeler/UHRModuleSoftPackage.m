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
        self.module = UHRMakeSoftPackage();
        self.destroy = UHRDestroySoftPackage;
        self.poke = UHRPokeSoftPackage;
        self.peek = UHRPeekSoftPackage;
        self.eval = UHREvalSoftPackage;
        self.clockSignal = UHRModuleSoftPackageSignalClock;
        self.signalNames = @{
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
        };
    }
    return self;
}

@end
