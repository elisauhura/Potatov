//
//  UHRModuleSoftMemoryTests.m
//  PeelerTests
//
//  Created by Elisa Silva on 13/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "UHRModuleSoftMemory.h"
#import "UHRSoftRamModel.h"
#import "UHRMemoryInterface.h"
#import "UHRTestBench.h"
#import "UHRTestBenchScript.h"

@interface UHRModuleSoftMemoryTests : XCTestCase

@property UHRModuleSoftMemory *module;
@property UHRSoftRamModel *ram;

@end

@implementation UHRModuleSoftMemoryTests

- (void)setUp {
    _module = [UHRModuleSoftMemory new];
    
}

- (void)tearDown {
    _module = nil;
}

- (void)testMemoryReadWithDelayOf2 {
    _ram = [[UHRSoftRamModel alloc] initWithRAMSize:256 delay:2];
    [_ram loadDataToRAM:[NSData dataWithBytes:"abcdefghijklmnop" length:16]];
    [_module pokeSignal:UHRModuleSoftMemorySignalID withValue:_ram.memoryID];
    
    NSMutableDictionary *script = [NSMutableDictionary new];
    int commands[6] = {
        UHRMemoryInterfaceCommandReadWord,
        UHRMemoryInterfaceCommandReadWord,
        UHRMemoryInterfaceCommandReadShort,
        UHRMemoryInterfaceCommandReadShort,
        UHRMemoryInterfaceCommandReadByte,
        UHRMemoryInterfaceCommandReadByte
    };
    
    int addresses[6] = { 4, 0, 4, 0, 4, 0};
    int values[6] = {
        0x68676665,
        0x64636261,
        0x6665,
        0x6261,
        0x65,
        0x61
    };
    
    
    for(int i = 0; i < 6; i++) {
        script[@(i*4)] = @{
            @"applyOnRise": @[
                @(UHRModuleSoftMemorySignalCAddress),@(addresses[i]),
                @(UHRModuleSoftMemorySignalCCommand),@(commands[i]),
            ]
        };
        script[@(i*4+1)] = @{
            @"checkOnHigh": @[
                @(UHRModuleSoftMemorySignalHReady), @(0),
            ]
        };
        script[@(i*4+2)] = @{
            @"checkOnHigh": @[
                @(UHRModuleSoftMemorySignalHReady), @(1),
                @(UHRModuleSoftMemorySignalHData), @(values[i]),
            ]
        };
        script[@(i*4+3)] = @{
            @"applyOnRise": @[
                @(UHRModuleSoftMemorySignalCCommand),@(UHRMemoryInterfaceCommandNOP),
            ]
        };
    }
    
    script[@(6*4)] = @{
        @"pass": @{}
    };
    
    UHRTestBench *testBench = [[UHRTestBench alloc] initWithModule:_module withScript:[UHRTestBenchScript scriptFromDictionary:script]];
    
    XCTAssertTrue([testBench runTestBenchUpToTime:6*4+1]);
}

- (void)testMemoryReadWithDelayOf0 {
    _ram = [[UHRSoftRamModel alloc] initWithRAMSize:256 delay:0];
    [_ram loadDataToRAM:[NSData dataWithBytes:"abcdefghijklmnop" length:16]];
    [_module pokeSignal:UHRModuleSoftMemorySignalID withValue:_ram.memoryID];
    
    NSMutableDictionary *script = [NSMutableDictionary new];
    int commands[6] = {
        UHRMemoryInterfaceCommandReadWord,
        UHRMemoryInterfaceCommandReadWord,
        UHRMemoryInterfaceCommandReadShort,
        UHRMemoryInterfaceCommandReadShort,
        UHRMemoryInterfaceCommandReadByte,
        UHRMemoryInterfaceCommandReadByte
    };
    
    int addresses[6] = { 4, 0, 4, 0, 4, 0};
    int values[6] = {
        0x68676665,
        0x64636261,
        0x6665,
        0x6261,
        0x65,
        0x61
    };
    
    
    for(int i = 0; i < 6; i++) {
        script[@(i*2)] = @{
            @"applyOnRise": @[
                @(UHRModuleSoftMemorySignalCAddress),@(addresses[i]),
                @(UHRModuleSoftMemorySignalCCommand),@(commands[i]),
            ],
            @"checkOnHigh": @[
                @(UHRModuleSoftMemorySignalHReady), @(1),
                @(UHRModuleSoftMemorySignalHData), @(values[i]),
            ]
        };
        script[@(i*2+1)] = @{
            @"applyOnRise": @[
                @(UHRModuleSoftMemorySignalCCommand),@(UHRMemoryInterfaceCommandNOP),
            ]
        };
    }
    
    script[@(6*2)] = @{
        @"pass": @{}
    };
    
    UHRTestBench *testBench = [[UHRTestBench alloc] initWithModule:_module withScript:[UHRTestBenchScript scriptFromDictionary:script]];
    
    XCTAssertTrue([testBench runTestBenchUpToTime:6*2+1]);
}

