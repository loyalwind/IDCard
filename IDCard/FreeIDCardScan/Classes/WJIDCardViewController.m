//
//  WJIDCardViewController.m
//  idcard
//
//  Created by 彭维剑 on 16-9-10.
//  Copyright (c) 2016年 Session. All rights reserved.
//
@import MobileCoreServices;
@import ImageIO;

#import "WJIDCardViewController.h"
#import "WJBlastWaveCameraView.h"
#import <TargetConditionals.h>

#if TARGET_IPHONE_SIMULATOR
#warning 是模拟器的话，提示“请使用真机测试！！！”
STD_API(int)    EXCARDS_Init(const char *szWorkPath) { return -1;}
STD_API(void)   EXCARDS_Done(void){};
STD_API(float)  EXCARDS_GetFocusScore(unsigned char *yimgdata, int width, int height, int pitch, int lft, int top, int rgt, int btm){
    return -1;
}

STD_API(int)    EXCARDS_RecoIDCardFile(const char *szImgFile, char *szResBuf, int nResBufSize){return -1;}
STD_API(int)    EXCARDS_RecoIDCardData(unsigned char *pbImage, int nWidth, int nHeight, int nPitch, int nBitCount, char *szResBuf, int nResBufSize){return -1;}
#endif

@interface WJIDCardViewController () {
    WJCapture *_capture;
    WJBlastWaveCameraView *_cameraView;
}
@property (nonatomic) BOOL verify;
@end

@implementation WJIDCardViewController

static Boolean init_flag = false;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype)initWithidInfoBlock:(void(^)(WJIDInfo* infoDict))aBlock{
    if (self = [super init]) {
        self.idInfoBlock = aBlock;
    }
    self.verify = false;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createSubViews];
}
- (void)createSubViews {
#if TARGET_IPHONE_SIMULATOR
    UILabel *label = [[UILabel alloc] init];
    label.text = @"请使用真机测试！！！";
    label.backgroundColor = [UIColor orangeColor];
    [label sizeToFit];
    label.center = self.view.center;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:label];
#else
    if (!init_flag) {
        int ret = EXCARDS_Init(NSBundle.mainBundle.resourcePath.UTF8String);
        if (ret != 0) {
//            NSLog(@"Init Failed!ret=[%d]", ret);
        }
        init_flag = true;
    }
    [self initCapture];
#endif
    [self initCloseButton];
}

- (BOOL) prefersStatusBarHidden { return YES; }
- (BOOL)shouldAutorotate { return YES;}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // start !
    [self performSelectorInBackground:@selector(startCapture) withObject:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // stop !
    [self stopCapture];
}

- (void)closeAction {
#if !TARGET_IPHONE_SIMULATOR
    [self removeCapture];
    if(init_flag){
        EXCARDS_Done();
        init_flag = false;
    }
#endif
}
- (void)closeBtnClick {
    if([self.delegate respondsToSelector:@selector(idCardRecognited:)]){
        [self.delegate idCardRecognited:nil];
    }
}
- (void)initCloseButton {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeClose];
    btn.frame = CGRectMake(5, 5, 30, 30);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Capture
- (void)initCapture {
    // init capture manager
    _capture = [[WJCapture alloc] init];
    
    _capture.delegate = self;
    _capture.verify = self.verify;
    
    // set video streaming quality
    // AVCaptureSessionPresetHigh   1280x720
    // AVCaptureSessionPresetPhoto  852x640
    // AVCaptureSessionPresetMedium 480x360
    _capture.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    
    //kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange
    //kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
    //kCVPixelFormatType_32BGRA
    [_capture setOutPutSetting:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]];
    
    // AVCaptureDevicePositionBack
    // AVCaptureDevicePositionFront
    [_capture addVideoInput:AVCaptureDevicePositionBack];
    
    [_capture addVideoOutput];
    [_capture addVideoPreviewLayer];
    
    CGRect layerRect = self.view.bounds;
    [[_capture previewLayer] setOpaque: 0];
    [[_capture previewLayer] setBounds:layerRect];
    [[_capture previewLayer] setPosition:CGPointMake( CGRectGetMidX(layerRect), CGRectGetMidY(layerRect))];
    
    // create a view, on which we attach the AV Preview layer
    _cameraView = [[WJBlastWaveCameraView alloc] initWithFrame:layerRect];
    [_cameraView.layer insertSublayer:_capture.previewLayer atIndex:0];

    // add the view we just created as a subview to the View Controller's view
    [self.view addSubview: _cameraView];
    [self.view sendSubviewToBack:_cameraView];
}

- (void)removeCapture {
    [_capture.captureSession stopRunning];
    [_capture.previewLayer removeFromSuperlayer];
    [_cameraView removeFromSuperview];
    _capture     = nil;
    _cameraView  = nil;
}

- (void)stopCapture {
    [[_capture captureSession] stopRunning];
}

- (void)startCapture {
    [[_capture captureSession] startRunning];
}

#pragma mark - Capture WJCaptureDelegate
- (void)idCardRecognited:(WJIDInfo*)idInfo {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        NSLog(@"idCardRecognited: %@",idInfo);
        if([self.delegate respondsToSelector:@selector(idCardRecognited:)]){
            [self.delegate idCardRecognited:idInfo];
        }
    });
    [_capture.captureSession stopRunning];
}

- (void)dealloc {
    NSLog(@"WJIDCardViewController dealloc");
    [self closeAction];
}

@end
