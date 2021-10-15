//
//  UHRModuleALUInterface.h
//  Peeler
//
//  Created by Elisa Silva on 14/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#include <stdint.h>

enum UHRModuleALUSignal {
    UHRModuleALUSignalNone,
    UHRModuleALUSignalA,
    UHRModuleALUSignalB,
    UHRModuleALUSignalOut,
    UHRModuleALUSignalFunct3,
    UHRModuleALUSignalFunct7_5b,
};

void * UHRMakeALU(void);
void UHRDestroyALU(void *);
void UHRPokeALU(void *, int, uint32_t);
uint32_t UHRPeekALU(void *, int);
void UHREvalALU(void *, uint32_t);
