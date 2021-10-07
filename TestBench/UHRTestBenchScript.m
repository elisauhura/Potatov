//
//  UHRTestBenchScript.m
//  TestBench
//
//  Created by Elisa Silva on 07/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import "UHRTestBenchScript.h"

@interface UHRTestBenchScript ()

@property (nonatomic) NSDictionary *dictionary;
@property (nonatomic) BOOL useXCTestIntegrationFlag;

@end

@implementation UHRTestBenchScript

+ (instancetype)scriptFromDictionary:(NSDictionary *)dictionary {
    // TODO, in the future add proper contrains classes and transforms
    UHRTestBenchScript *script = [[self alloc] init];
    script->_dictionary = dictionary;
    
    return script;
}

- (void)useXCTestIntegration:(BOOL)flag {
    _useXCTestIntegrationFlag = flag;
}

- (BOOL)applyOnRiseChangesToModule:(id<UHRModuleInterface>)module atTime:(UHRTimeUnit)time {
    //NSDictionary *instructionsAtTime = [_dictionary objectForKey:@(time)];
    return YES;
}

- (BOOL)applyOnFallChangesToModule:(id<UHRModuleInterface>)module atTime:(UHRTimeUnit)time {
    return YES;
}

- (BOOL)checkOnHighContrainsForModule:(id<UHRModuleInterface>)module atTime:(UHRTimeUnit)time {
    return YES;
}
- (BOOL)checkOnLowContrainsForModule:(id<UHRModuleInterface>)module atTime:(UHRTimeUnit)time {
    return YES;
}

- (BOOL)passScriptForModule:(id<UHRModuleInterface>)module atTime:(UHRTimeUnit)time {
    if([_dictionary objectForKey:@(time)] != nil)
        return YES;
    return NO;
}
@end
