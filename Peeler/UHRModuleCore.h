//
//  UHRModuleCore.h
//  Peeler
//
//  Created by Elisa Silva on 14/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import "UHRModule.h"
#import "UHRModuleCoreInterface.h"

typedef NS_ENUM(NSUInteger, UHRModuleCoreState) {
    UHRModuleCoreStateInit,
    UHRModuleCoreStateFetch,
    UHRModuleCoreStateFetchWaitReady,
    UHRModuleCoreStateStall = 999
};

@interface UHRModuleCore : UHRModule

@end