- (void)testMemoryWriteWithDelayOf2 {
    _ram = [[UHRSoftRamModel alloc] initWithRAMSize:256 delay:2];
    [_ram loadDataToRAM:[NSData dataWithBytes:"abcdefghijklmnop" length:16]];
    [_module pokeSignal:UHRModuleSoftMemorySignalID withValue:_ram.memoryID];
    
    NSMutableDictionary *script = [NSMutableDictionary new];
    int commands[6] = {
        UHRMemoryInterfaceCommandWriteWord,
        UHRMemoryInterfaceCommandWriteWord,
        UHRMemoryInterfaceCommandWriteShort,
        UHRMemoryInterfaceCommandWriteShort,
        UHRMemoryInterfaceCommandWriteByte,
        UHRMemoryInterfaceCommandWriteByte
    };
    
    int addresses[6] = { 0, 4, 8, 10, 12, 13};
    int values[6] = {
        0x61616161,
        0x62626262,
        0x6363,
        0x6464,
        0x65,
        0x66
    };
    
    
    for(int i = 0; i < 6; i++) {
        script[@(i*4)] = @{
            @"applyOnRise": @[
                @(UHRModuleSoftMemorySignalCAddress),@(addresses[i]),
                @(UHRModuleSoftMemorySignalCCommand),@(commands[i]),
                @(UHRModuleSoftMemorySignalCData),@(values[i])
            ]
        };
        script[@(i*4+1)] = @{
            @"checkOnHigh": @[
                @(UHRModuleSoftMemorySignalHReady), @(0),
            ]
        };
        script[@(i*4+2)] = @{
            @"checkOnHigh": @[
                @(UHRModuleSoftMemorySignalHReady), @(1),
            ]
        };
        script[@(i*4+3)] = @{
            @"applyOnRise": @[
                @(UHRModuleSoftMemorySignalCCommand),@(UHRMemoryInterfaceCommandNOP),
            ]
        };
    }
    
    script[@(6*4)] = @{
        @"pass": @{}
    };
    
    UHRTestBench *testBench = [[UHRTestBench alloc] initWithModule:_module withScript:[UHRTestBenchScript scriptFromDictionary:script]];
    
    XCTAssertTrue([testBench runTestBenchUpToTime:6*4+1]);
    
    XCTAssert(memcmp(_ram.ramBytes, "aaaabbbbccddef", 14) == 0);
}

- (void)testMemoryWriteWithDelayOf0 {
    _ram = [[UHRSoftRamModel alloc] initWithRAMSize:256 delay:0];
    [_ram loadDataToRAM:[NSData dataWithBytes:"abcdefghijklmnop" length:16]];
    [_module pokeSignal:UHRModuleSoftMemorySignalID withValue:_ram.memoryID];
    
    NSMutableDictionary *script = [NSMutableDictionary new];
    int commands[6] = {
        UHRMemoryInterfaceCommandWriteWord,
        UHRMemoryInterfaceCommandWriteWord,
        UHRMemoryInterfaceCommandWriteShort,
        UHRMemoryInterfaceCommandWriteShort,
        UHRMemoryInterfaceCommandWriteByte,
        UHRMemoryInterfaceCommandWriteByte
    };
    
    int addresses[6] = { 0, 4, 8, 10, 12, 13};
    int values[6] = {
        0x61616161,
        0x62626262,
        0x6363,
        0x6464,
        0x65,
        0x66
    };
    
    
    for(int i = 0; i < 6; i++) {
        script[@(i*2)] = @{
            @"applyOnRise": @[
                @(UHRModuleSoftMemorySignalCAddress),@(addresses[i]),
                @(UHRModuleSoftMemorySignalCCommand),@(commands[i]),
                @(UHRModuleSoftMemorySignalCData),@(values[i])
            ],
            @"checkOnHigh": @[
                @(UHRModuleSoftMemorySignalHReady), @(1),
            ]
        };
        script[@(i*2+1)] = @{
            @"applyOnRise": @[
                @(UHRModuleSoftMemorySignalCCommand),@(UHRMemoryInterfaceCommandNOP),
            ]
        };
    }
    
    script[@(6*2)] = @{
        @"pass": @{}
    };
    
    UHRTestBench *testBench = [[UHRTestBench alloc] initWithModule:_module withScript:[UHRTestBenchScript scriptFromDictionary:script]];
    
    XCTAssertTrue([testBench runTestBenchUpToTime:6*2+1]);
    
    XCTAssert(memcmp(_ram.ramBytes, "aaaabbbbccddef", 14) == 0);
}

@end
