//
//  NSObject+common.h
//  BaseLibrary
//
//  Created by joker on 2018/12/25.
//  Copyright © 2018 joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (common)
- (NSDictionary *)dictionaryFromModel;
+ (instancetype)modelWithDict:(NSDictionary *)dict;
@end
