//
//  FingerManager.h
//  EnergyManager
//
//  Created by joker on 2018/3/26.
//  Copyright © 2018年 JM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FingerManagerMacro.h"

typedef void(^TouchIDPaymentBlock)(BOOL status);
typedef void(^FingerErrorBlock)(FingerVerifyStatus errorType);
typedef void(^TypeBackBlock)(FingerStatus Type);

@interface FingerManager : NSObject

//查询是否开启系统Touch ID
+ (FingerStatus)isSystemFingerOn;

//查询指纹解锁是否可用
+ (BOOL)isFingerUnlockAvailable;


//验证指纹
+ (void)verifyFingerWithSuccessBlock:(void (^_Nonnull)(void))successBlock failBlock:(void(^_Nonnull)(FingerVerifyStatus error))failBlock;
+ (void)touchIdIsLocked;
+ (BOOL)isSupportFaceID;
@end
