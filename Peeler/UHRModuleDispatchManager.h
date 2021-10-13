//
//  UHRModuleDispatchManager.h
//  Peeler
//
//  Created by Elisa Silva on 11/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#pragma once

#include <Foundation/Foundation.h>
#import "UHRModuleDispatch.h"

@interface UHRModuleDispatchManager : NSObject

+ (instancetype)defaultDispatch;

- (unsigned int)dispatchFromSource:(unsigned int)aSource
                           request:(unsigned int)aRequest
                              arg0:(unsigned int)arg0
                              arg1:(unsigned int)arg1
                              arg2:(unsigned int)arg2;

- (unsigned int)registerHandler:(UHRModuleDispatchHandler)aHandler
                     withContex:(void *)context
                          forID:(unsigned int)anId;

- (unsigned int)removeHandlerForID:(unsigned int)anId;

@end
