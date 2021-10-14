//
//  UHRTestBenchScript.m
//  TestBench
//
//  Created by Elisa Silva on 07/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "UHRTestBenchScript.h"

@interface UHRTestBenchScript ()

@property (nonatomic) NSDictionary *dictionary;
@property (nonatomic) BOOL useXCTestIntegrationFlag;

@end

@implementation UHRTestBenchScript

+ (instancetype)scriptFromDictionary:(NSDictionary *)dictionary {
    // TODO, in the future add proper contrains classes and transforms
    UHRTestBenchScript *script = [[self alloc] init];
    script->_dictionary = [dictionary copy];
    
    return script;
}

- (void)useXCTestIntegration:(BOOL)aFlag {
    _useXCTestIntegrationFlag = aFlag;
}

- (BOOL)applyOnRiseChangesToModule:(id<UHRModuleInterface>)module atTime:(UHRTimeUnit)time {
    NSDictionary *instructionsAtTime = [_dictionary objectForKey:@((int)time)];
    NSArray *definitions;
    
    if(instructionsAtTime != nil &&
       (definitions = [instructionsAtTime objectForKey:@"applyOnRise"]) &&
       [definitions isKindOfClass:[NSArray class]]) {
        
        for(int i = 0; i < [definitions count]; i += 2) {
            UHREnum signal = [[definitions objectAtIndex:i] intValue];
            UHRWord value = [[definitions objectAtIndex:i+1] unsignedIntValue];
            [module pokeSignal:signal withValue:value];
        }
    }
    return YES;
}

- (BOOL)applyOnFallChangesToModule:(id<UHRModuleInterface>)module atTime:(UHRTimeUnit)time {
    NSDictionary *instructionsAtTime = [_dictionary objectForKey:@((int)time)];
    NSArray *definitions;
    
    if(instructionsAtTime != nil &&
       (definitions = [instructionsAtTime objectForKey:@"applyOnFall"]) &&
       [definitions isKindOfClass:[NSArray class]]) {
        
        for(int i = 0; i < [definitions count]; i += 2) {
            UHREnum signal = [[definitions objectAtIndex:i] intValue];
            UHRWord value = [[definitions objectAtIndex:i+1] unsignedIntValue];
            [module pokeSignal:signal withValue:value];
        }
    }
    return YES;
}

- (BOOL)checkOnHighContrainsForModule:(id<UHRModuleInterface>)module atTime:(UHRTimeUnit)time {
    NSDictionary *instructionsAtTime = [_dictionary objectForKey:@((int)time)];
    NSArray *definitions;
    if(instructionsAtTime != nil &&
       (definitions = [instructionsAtTime objectForKey:@"checkOnHigh"]) &&
       [definitions isKindOfClass:[NSArray class]]) {
        
        for(int i = 0; i < [definitions count]; i += 2) {
            UHREnum signal = [[definitions objectAtIndex:i] intValue];
            UHRWord expectedValue = [[definitions objectAtIndex:i+1] unsignedIntValue];
            UHRWord observedValue = [module peekSignal:signal];
            
            if(expectedValue != observedValue) {
                if(_useXCTestIntegrationFlag) {
                    XCTFail(@"checkOnHigh failed @%u; signal %d returned %u when expecting %u.",
                            time, signal, observedValue, expectedValue);
                } else {
                    return NO;
                }
            }
        }
    }
    return YES;
}

- (BOOL)checkOnLowContrainsForModule:(id<UHRModuleInterface>)module atTime:(UHRTimeUnit)time {
    NSDictionary *instructionsAtTime = [_dictionary objectForKey:@((int)time)];
    NSArray *definitions;
    if(instructionsAtTime != nil &&
       (definitions = [instructionsAtTime objectForKey:@"checkOnLow"]) &&
       [definitions isKindOfClass:[NSArray class]]) {
        
        for(int i = 0; i < [definitions count]; i += 2) {
            UHREnum signal = [[definitions objectAtIndex:i] intValue];
            UHRWord expectedValue = [[definitions objectAtIndex:i+1] unsignedIntValue];
            UHRWord observedValue = [module peekSignal:signal];
            
            if(expectedValue != observedValue) {
                if(_useXCTestIntegrationFlag) {
                    XCTFail(@"checkOnLow failed @%u; signal %d returned %u when expecting %u.",
                            time, signal, observedValue, expectedValue);
                } else {
                    return NO;
                }
            }
        }
    }
    return YES;
}

- (BOOL)callCallbackWithModule:(id<UHRModuleInterface>)module atTime:(UHRTimeUnit)time {
    NSDictionary *instructionsAtTime = [_dictionary objectForKey:@((int)time)];
    BOOL (^callback)(id<UHRModuleInterface> module, UHRTimeUnit time);
    
    if(instructionsAtTime != nil &&
       (callback = [instructionsAtTime objectForKey:@"callback"]) &&
       [callback isKindOfClass:NSClassFromString(@"NSBlock")]) {
        return callback(module, time);
    }
    return YES;
}

- (BOOL)passScriptForModule:(id<UHRModuleInterface>)module atTime:(UHRTimeUnit)time {
    NSDictionary *instructionsAtTime = [_dictionary objectForKey:@((int)time)];
    if(instructionsAtTime != nil) {
        if([instructionsAtTime objectForKey:@"pass"] != nil) {
            return YES;
        }
    }
    return NO;
}
@end
