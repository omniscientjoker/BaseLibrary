//
//  GesturesTentacle.h
//  Environment_IOS
//
//  Created by joker on 2018/9/5.
//  Copyright © 2018 JM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GesturesTentacle : UIView
@property (nonatomic, copy) void(^drawRectFinishedBlock)(NSString *gesturePassword);
@end
