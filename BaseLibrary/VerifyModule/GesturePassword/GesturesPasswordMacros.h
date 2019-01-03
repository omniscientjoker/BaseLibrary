//
//  GesturesPasswordMacros.h
//  Environment_IOS
//
//  Created by joker on 2018/9/5.
//  Copyright © 2018 JM. All rights reserved.
//

#ifndef GesturesPasswordMacros_h
#define GesturesPasswordMacros_h

#define MAX_TRY                  5
#define WAIT_UNLOCK_MINUTES      10
#define INFOMESSAGE_LOGIN        @"请输入正确的手势密码进行解锁"
#define INFOMESSAGE_SETING       @"请输入新的手势密码"
#define ERRORMESSAGE_MAX_TRY     @"尝试解锁错误次数超出限制，请稍后尝试，或选择密码登陆"
#define ERRORMESSAGE_VERIFY      @"两次输入的手势密码不相符，请输入相同的手势密码"
#define ERRORMESSAGE_FAIL        @"手势密码错误，请再次输入正确的手势密码"
#define ERRORMESSAGE_SHORT       @"手势密码不符合要求，请确保最少有四位"
#define ERRORMESSAGE_CHANGEFAIL  @"已有手势密码验证错误，请稍后再次尝试"
typedef NS_ENUM(NSInteger, GestureViewType) {
    GestureViewTypeSetting,  //修改View
    GestureViewTypeLogin,    //登录View
    GestureViewTypeDelete,   //删除View
};

typedef NS_ENUM(NSInteger, ShowGestureType) {
    ShowGestureTypeChange,   //修改页
    ShowGestureTypeLogin,    //登录页
    ShowGestureTypeSeting,   //设置页
};

#endif /* GesturesPasswordMacros_h */
