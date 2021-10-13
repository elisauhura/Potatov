//
//  UHRModuleDispatch.m
//  Peeler
//
//  Created by Elisa Silva on 11/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import "UHRModuleDispatchManager.h"

static UHRModuleDispatchManager *dispatch = nil;

@interface UHRModuleDispatchHandlerRegistry : NSObject

@property UHRModuleDispatchHandler handler;
@property void * context;

- (instancetype)initWithHandler:(UHRModuleDispatchHandler)aHandler usingContext:(void *)aContext;

@end

@implementation UHRModuleDispatchHandlerRegistry

- (instancetype)initWithHandler:(UHRModuleDispatchHandler)aHandler usingContext:(void *)aContext
{
    self = [super init];
    if (self) {
        _handler = aHandler;
        _context = aContext;
    }
    return self;
}

@end

@interface UHRModuleDispatchManager ()

@property NSMutableArray *registry;

@end

@implementation UHRModuleDispatchManager

+ (instancetype)defaultDispatch {
    if(dispatch == nil)
        dispatch = [[self alloc] init];
    return dispatch;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _registry = [NSMutableArray new];
        [_registry addObject:NSNull.null];
    }
    return self;
}

- (unsigned int)dispatchFromSource:(unsigned int)aSource
                           request:(unsigned int)aRequest
                              arg0:(unsigned int)arg0
                              arg1:(unsigned int)arg1
                              arg2:(unsigned int)arg2 {
    if(aSource == 0 || aSource >= _registry.count) return 0;
    UHRModuleDispatchHandlerRegistry *registry = _registry[aSource];
    if([NSNull.null isEqual:registry]) return 0;
    return registry.handler(aSource, aRequest, arg0, arg1, arg2, registry.context);
}

- (unsigned int)registerHandler:(UHRModuleDispatchHandler)aHandler
                     withContex:(void *)context
                          forID:(unsigned int)anId {
    UInt32 ID = 0;
    if(anId == UHRModuleDisptachDefaultID) {
        [_registry addObject:[[UHRModuleDispatchHandlerRegistry alloc] initWithHandler:aHandler usingContext:context]];
        ID =  (unsigned int) [_registry count] - 1;
    }
    
    return ID;
}

- (unsigned int)removeHandlerForID:(unsigned int)anId {
    if(anId == 0 || anId >= _registry.count) return 1;
    _registry[anId] = [NSNull null];
    return 0;
}

@end

unsigned int UHRModuleDispatch(unsigned int source, unsigned int request, unsigned int arg0, unsigned int arg1, unsigned int arg2) {
    return [UHRModuleDispatchManager.defaultDispatch dispatchFromSource:source request:request arg0:arg0 arg1:arg1 arg2:arg2];
}

unsigned int UHRModuleDispatchRegisterHandlerForID(unsigned int _id, UHRModuleDispatchHandler handler,void * context) {
    return [UHRModuleDispatchManager.defaultDispatch registerHandler:handler withContex:context forID:_id];
}

unsigned int UHRModuleDispatchRemoveHandlerForID(unsigned int _id) {
    return [UHRModuleDispatchManager.defaultDispatch removeHandlerForID:_id];
}
