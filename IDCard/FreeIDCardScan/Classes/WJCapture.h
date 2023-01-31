//
//  WJCapture.h
//  idcard
//
//  Created by 彭维剑 on 16-9-10.
//  Copyright (c) 2016年 Session. All rights reserved.
//

#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "WJIDInfo.h"
#import "excards.h"

@protocol WJCaptureDelegate<NSObject>

@optional

- (void)idCardRecognited:(WJIDInfo*)idInfo;

@end


@interface WJCapture : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (strong,nonatomic) AVCaptureVideoPreviewLayer     *previewLayer;
@property (strong,nonatomic) AVCaptureSession               *captureSession;
@property (strong,nonatomic) AVCaptureStillImageOutput      *stillImageOutput;
@property (strong,nonatomic) UIImage                        *stillImage;
@property (strong,nonatomic) NSNumber                       *outPutSetting;
@property (weak,nonatomic) id<WJCaptureDelegate>             delegate;
@property (assign,nonatomic)BOOL             verify;

/**
 *  @brief Add video input: front or back camera:
 *  AVCaptureDevicePositionBack
 *  AVCaptureDevicePositionFront
 */
- (void)addVideoInput:(AVCaptureDevicePosition)_campos;

/**
 *  @brief Add video output
 */
- (void)addVideoOutput;

/**
 *  @brief Add preview layer
 */
- (void)addVideoPreviewLayer;

@end
