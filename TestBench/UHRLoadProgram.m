//
//  UHRLoadProgram.m
//  TestBench
//
//  Created by Elisa Silva on 15/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

#import "UHRLoadProgram.h"

@implementation UHRLoadProgram

+ (NSData *)dataForProgramNamed:(NSString *)aName {
    NSData *ret = nil;
    NSString *path = [NSProcessInfo.processInfo.environment objectForKey:@"PROGRAMSROOT"];
    if(path != nil) {
        ret = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@%@", path, aName]];
    }
    return ret;
}

@end
