//
//  UHRModuleDispatch.h
//  Peeler
//
//  Created by Elisa Silva on 11/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#pragma once

enum UHRModuleDispatchRequest {
    UHRModuleDispatchRequestNothing = 0,
    UHRModuleDispatchRequestMemoryInterfaceGetDelayFor = 1,
    UHRModuleDispatchRequestMemoryInterfaceDoOperation = 2,
};

typedef unsigned int (*UHRModuleDispatchHandler) (unsigned int source, unsigned int request, unsigned int arg0, unsigned int arg1, unsigned int arg2, void * context);

unsigned int UHRModuleDispatch(unsigned int source, unsigned int request, unsigned int arg0, unsigned int arg1, unsigned int arg2);

unsigned int UHRModuleDispatchRegisterHandlerForID(unsigned int id, UHRModuleDispatchHandler handler,void * context);

unsigned int UHRModuleDispatchRemoveHandlerForID(unsigned int id);

const unsigned int UHRModuleDisptachDefaultID = 0;


