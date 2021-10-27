//
//  UHRModule.m
//  Peeler
//
//  Created by Elisa Silva on 26/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import "UHRModule.h"
#import "UHRModule_Private.h"

@implementation UHRModule

- (instancetype)init
{
    self = [super init];
    if (self) {
        _module = NULL;
    }
    return self;
}

- (void)dealloc {
    if(_module != NULL) {
        _destroy(_module);
    }
}

- (void)pokeSignal:(UHREnum)signal withValue:(UHRWord)value {
    if(_module != NULL) {
        _poke(_module, signal, value);
    }
}

- (UHRWord)peekSignal:(UHREnum)signal {
    UHRWord ret = 0;
    if(_module != NULL) {
        ret = _peek(_module, signal);
    }
    return ret;
}

- (void)evaluateStateAtTime:(UHRTimeUnit)time {
    if(_module != NULL) {
        _eval(_module, time);
    }
}

@end
