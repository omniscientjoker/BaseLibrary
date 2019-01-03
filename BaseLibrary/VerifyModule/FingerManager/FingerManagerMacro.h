//
//  FingerManagerMacro.h
//  EnergyManager
//
//  Created by joker on 2018/3/26.
//  Copyright © 2018年 JM. All rights reserved.
//

#ifndef FingerManagerMacro_h
#define FingerManagerMacro_h

#define IsSupportFaceID [FingerManager isSupportFaceID]

#define ACCOUNT_LOGIN @"用登录密码验证解锁"
#define messageTitle  IsSupportFaceID ? @"FaceID":@"TouchID"
#define messageInfo   IsSupportFaceID ? @"是否开启面容ID解锁?":@"是否开启指纹密码?"
#define LogoImageName IsSupportFaceID ? @"icon_faceID" : @"icon_finger"
#define FINGER_LOGIN  IsSupportFaceID ? @"点击进行面容ID解锁" : @"点击指纹进行指纹解锁"
#define BiometryLoginChangedInfo IsSupportFaceID ? @"你的面容ID信息发生变更，请在手机中重新添加面容ID后返回解锁或直接使用密码登录" : @"你的指纹信息发生变更，请在手机中重新添加指纹后返回解锁或直接使用密码登录"

typedef NS_ENUM(NSInteger, FingerStatus){
    FingerStatusNormal = 1,               //设备支持Touch ID并且已设置过指纹
    FingerStatusPasscodeNotSet,           //设备支持Touch ID，未设置密码
    FingerStatusTouchIDNotEnrolled,       //系统未录入指纹
    FingerStatusUnsupportSystemVersion,   //系统版本过低，低于iOS8
    FingerStatusTouchIDNotAvailable,      //设备不支持Touch ID
    FingerStatusOtherError                //其他错误
};

typedef NS_ENUM(NSInteger, FingerVerifyStatus){
    FingerVerifyStatusSuccess = 1,       //验证成功
    FingerVerifyStatusOtherError,        //其他错误
    FingerVerifyStatusUserCancel,        //用户取消验证
    FingerVerifyStatusTouchIDLockout,    //验证失败次数超限
    FingerVerifyStatusDateChanged,       //指纹数据更改需要重新验证
    FingerVerifyAuthenticationFailed     //指纹认证授权失败
};

#endif /* FingerManagerMacro_h */
