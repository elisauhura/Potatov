//
//  UHRTestBench.h
//  TestBench
//
//  Created by Elisa Silva on 07/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UHRPeeler.h"

@class UHRTestBenchScript;

@interface UHRTestBench : NSObject

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithModule:(id<UHRModuleInterface>)module withScript:(UHRTestBenchScript *)script;
- (BOOL)runTestBenchUpToTime:(UHRTimeUnit)time;

@end
