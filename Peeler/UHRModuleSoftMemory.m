//
//  UHRModuleSoftMemory.m
//  Peeler
//
//  Created by Elisa Silva on 13/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import "UHRModuleSoftMemory.h"


@interface UHRModuleSoftMemory ()

@property void * module;

@end

@implementation UHRModuleSoftMemory

- (instancetype)init
{
    self = [super init];
    if (self) {
        _module = UHRMakeSoftMemory();
    }
    return self;
}

- (void)dealloc {
    if(_module != NULL) {
        UHRDestroySoftMemory(_module);
        _module = NULL;
    }
}

- (void)pokeSignal:(UHREnum)signal withValue:(UHRWord)value {
    UHRPokeSoftMemory(_module, signal, value);
}

- (UHRWord)peekSignal:(UHREnum)signal {
    return UHRPeekSoftMemory(_module, signal);
}

- (void)evaluateStateAtTime:(UHRTimeUnit)time {
    UHREvalSoftMemory(_module, time);
}

- (UHREnum)clockSignal {
    return UHRModuleSoftMemorySignalClock;
}

@end
