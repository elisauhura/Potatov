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

/// @brief: Change the value of a signal
- (void)pokeSignal:(UHREnum)signal withValue:(UHRWord)value;

/// @brief: Return the value of a signal
- (UHRWord)peekSignal:(UHREnum)signal;

/// @brief: Evaluate the simulation of the model at a given time
- (void)evaluateStateAtTime:(UHRTimeUnit)time;

/// @brief: Get the signal of for the clock wire
- (UHREnum)clockSignal;

/// @brief: Get the name of the signals
- (NSDictionary *)signalNames;

@end
