//
//  UHRModuleUART.m
//  Peeler
//
//  Created by Elisa Silva on 28/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import "UHRModuleUART.h"
#import "UHRModule_Private.h"

@implementation UHRModuleUART

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.module = UHRMakeUART();
        self.destroy = UHRDestroyUART;
        self.poke = UHRPokeUART;
        self.peek = UHRPeekUART;
        self.eval = UHREvalUART;
        self.clockSignal = UHRModuleUARTSignalClock;
        self.signalNames = @{
            @(UHRModuleUARTSignalNone):@"none",
            @(UHRModuleUARTSignalCByte):@"cByte",
            @(UHRModuleUARTSignalCRead):@"cRead",
            @(UHRModuleUARTSignalCWrite):@"cWrite",
            @(UHRModuleUARTSignalHByte):@"hByte",
            @(UHRModuleUARTSignalHCanRead):@"hCanRead",
            @(UHRModuleUARTSignalHCanWrite):@"hCanWrite",
            @(UHRModuleUARTSignalTX):@"tx",
            @(UHRModuleUARTSignalRX):@"rx",
            @(UHRModuleUARTSignalReset):@"reset",
            @(UHRModuleUARTSignalClock):@"clock",
        };
    }
    return self;
}

@end
