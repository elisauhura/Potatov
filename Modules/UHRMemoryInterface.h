//
//  UHRMemoryInterface.h
//  Peeler
//
//  Created by Elisa Silva on 13/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#pragma once

/// @brief: Avaiable memory interface commands
enum UHRMemoryInterfaceCommand {
    UHRMemoryInterfaceCommandNOP,
    UHRMemoryInterfaceCommandReadByte,
    UHRMemoryInterfaceCommandReadShort,
    UHRMemoryInterfaceCommandReadWord,
    UHRMemoryInterfaceCommandWait,
    UHRMemoryInterfaceCommandWriteByte,
    UHRMemoryInterfaceCommandWriteShort,
    UHRMemoryInterfaceCommandWriteWord
};
