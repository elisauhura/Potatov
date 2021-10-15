//
//  UHRModuleCore.m
//  Peeler
//
//  Created by Elisa Silva on 14/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import "UHRModuleCore.h"

@interface UHRModuleCore ()

@property void * module;

@end

@implementation UHRModuleCore

- (instancetype)init
{
    self = [super init];
    if (self) {
        _module = UHRMakeCore();
    }
    return self;
}

- (void)dealloc {
    if(_module != NULL) {
        UHRDestroyCore(_module);
        _module = NULL;
    }
}

- (void)pokeSignal:(UHREnum)signal withValue:(UHRWord)value {
    UHRPokeCore(_module, signal, value);
}

- (UHRWord)peekSignal:(UHREnum)signal {
    return UHRPeekCore(_module, signal);
}

- (void)evaluateStateAtTime:(UHRTimeUnit)time {
    UHREvalCore(_module, time);
}

- (UHREnum)clockSignal {
    return UHRModuleCoreSignalClock;
}

@end
