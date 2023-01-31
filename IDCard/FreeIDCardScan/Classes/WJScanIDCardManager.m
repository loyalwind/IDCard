//
//  WJScanIDCardManager.m
//  idcard
//
//  Created by 彭维剑 on 16/9/12.
//  Copyright © 2016年 session. All rights reserved.
//

#import "WJScanIDCardManager.h"
#import "WJIDCardViewController.h"

static id _instance = nil;

@interface WJScanIDCardManager ()<WJCaptureDelegate>
/** 回调 */
@property (nonatomic, copy) void(^compeletion)(WJIDInfo *idInfo);
@property (nonatomic, strong) WJIDCardViewController *idCardViewController;

@end

@implementation WJScanIDCardManager

+ (instancetype)sharedManager {
    if (!_instance) {
        _instance = [[self alloc] init];
    }
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
- (id)copyWithZone:(NSZone *)zone { return self;}
- (id)mutableCopyWithZone:(NSZone *)zone { return self;}
- (WJIDCardViewController *)idCardViewController
{
    if (!_idCardViewController) {
        WJIDCardViewController *idCardViewController = [[WJIDCardViewController alloc] initWithidInfoBlock:nil];
        idCardViewController.delegate = self;
        _idCardViewController = idCardViewController;
    }
    return _idCardViewController;
}
- (void)startScanIDCardWithCompeletion:(void (^)(WJIDInfo *idInfo))compeletion
{
    self.compeletion = compeletion;
    UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootVc presentViewController:self.idCardViewController animated:NO completion:nil];
}
#pragma mark - WJCaptureDelegate
- (void)idCardRecognited:(WJIDInfo *)idInfo
{
    if (self.compeletion) {
        self.compeletion(idInfo);
        self.compeletion = nil;
    }
    [self.idCardViewController dismissViewControllerAnimated:YES completion:^{
        [self.idCardViewController closeAction];
        self.idCardViewController = nil;
    }];
}

@end
