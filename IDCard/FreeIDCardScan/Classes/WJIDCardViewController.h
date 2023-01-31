//
//  WJIDCardViewController..h
//  idcard
//
//  Created by 彭维剑 on 16-9-10.
//  Copyright (c) 2016年 Session. All rights reserved.
//  身份证扫描界面

#import <UIKit/UIKit.h>
#import "WJIDInfo.h"
#import "WJCapture.h"

@interface WJIDCardViewController : UIViewController<WJCaptureDelegate>
@property (nonatomic, weak) id<WJCaptureDelegate> delegate;
@property (nonatomic, copy) void (^idInfoBlock)(WJIDInfo *idInfo); /** 身份证信息 */
- (instancetype)initWithidInfoBlock:(void(^)(WJIDInfo *idInfo))aBlock;
- (void)closeAction;
@end
