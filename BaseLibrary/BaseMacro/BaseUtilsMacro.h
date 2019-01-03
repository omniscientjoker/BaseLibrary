//
//  BaseUtilsMacro.h
//  BaseLibrary
//
//  Created by joker on 2018/11/26.
//  Copyright © 2018 joker. All rights reserved.
//

#ifndef BaseUtilsMacro_h
#define BaseUtilsMacro_h

//系统版本
#define  SYS_Version   [[UIDevice currentDevice] systemVersion]
//CF号
#define  SYS_CFBundle  [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]
//DEVICE_TOKEN
#define  DEVICE_TOKEN  @"DEVICE_TOKEN"

//屏幕尺寸
#define SCREENWIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREENHEIGHT [[UIScreen mainScreen] bounds].size.height

//定义weakself宏
#define JMWeakSelfDefine __weak __typeof(&*self) weakSelf = self

///是否为空或是[NSNull null]
#define NotNilAndNull(_ref)     (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]))
#define IsNilOrNull(_ref)       (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))
#define __STRINGNOTNIL( __x )   (__x?__x:@"")
//字符串是否为空
#define  STR_NON_NIL(str) ([NSString kqc_isBlank:str] ? @"" : str)
///字符串是否为空
#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))
///数组是否为空
#define IsArrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))


#endif /* BaseUtilsMacro_h */
