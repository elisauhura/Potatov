//
//  UHRModuleFIFOInterface.h
//  Peeler
//
//  Created by Elisa Silva on 25/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#pragma once

#include <stdint.h>

enum UHRModuleFIFOSignal {
    UHRModuleFIFOSignalNone,
    UHRModuleFIFOSignalCByte,
    UHRModuleFIFOSignalCPush,
    UHRModuleFIFOSignalCPop,
    UHRModuleFIFOSignalHByte,
    UHRModuleFIFOSignalHFull,
    UHRModuleFIFOSignalHEmpty,
    UHRModuleFIFOSignalReset,
    UHRModuleFIFOSignalClock,
};

void * UHRMakeFIFO(void);
void UHRDestroyFIFO(void *);
void UHRPokeFIFO(void *, int, uint32_t);
uint32_t UHRPeekFIFO(void *, int);
void UHREvalFIFO(void *, uint32_t);
