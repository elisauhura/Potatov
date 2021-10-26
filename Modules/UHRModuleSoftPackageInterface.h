//
//  UHRModuleSoftPackageInterface.h
//  Peeler
//
//  Created by Elisa Silva on 15/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#pragma once

#include <stdint.h>

enum UHRModuleSoftPackageSignal {
    UHRModuleSoftPackageSignalNone,
    // Memory Interface
    UHRModuleSoftPackageSignalCCommand,
    UHRModuleSoftPackageSignalCAddress,
    UHRModuleSoftPackageSignalCData,
    UHRModuleSoftPackageSignalHReady,
    UHRModuleSoftPackageSignalHSignal,
    UHRModuleSoftPackageSignalHData,
    // Shared
    UHRModuleSoftPackageSignalReset,
    UHRModuleSoftPackageSignalClock,
    // Internal
    UHRModuleSoftPackageSignalPC,
    UHRModuleSoftPackageSignalState,
    UHRModuleSoftPackageSignalInstruction,
    UHRModuleSoftPackageSignalMemoryID,
};

void * UHRMakeSoftPackage(void);
void UHRDestroySoftPackage(void *);
void UHRPokeSoftPackage(void *, int, uint32_t);
uint32_t UHRPeekSoftPackage(void *, int);
void UHREvalSoftPackage(void *, uint32_t);
