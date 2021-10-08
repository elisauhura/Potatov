//
//  UHRModuleInterface.h
//  Peeler
//
//  Created by Elisa Silva on 07/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UHRPeelerTypes.h"

@protocol UHRModuleInterface <NSObject>

- (void)pokeSignal:(UHREnum)signal withValue:(UHRWord)value;
- (UHRWord)peekSignal:(UHREnum)signal;
- (void)evaluateStateAtTime:(UHRTimeUnit)time;
- (UHREnum)clockSignal;

@end
