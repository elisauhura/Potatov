//
//  UHRTestBenchScript.h
//  TestBench
//
//  Created by Elisa Silva on 07/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UHRPeeler.h"

@interface UHRTestBenchScript : NSObject

+ (instancetype)scriptFromDictionary:(NSDictionary *)dictionary;

- (instancetype)init NS_UNAVAILABLE;

- (void)useXCTestIntegration:(BOOL)aFlag;

- (BOOL)applyOnRiseChangesToModule:(id<UHRModuleInterface>)module atTime:(UHRTimeUnit)time;
- (BOOL)applyOnFallChangesToModule:(id<UHRModuleInterface>)module atTime:(UHRTimeUnit)time;
- (BOOL)checkOnHighContrainsForModule:(id<UHRModuleInterface>)module atTime:(UHRTimeUnit)time;
- (BOOL)checkOnLowContrainsForModule:(id<UHRModuleInterface>)module atTime:(UHRTimeUnit)time;
- (BOOL)passScriptForModule:(id<UHRModuleInterface>)module atTime:(UHRTimeUnit)time;
- (BOOL)callCallbackWithModule:(id<UHRModuleInterface>)module atTime:(UHRTimeUnit)time;

@end
