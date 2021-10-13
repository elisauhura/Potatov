//
//  UHRSoftRamModel.h
//  Peeler
//
//  Created by Elisa Silva on 11/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UHRSoftRamModel : NSObject

- (instancetype)initWithRAMSize:(UInt32)ramSize delay:(UInt32)delay;
- (UInt32)memoryID;
- (void)loadDataToRAM:(NSData *)data;
- (void *)ramBytes;
- (UInt32)ramLength;

@end
