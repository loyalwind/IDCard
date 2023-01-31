//
//  WJScanIDCardManager.h
//  idcard
//
//  Created by 彭维剑 on 16/9/12.
//  Copyright © 2016年 session. All rights reserved.
//  身份证扫描管理

#import <Foundation/Foundation.h>
#import "WJIDInfo.h"

@interface WJScanIDCardManager : NSObject

+ (instancetype)sharedManager;

/// 开始扫描身份证
/// - Parameter compeletion: 扫描结果回调
- (void)startScanIDCardWithCompeletion:(void(^)(WJIDInfo *idInfo))compeletion;
@end
