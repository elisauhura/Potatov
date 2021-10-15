//
//  UHRModuleALU.m
//  Peeler
//
//  Created by Elisa Silva on 14/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import "UHRModuleALU.h"

@interface UHRModuleALU ()

@property void *module;

@end

@implementation UHRModuleALU

- (instancetype)init
{
    self = [super init];
    if (self) {
        _module = UHRMakeALU();
    }
    return self;
}

- (void)dealloc {
    if(_module != NULL) {
        UHRDestroyALU(_module);
        _module = NULL;
    }
}

- (void)pokeSignal:(UHREnum)signal withValue:(UHRWord)value {
    UHRPokeALU(_module, signal, value);
}

- (UHRWord)peekSignal:(UHREnum)signal {
    return UHRPeekALU(_module, signal);
}

- (void)evaluateStateAtTime:(UHRTimeUnit)time {
    UHREvalALU(_module, time);
}

- (UHREnum)clockSignal {
    return UHRModuleALUSignalNone;
}

@end
