//
//  NSObject+common.m
//  BaseLibrary
//
//  Created by joker on 2018/12/25.
//  Copyright © 2018 joker. All rights reserved.
//

#import "NSObject+common.h"
#import <objc/runtime.h>

NSString *const YJClassType_object  =   @"对象类型";
NSString *const YJClassType_basic   =   @"基础数据类型";
NSString *const YJClassType_other   =   @"其它";

@implementation NSObject (common)
+ (instancetype)yj_initWithDictionary:(NSDictionary *)dic{
    id myObj = [[self alloc] init];
    unsigned int outCount;
    objc_property_t *arrPropertys = class_copyPropertyList([self class], &outCount);
    for (NSInteger i = 0; i < outCount; i ++) {
        objc_property_t property = arrPropertys[i];
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        id propertyValue = dic[propertyName];
        if (propertyValue == nil) {
            continue;
        }
        
        //获取属性是什么类型的
        NSDictionary *dicPropertyType = [self propertyTypeFromProperty:property];
        NSString *propertyClassType = [dicPropertyType objectForKey:@"classType"];
        NSString *propertyType = [dicPropertyType objectForKey:@"type"];
        if ([propertyType isEqualToString:YJClassType_object]) {
            if ([propertyClassType isEqualToString:@"NSArray"] || [propertyClassType isEqualToString:@"NSMutableArray"]) {
                //数组类型，现在还用不了，因为还没有方法知道数组中保存的是什么类型，后面会处理
                
            }
            else if ([propertyClassType isEqualToString:@"NSDictionary"] || [propertyClassType isEqualToString:@"NSMutableDictionary"]) {
                //字典类型   不考虑，一般不会用字典，用自定义model
                
            }
            else if ([propertyClassType isEqualToString:@"NSString"]) {
                //字符串类型
                if (propertyValue != nil) {
                    [myObj setValue:propertyValue forKey:propertyName];
                }
            }
            else {
                //自定义类型,循环调用，一直到不是自定义类型
                propertyValue = [NSClassFromString(propertyClassType) yj_initWithDictionary:propertyValue];
                if (propertyValue != nil) {
                    [myObj setValue:propertyValue forKey:propertyName];
                }
            }
        }
        else if ([propertyType isEqualToString:YJClassType_basic]) {
            //基本数据类型
            if ([propertyClassType isEqualToString:@"c"]) {
                //bool类型
                NSString *lowerValue = [propertyValue lowercaseString];
                if ([lowerValue isEqualToString:@"yes"] || [lowerValue isEqualToString:@"true"]) {
                    propertyValue = @(YES);
                } else if ([lowerValue isEqualToString:@"no"] || [lowerValue isEqualToString:@"false"]) {
                    propertyValue = @(NO);
                }
            }
            else {
                propertyValue = [[[NSNumberFormatter alloc] init] numberFromString:propertyValue];
            }
            
            if (propertyValue != nil) {
                [myObj setValue:propertyValue forKey:propertyName];
            }
        }
        else {
            //其他类型
        }
    }
    
    free(arrPropertys);
    
    return myObj;
}
//获取属性的类型
- (NSDictionary *)propertyTypeFromProperty:(objc_property_t)property{
    NSString *propertyAttrs = @(property_getAttributes(property));
    NSMutableDictionary *dicPropertyType = [NSMutableDictionary dictionary];
    //截取类型
    NSRange commaRange = [propertyAttrs rangeOfString:@","];
    NSString *propertyType = [propertyAttrs substringWithRange:NSMakeRange(1, commaRange.location - 1)];
    if ([propertyType hasPrefix:@"@"] && propertyType.length > 2) {
        NSString *propertyClassType = [propertyType substringWithRange:NSMakeRange(2, propertyType.length - 3)];
        [dicPropertyType setObject:propertyClassType forKey:@"classType"];
        [dicPropertyType setObject:YJClassType_object forKey:@"type"];
    }else if ([propertyType isEqualToString:@"q"]) {
        [dicPropertyType setObject:@"NSInteger" forKey:@"classType"];
        [dicPropertyType setObject:YJClassType_basic forKey:@"type"];
    }else if ([propertyType isEqualToString:@"d"]) {
        [dicPropertyType setObject:@"CGFloat" forKey:@"classType"];
        [dicPropertyType setObject:YJClassType_basic forKey:@"type"];
    }else if ([propertyType isEqualToString:@"c"]) {
        [dicPropertyType setObject:@"BOOL" forKey:@"classType"];
        [dicPropertyType setObject:YJClassType_basic forKey:@"type"];
    }else {
        [dicPropertyType setObject:YJClassType_other forKey:@"type"];
    }
    return dicPropertyType;
}
//model to diction
- (NSDictionary *)dictionaryFromModel{
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:count];
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [self valueForKey:key];
        if (key && value) {
            if ([value isKindOfClass:[NSString class]]
                || [value isKindOfClass:[NSNumber class]]) {
                [dict setObject:value forKey:key];
            }else if ([value isKindOfClass:[NSArray class]]
                      || [value isKindOfClass:[NSDictionary class]]) {
                [dict setObject:[self idFromObject:value] forKey:key];
            }else {
                [dict setObject:[value dictionaryFromModel] forKey:key];
            }
        }else if (key && value == nil) {
            //数值为空
            [dict setObject:@"" forKey:key];
        }
    }
    free(properties);
    return dict;
}
- (id)idFromObject:(nonnull id)object{
    if ([object isKindOfClass:[NSArray class]]) {
        if (object != nil && [object count] > 0) {
            NSMutableArray *array = [NSMutableArray array];
            for (id obj in object) {
                if ([obj isKindOfClass:[NSString class]]
                    || [obj isKindOfClass:[NSNumber class]]) {
                    [array addObject:obj];
                }else if ([obj isKindOfClass:[NSDictionary class]]
                          || [obj isKindOfClass:[NSArray class]]) {
                    [array addObject:[self idFromObject:obj]];
                }else {
                    [array addObject:[obj dictionaryFromModel]];
                }
            }
            return array;
        }else {
            return object ? : [NSArray new];
        }
    }else if ([object isKindOfClass:[NSDictionary class]]) {
        if (object && [[object allKeys] count] > 0) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            for (NSString *key in [object allKeys]) {
                if ([object[key] isKindOfClass:[NSNumber class]]
                    || [object[key] isKindOfClass:[NSString class]]) {
                    [dic setObject:object[key] forKey:key];
                }else if ([object[key] isKindOfClass:[NSArray class]]
                          || [object[key] isKindOfClass:[NSDictionary class]]) {
                    [dic setObject:[self idFromObject:object[key]] forKey:key];
                }else {
                    [dic setObject:[object[key] dictionaryFromModel] forKey:key];
                }
            }
            return dic;
        }else {
            return object ? : [NSDictionary new];
        }
    }else{
        return @"";
    }
}

//diction to model
+ (instancetype)modelWithDict:(NSDictionary *)dict{
    id obj = [self new];
    for (NSString *property in [self propertList]) {
        if (dict[property]) {
            [obj setValue:dict[property] forKey:property];
        }
    }
    return obj;
}
+ (NSArray *)propertList{
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i< count; i++) {
        objc_property_t property = propertyList[i];
        const char *cName = property_getName(property);
        NSString *name = [[NSString alloc]initWithUTF8String:cName];
        [arr addObject:name];
    }
    free(propertyList);
    return arr.copy;
}
@end
