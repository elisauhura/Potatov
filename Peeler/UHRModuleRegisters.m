//
//  UHRModuleRegisters.m
//  Peeler
//
//  Created by Elisa Silva on 14/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import "UHRModuleRegisters.h"

@interface UHRModuleRegisters ()

@property void * module;

@end

@implementation UHRModuleRegisters

- (instancetype)init
{
    self = [super init];
    if (self) {
        _module = UHRMakeRegisters();
    }
    return self;
}

- (void)dealloc {
    if(_module != NULL) {
        UHRDestroyRegisters(_module);
        _module = NULL;
    }
}

- (void)pokeSignal:(UHREnum)signal withValue:(UHRWord)value {
    UHRPokeRegisters(_module, signal, value);
}

- (UHRWord)peekSignal:(UHREnum)signal {
    return UHRPeekRegisters(_module, signal);
}

- (void)evaluateStateAtTime:(UHRTimeUnit)time {
    UHREvalRegisters(_module, time);
}

- (UHREnum)clockSignal {
    return UHRModuleRegistersSignalClock;
}

@end
