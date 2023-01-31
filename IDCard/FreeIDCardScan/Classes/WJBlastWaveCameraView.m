//
//  WJBlastWaveCameraView.m
//  QunFangYi
//
//  Created by 彭维剑 on 2016/11/16.
//  Copyright © 2016年 Session. All rights reserved.
//

#import "WJBlastWaveCameraView.h"

@interface WJBlastWaveCameraView ()
@property (nonatomic, strong) CAShapeLayer *overlay;
@property (nonatomic, assign) CGRect offsetRect;
/** 冲击波 */
@property (nonatomic, weak) UIImageView *blastWaveView;
@end

@implementation WJBlastWaveCameraView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addOverlay];
        [self setupSubviews];
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    // 适当调小一下扫描边界
    rect.size.height -= 150;
    rect.origin.y += 40;
    _offsetRect = rect;
    _blastWaveView.frame = CGRectMake(CGRectGetMaxX(rect), rect.origin.y, 3, rect.size.height);
    
    _overlay.path = [self creatBezierPathFourRightAngleInRect:rect].CGPath;
        
    [self startBlastWaveAnimation];
}

- (void)setupSubviews
{
    UIImageView *blastWaveView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 3, 0)];
    blastWaveView.backgroundColor = [UIColor greenColor];
    _blastWaveView = blastWaveView;
    [self addSubview:blastWaveView];
}
- (void)addOverlay
{
    _overlay = [[CAShapeLayer alloc] init];
    _overlay.backgroundColor = [UIColor clearColor].CGColor;
    _overlay.fillColor       = [UIColor clearColor].CGColor;
    _overlay.strokeColor     = [UIColor greenColor].CGColor;
    _overlay.lineWidth       = 3;
    
    [self.layer addSublayer:_overlay];
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    [super willMoveToWindow:newWindow];
    
    [self startBlastWaveAnimation];
}
- (void)startBlastWaveAnimation
{
    // 先恢复原位置
    CGRect frame = self.blastWaveView.frame;
    frame.origin.x = CGRectGetMaxX(self.offsetRect);
    self.blastWaveView.frame = frame;
    
    // 执行动画
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:1.5 animations:^{
        [UIView setAnimationRepeatCount:MAXFLOAT];
        CGRect frame = weakSelf.blastWaveView.frame;
        frame.origin.x = CGRectGetMinX(weakSelf.offsetRect)-frame.size.width;
        weakSelf.blastWaveView.frame = frame;
    }];
}

#define kCornerLength 15
- (UIBezierPath *)creatBezierPathFourRightAngleInRect:(CGRect)rect
{
    // 左上角路径
    UIBezierPath *leftTopPath = [UIBezierPath bezierPath];
    [leftTopPath moveToPoint: CGPointMake(rect.origin.x, rect.origin.y+kCornerLength)];
    [leftTopPath addLineToPoint: CGPointMake(rect.origin.x, rect.origin.y)];
    [leftTopPath addLineToPoint: CGPointMake(rect.origin.x+kCornerLength, rect.origin.y)];
    
    // 右上角路径
    UIBezierPath *rightTopPath = [UIBezierPath bezierPath];
    [rightTopPath moveToPoint: CGPointMake(CGRectGetMaxX(rect)-kCornerLength, rect.origin.y)];
    [rightTopPath addLineToPoint: CGPointMake(CGRectGetMaxX(rect), rect.origin.y)];
    [rightTopPath addLineToPoint: CGPointMake(CGRectGetMaxX(rect), rect.origin.y+kCornerLength)];
    
    // 右下角路径
    UIBezierPath *rightBottomPath = [UIBezierPath bezierPath];
    [rightBottomPath moveToPoint: CGPointMake(CGRectGetMaxX(rect),CGRectGetMaxY(rect)-kCornerLength)];
    [rightBottomPath addLineToPoint: CGPointMake(CGRectGetMaxX(rect),CGRectGetMaxY(rect))];
    [rightBottomPath addLineToPoint: CGPointMake(CGRectGetMaxX(rect)-kCornerLength, CGRectGetMaxY(rect))];
    
    // 左下角路径
    UIBezierPath *leftBottomPath = [UIBezierPath bezierPath];
    [leftBottomPath moveToPoint: CGPointMake(rect.origin.x+kCornerLength,CGRectGetMaxY(rect))];
    [leftBottomPath addLineToPoint: CGPointMake(rect.origin.x,CGRectGetMaxY(rect))];
    [leftBottomPath addLineToPoint: CGPointMake(rect.origin.x, CGRectGetMaxY(rect)-kCornerLength)];
    
    // 合并路径
    //    UIBezierPath *totalPath = [UIBezierPath bezierPath];
    [leftTopPath appendPath:leftTopPath];
    [leftTopPath appendPath:rightTopPath];
    [leftTopPath appendPath:rightBottomPath];
    [leftTopPath appendPath:leftBottomPath];
    
    return leftTopPath;
}
- (void)dealloc {
    NSLog(@"WJBlastWaveCameraView dealloc");
}
@end
