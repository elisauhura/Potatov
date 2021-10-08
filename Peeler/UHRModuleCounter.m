//
//  UHRModuleCounter.m
//  Peeler
//
//  Created by Elisa Silva on 07/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import "UHRModuleCounter.h"

@interface UHRModuleCounter ()

@property void * module;

@end

@implementation UHRModuleCounter

- (instancetype)init
{
    self = [super init];
    if (self) {
        _module = UHRMakeCounter();
    }
    return self;
}

- (void)dealloc {
    if(_module != NULL) {
        UHRDestroyCounter(_module);
        _module = NULL;
    }
}

- (void)pokeSignal:(UHREnum)signal withValue:(UHRWord)value {
    UHRPokeCounter(_module, signal, value);
}

- (UHRWord)peekSignal:(UHREnum)signal {
    return UHRPeekCounter(_module, signal);
}

- (void)evaluateStateAtTime:(UHRTimeUnit)time {
    UHREvalCounter(_module, time);
}

- (UHREnum)clockSignal {
    return UHRModuleCounterSignalClock;
}

@end
