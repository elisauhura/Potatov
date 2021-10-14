//
//  TestBench.m
//  TestBench
//
//  Created by Elisa Silva on 07/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "UHRTestBench.h"
#import "UHRTestBenchScript.h"

@interface UHRTestBench ()

@property (nonatomic) id<UHRModuleInterface>module;
@property (nonatomic) UHRTestBenchScript *script;

@end

@implementation UHRTestBench

- (instancetype)initWithModule:(id<UHRModuleInterface>)module withScript:(UHRTestBenchScript *)script {
    self = [super init];
    if(self != nil) {
        _module = module;
        _script = script;
        
        [_script useXCTestIntegration:YES];
    }
    return self;
}

- (BOOL)runTestBenchUpToTime:(UHRTimeUnit)time {
    UHRTimeUnit simulationTime = 0;
    while(simulationTime < time) {
        [_module pokeSignal:[_module clockSignal] withValue:1];
        [_script applyOnRiseChangesToModule:_module atTime:simulationTime];
        [_module evaluateStateAtTime:10+simulationTime*10];
        [_script checkOnHighContrainsForModule:_module atTime:simulationTime];
        
        [_module pokeSignal:[_module clockSignal] withValue:0];
        [_script applyOnFallChangesToModule:_module atTime:simulationTime];
        [_module evaluateStateAtTime:15+simulationTime*10];
        [_script checkOnLowContrainsForModule:_module atTime:simulationTime];
        
        [_script callCallbackWithModule:_module atTime:simulationTime];
        
        if([_script passScriptForModule:_module atTime:simulationTime]) {
            break;
        }
        
        simulationTime++;
    }
    return simulationTime < time;
}

@end
