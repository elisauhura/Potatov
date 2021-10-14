//
//  UHRSoftRamModel.m
//  Peeler
//
//  Created by Elisa Silva on 11/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import "UHRSoftRamModel.h"
#import "UHRModuleDispatch.h"
#import "UHRModuleDispatchManager.h"
#import "UHRMemoryInterface.h"

@interface UHRSoftRamModel ()

@property NSMutableData *data;
@property UInt32 memoryID;
@property UInt32 delay;

@end

static unsigned int softRamHandler (unsigned int source, unsigned int request, unsigned int arg0, unsigned int arg1, unsigned int arg2, void * context);

@implementation UHRSoftRamModel

- (instancetype)initWithRAMSize:(UInt32)ramSize delay:(UInt32)delay {
    self = [super init];
    if (self) {
        _data = [[NSMutableData alloc] initWithLength:ramSize];
        _delay = delay;
        _memoryID = [UHRModuleDispatchManager.defaultDispatch registerHandler:softRamHandler withContex:(__bridge void *)(self) forID:UHRModuleDisptachDefaultID];
    }
    return self;
}

- (void)dealloc {
    [UHRModuleDispatchManager.defaultDispatch removeHandlerForID:_memoryID];
}

- (void)loadDataToRAM:(NSData *)data {
    NSUInteger length = [data length] > [self.data length] ? [self.data length] : [data length];
    [self.data replaceBytesInRange:NSMakeRange(0, length) withBytes:data.bytes length:length];
}

- (void *)ramBytes {
    return (void *)[self.data mutableBytes];
}

- (UInt32)ramLength {
    return (UInt32)[self.data length];
}

- (UInt32)handleCommand:(UInt32)command withAddress:(UInt32)address data:(UInt32)data {
    int width = 0;
    UInt32 ret = 0;
    
    switch(command) {
        case UHRMemoryInterfaceCommandRBA:
        case UHRMemoryInterfaceCommandRBB:
            width = 1;
            goto read;
        case UHRMemoryInterfaceCommandRSA:
        case UHRMemoryInterfaceCommandRSB:
            width = 2;
            goto read;
        case UHRMemoryInterfaceCommandRWA:
        case UHRMemoryInterfaceCommandRWB:
            width = 4;
        read:
            ret = [self readAtAddress:address withWidth:width];
            break;
        case UHRMemoryInterfaceCommandWBA:
        case UHRMemoryInterfaceCommandWBB:
            width = 1;
            goto write;
        case UHRMemoryInterfaceCommandWSA:
        case UHRMemoryInterfaceCommandWSB:
            width = 2;
            goto write;
        case UHRMemoryInterfaceCommandWWA:
        case UHRMemoryInterfaceCommandWWB:
            width = 4;
        write:
            [self writeAtAddress:address withWidth:width value:data];
            break;
        case UHRMemoryInterfaceCommandHAW:
        case UHRMemoryInterfaceCommandDRA:
        case UHRMemoryInterfaceCommandDRB:
        default:
            break;
    }
    return ret;
}

- (UInt32)readAtAddress:(UInt32)address withWidth:(int)width {
    UInt32 ret = 0;
    if(address + width <= [self.data length]) {
        char *bytes = [self.data mutableBytes];
        for(int i = width - 1; i >= 0; i--) {
            ret = (ret << 8) + bytes[address+i];
        }
    }
    return ret;
}

- (void)writeAtAddress:(UInt32)address withWidth:(int)width value:(UInt32)value {
    if(address + width <= [self.data length]) {
        char *bytes = [self.data mutableBytes];
        for(int i = 0; i < width; i++) {
            bytes[address+i] = value & 0xFF;
            value >>= 8;
        }
    }
}

@end

static unsigned int softRamHandler (unsigned int source, unsigned int request, unsigned int arg0, unsigned int arg1, unsigned int arg2, void * context) {
    UHRSoftRamModel *model = (__bridge UHRSoftRamModel *)(context);
    UInt32 ret = 0;
    
    switch(request) {
        case UHRModuleDispatchRequestMemoryInterfaceGetDelayFor:
            ret = model.delay;
            break;
        case UHRModuleDispatchRequestMemoryInterfaceDoOperation:
            ret = [model handleCommand:arg0 withAddress:arg1 data:arg2];
            break;
    }
    
    return ret;
}
