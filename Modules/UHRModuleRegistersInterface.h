//
//  UHRModuleRegistersInterface.h
//  Peeler
//
//  Created by Elisa Silva on 14/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#pragma once

#include <stdint.h>

enum UHRModuleRegistersSignal {
    UHRModuleRegistersSignalNone,
    UHRModuleRegistersSignalCReg1Address,
    UHRModuleRegistersSignalCReg2Address,
    UHRModuleRegistersSignalCRegDAddress,
    UHRModuleRegistersSignalCRegDData,
    UHRModuleRegistersSignalHReg1Data,
    UHRModuleRegistersSignalHReg2Data,
    UHRModuleRegistersSignalReset,
    UHRModuleRegistersSignalClock,
    UHRModuleRegistersSignalReg,
    UHRModuleRegistersSignalReg1 = UHRModuleRegistersSignalReg,
    UHRModuleRegistersSignalReg31 = UHRModuleRegistersSignalReg1 + 30,
};

void * UHRMakeRegisters(void);
void UHRDestroyRegisters(void *);
void UHRPokeRegisters(void *, int, uint32_t);
uint32_t UHRPeekRegisters(void *, int);
void UHREvalRegisters(void *, uint32_t);
