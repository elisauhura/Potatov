//
//  UHRPeelerTypes.h
//  Peeler
//
//  Created by Elisa Silva on 07/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#pragma once

typedef UInt32  UHRWord;
typedef int     UHREnum;
typedef UInt32  UHRTimeUnit;

typedef void *(*UHRMakeModule)(void);
typedef void (*UHRDestroyModule)(void *);
typedef void (*UHRPokeModule)(void *, int, uint32_t);
typedef uint32_t (*UHRPeekModule)(void *, int);
typedef void (*UHREvalModule)(void *, uint32_t);
