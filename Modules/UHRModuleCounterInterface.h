//
//  UHRModuleCounter.h
//  PotatoChip
//
//  Created by Elisa Silva on 07/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#pragma once

#include <stdint.h>

enum UHRModuleCounterSignal {
    UHRModuleCounterSignalNone,
    UHRModuleCounterSignalCounter,
    UHRModuleCounterSignalReset,
    UHRModuleCounterSignalClock
};

void * UHRMakeCounter(void);
void UHRDestroyCounter(void *);
void UHRPokeCounter(void *, int, uint32_t);
uint32_t UHRPeekCounter(void *, int);
void UHREvalCounter(void *, uint32_t);
