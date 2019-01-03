//
//  FingerManager.m
//  EnergyManager
//
//  Created by joker on 2018/3/26.
//  Copyright © 2018年 JM. All rights reserved.
//

#import "FingerManager.h"
#import <UIKit/UIKit.h>
#import <LocalAuthentication/LocalAuthentication.h>
@interface FingerManager ()
@property(nonatomic,strong) LAContext * context;
@end

@implementation FingerManager
//查询是否开启系统Touch ID
+ (FingerStatus)isSystemFingerOn{
    LAContext * context = [[LAContext alloc] init];
    NSError * error = nil;
    BOOL canEvaluatePolicy = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error];
    if (canEvaluatePolicy){
        return FingerStatusNormal;
    }else{
        switch (error.code) {
            case LAErrorBiometryNotEnrolled:{
                NSLog(@"");
                return FingerStatusTouchIDNotEnrolled;
                break;
            }
            case LAErrorPasscodeNotSet:{
                return FingerStatusPasscodeNotSet;
                break;
            }
            case LAErrorBiometryNotAvailable:{
                return FingerStatusTouchIDNotAvailable;
                break;
            }
            default:{
                if ([[[UIDevice currentDevice] systemVersion] intValue]<8.0) {
                    NSLog(@"手机版本过低，无法使用指纹锁");
                    return FingerStatusUnsupportSystemVersion;
                }else{
                    return FingerStatusOtherError;
                }
                break;
            }
        }
    }
}

//查询指纹解锁是否可用
+ (BOOL)isFingerUnlockAvailable{
    if ([self isSystemFingerOn]==FingerStatusNormal){
        return YES;
    }else{
        return NO;
    }
}

//验证指纹
+ (void)verifyFingerWithSuccessBlock:(void (^_Nonnull)(void))successBlock failBlock:(void(^_Nonnull)(FingerVerifyStatus error))failBlock{
    
    if ([self isSystemFingerOn]==FingerStatusNormal) {
        LAContext * context = [[LAContext alloc] init];
        context.localizedFallbackTitle = @"";
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"指纹登录" reply:^(BOOL success, NSError * _Nullable error) {
                    if (success) {
                        if (successBlock) {
                            successBlock();
                        }
                    }else{
                        switch (error.code) {
                            case LAErrorUserCancel:{
                                failBlock(FingerVerifyStatusUserCancel);
                                break;
                            }
                            case LAErrorAuthenticationFailed:{
                                failBlock(FingerVerifyAuthenticationFailed);
                                break;
                            }
                            case LAErrorBiometryLockout:{
                                [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"touchIdIsLocked"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                failBlock(FingerVerifyStatusTouchIDLockout);
                                break;
                            }
                            default:{
                                failBlock(FingerVerifyStatusOtherError);
                                break;
                            }
                        }
                    }
                }];
    }
}

+ (void)touchIdIsLocked{
    LAContext * context = [[LAContext alloc] init];
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"验证系统密码重新开启指纹密码登陆功能" reply:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"touchIdIsLocked"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];
}
+ (BOOL)isSupportFaceID{
    if (@available(iOS 8.0, *)) {
        LAContext * LAContent = [[LAContext alloc] init];
        NSError *authError = nil;
        BOOL isCanEvaluatePolicy = [LAContent canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError];
        if (authError) {
            return NO;
        } else {
            if (isCanEvaluatePolicy) {
                if (@available(iOS 11.0, *)) {
                    switch (LAContent.biometryType) {
                        case LABiometryTypeNone:{
                            return NO;
                        }
                            break;
                        case LABiometryTypeTouchID:{
                            return NO;
                        }
                            break;
                        case LABiometryTypeFaceID:{
                            return YES;
                        }
                            break;
                        default:
                            break;
                    }
                } else {
                    return NO;
                }
                
            } else {
                return NO;
            }
        }
        
    } else {
        return NO;
    }
}
@end
