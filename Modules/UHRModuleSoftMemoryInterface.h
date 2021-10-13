//
//  UHRModuleSoftMemoryInterface.h
//  PotatoChip
//
//  Created by Elisa Silva on 11/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#pragma once

#include <stdint.h>

enum UHRModuleSoftMemorySignal {
    UHRModuleSoftMemorySignalNone,
    UHRModuleSoftMemorySignalCCommand,
    UHRModuleSoftMemorySignalCAddress,
    UHRModuleSoftMemorySignalHReady,
    UHRModuleSoftMemorySignalHSignal,
    UHRModuleSoftMemorySignalHData,
    UHRModuleSoftMemorySignalReset,
    UHRModuleSoftMemorySignalClock,
};

void * UHRMakeSoftMemory(void);
void UHRDestroySoftMemory(void *);
void UHRPokeSoftMemory(void *, int, uint32_t);
uint32_t UHRPeekSoftMemory(void *, int);
void UHREvalSoftMemory(void *, uint32_t);
