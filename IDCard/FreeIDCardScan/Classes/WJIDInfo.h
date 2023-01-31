//
//  WJIDInfo.h
//  idcard
//
//  Created by 彭维剑 on 16-9-10.
//  Copyright (c) 2016年 Session. All rights reserved.
//  身份证信息

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,WJIDInfoType) {
    WJIDInfoTypeFront = 1, /**< 1:正面 */
    WJIDInfoTypeBack = 2, /**< 2:反面 */
};

@interface WJIDInfo : NSObject

@property (nonatomic, assign) WJIDInfoType type; /**< 1:正面  2:反面 */
@property (nonatomic, copy) NSString *code; /**< 身份证号 */
@property (nonatomic, copy) NSString *name; /**< 姓名 */
@property (nonatomic, copy) NSString *gender; /**< 性别 */
@property (nonatomic, copy) NSString *nation; /**< 民族 */
@property (nonatomic, copy) NSString *address; /**< 地址 */
@property (nonatomic, copy) NSString *issue; /**< 签发机关 */
@property (nonatomic, copy) NSString *valid; /**< 有效期 */
@property (nonatomic, copy) NSString *birth; /**< 出生日期 */
@property (nonatomic, strong) UIImage *curImage; /**< 当前身份证拍摄照片 */
@property (nonatomic, strong) UIImage *compressImage; /**< 压缩后的照片 */
- (NSString *)toString;
- (BOOL)isOK;
@end
