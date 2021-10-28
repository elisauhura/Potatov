//
//  UHRModuleUARTInterface.h
//  Peeler
//
//  Created by Elisa Silva on 28/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#pragma once

#include <stdint.h>

enum UHRModuleUARTSignal {
    UHRModuleUARTSignalNone,
    UHRModuleUARTSignalCByte,
    UHRModuleUARTSignalCRead,
    UHRModuleUARTSignalCWrite,
    UHRModuleUARTSignalHByte,
    UHRModuleUARTSignalHCanRead,
    UHRModuleUARTSignalHCanWrite,
    UHRModuleUARTSignalTX,
    UHRModuleUARTSignalRX,
    UHRModuleUARTSignalReset,
    UHRModuleUARTSignalClock,
};

void * UHRMakeUART(void);
void UHRDestroyUART(void *);
void UHRPokeUART(void *, int, uint32_t);
uint32_t UHRPeekUART(void *, int);
void UHREvalUART(void *, uint32_t);
