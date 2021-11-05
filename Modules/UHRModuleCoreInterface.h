//
//  UHRModuleCoreInterface.h
//  Peeler
//
//  Created by Elisa Silva on 14/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#pragma once

#include <stdint.h>

enum UHRModuleCoreSignal {
    UHRModuleCoreSignalNone,
    // Memory Interface
    UHRModuleCoreSignalCCommand,
    UHRModuleCoreSignalCAddress,
    UHRModuleCoreSignalCData,
    UHRModuleCoreSignalHReady,
    UHRModuleCoreSignalHSignal,
    UHRModuleCoreSignalHData,
    // Shared
    UHRModuleCoreSignalReset,
    UHRModuleCoreSignalClock,
    // Internal
    UHRModuleCoreSignalPC,
    UHRModuleCoreSignalState,
    UHRModuleCoreSignalInstruction,
    UHRModuleCoreSignalReg1,
    UHRModuleCoreSignalReg31 = UHRModuleCoreSignalReg1 + 30,
    
};

void * UHRMakeCore(void);
void UHRDestroyCore(void *);
void UHRPokeCore(void *, int, uint32_t);
uint32_t UHRPeekCore(void *, int);
void UHREvalCore(void *, uint32_t);
