//
//  UHRModule_Private.h
//  Peeler
//
//  Created by Elisa Silva on 26/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import "UHRModule.h"

@interface UHRModule ()

@property void *module;
@property UHRMakeModule make;
@property UHRDestroyModule destroy;
@property UHRPokeModule poke;
@property UHRPeekModule peek;
@property UHREvalModule eval;
@property UHREnum clockSignal;
@property NSDictionary *signalNames;

@end
