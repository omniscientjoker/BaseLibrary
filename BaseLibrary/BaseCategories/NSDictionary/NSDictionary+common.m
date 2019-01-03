//
//  NSDictionary+common.m
//  EnergyManager
//
//  Created by joker on 2018/3/21.
//  Copyright © 2018年 JM. All rights reserved.
//

#import "NSDictionary+common.h"
#import <objc/runtime.h>
@implementation NSDictionary (common)
- (NSString *)JSONString{
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (error != nil) {
        NSLog(@"NSDictionary JSONString error: %@", [error localizedDescription]);
        return nil;
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}
@end
