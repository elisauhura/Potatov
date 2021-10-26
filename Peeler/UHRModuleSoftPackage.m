//
//  UHRModuleSoftPackage.m
//  Peeler
//
//  Created by Elisa Silva on 15/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import "UHRModuleSoftPackage.h"

@interface UHRModuleSoftPackage ()

@property void * module;

@end

@implementation UHRModuleSoftPackage

- (instancetype)init
{
    self = [super init];
    if (self) {
        _module = UHRMakeSoftPackage();
    }
    return self;
}

- (void)dealloc {
    if(_module != NULL) {
        UHRDestroySoftPackage(_module);
        _module = NULL;
    }
}

- (void)pokeSignal:(UHREnum)signal withValue:(UHRWord)value {
    UHRPokeSoftPackage(_module, signal, value);
}

- (UHRWord)peekSignal:(UHREnum)signal {
    return UHRPeekSoftPackage(_module, signal);
}

- (void)evaluateStateAtTime:(UHRTimeUnit)time {
    UHREvalSoftPackage(_module, time);
}

- (UHREnum)clockSignal {
    return UHRModuleSoftPackageSignalClock;
}

@end
