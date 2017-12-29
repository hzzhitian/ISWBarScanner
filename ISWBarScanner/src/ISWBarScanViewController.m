//
//  NewBarScannerViewController.m
//  youngcity
//
//  Created by chenxiaosong on 2017/11/16.
//  Copyright © 2017年 Zhitian Network Tech. All rights reserved.
//

#import "ISWBarScanViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import "Masonry.h"

#import "ISWBarScannerUtilties.h"
#import "ISWBarScannerDefines.h"

@interface ISWBarScanViewController ()
{
    UIView           *captureV;

    UILabel          *cameraLoadingLable;
    UIImageView      *scanLine;
    
    AVCaptureSession *flashSession;
    AVCaptureSession *videoSession;
    
    BOOL            delayForRlt;
}

/** 扫描支持的编码格式的数组 */

@end

@implementation ISWBarScanViewController

- (BOOL)showInputModeBtn
{
    if(_inputModeChanged)
        return YES;
    else
        return NO;
}

- (void)setHidden:(BOOL)hidden
{
    self.view.hidden = hidden;

    if(hidden) {
        [self pauseScan];
    } else {
        [self startScan];
    }
}

- (NSMutableArray *)retMetadataObjectTypes{
    NSMutableArray *metadataObjectTypes;

    metadataObjectTypes = [NSMutableArray arrayWithObjects:AVMetadataObjectTypeAztecCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeUPCECode, nil];
    
    // >= iOS 8
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
        [metadataObjectTypes addObjectsFromArray:@[AVMetadataObjectTypeInterleaved2of5Code, AVMetadataObjectTypeITF14Code, AVMetadataObjectTypeDataMatrixCode]];
    }
    return metadataObjectTypes;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupScanUI];
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        //无权限
        return;
    }
    
    [self setupCamera];
    
}

- (void)setupScanUI
{
    WEAKSELF

    captureV = [[UIView alloc] initWithFrame:CGRectZero];
    captureV.backgroundColor     = [UIColor whiteColor];
    [self.view addSubview:captureV];
    [captureV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.top.equalTo(weakSelf.view);
    }];

    UIView *topBg = [[UIView alloc] initWithFrame:CGRectZero];
    topBg.backgroundColor     = [UIColor blackColor];
    topBg.alpha               = 0.4;
    [captureV addSubview:topBg];
    [topBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(captureV);
        make.height.equalTo(@48);
    }];

    UIImageView *captureWindow = [[UIImageView alloc] initWithImage:[ISWBarScannerUtilties imageNamed:@"scanframe"]];
    captureWindow.backgroundColor     = [UIColor clearColor];
    captureWindow.clipsToBounds       = YES;
    [captureV addSubview:captureWindow];
    [captureWindow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(captureV);
        make.top.equalTo(topBg.mas_bottom).offset(-3);
        make.height.width.equalTo(@224);
    }];
    
    UIView *leftBg = [[UIView alloc] initWithFrame:CGRectZero];
    leftBg.backgroundColor     = [UIColor blackColor];
    leftBg.alpha               = 0.4;
    [captureV addSubview:leftBg];
    [leftBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(captureV);
        make.top.equalTo(topBg.mas_bottom);
        make.height.equalTo(@(224-6));
        make.right.equalTo(captureWindow.mas_left).offset(3);
    }];

    UIView *rightBg = [[UIView alloc] initWithFrame:CGRectZero];
    rightBg.backgroundColor     = [UIColor blackColor];
    rightBg.alpha               = 0.4;
    [captureV addSubview:rightBg];
    [rightBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(captureV);
        make.top.equalTo(topBg.mas_bottom);
        make.height.equalTo(@(224-6));
        make.left.equalTo(captureWindow.mas_right).offset(-3);
    }];

    UIView *buttomBg = [[UIView alloc] initWithFrame:CGRectZero];
    buttomBg.backgroundColor     = [UIColor blackColor];
    buttomBg.alpha               = 0.4;
    [captureV addSubview:buttomBg];
    [buttomBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.leading.equalTo(captureV);
        make.top.equalTo(captureWindow.mas_bottom).offset(-3);
        make.bottom.equalTo(captureV);
    }];
    
    [captureV bringSubviewToFront:captureWindow];
    
    scanLine = [[UIImageView alloc] initWithImage:[ISWBarScannerUtilties imageNamed:@"icon_scan_grid"]];
    scanLine.contentMode = UIViewContentModeScaleAspectFit;
    [captureWindow addSubview:scanLine];
    [scanLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(captureWindow).offset(3);
        make.trailing.equalTo(captureWindow).offset(-3);
        make.bottom.equalTo(captureWindow.mas_top).offset(3);
         make.height.offset(171);
    }];

    UILabel *cameraSubTitleLable = [[UILabel alloc] init];
    cameraSubTitleLable.backgroundColor = [UIColor clearColor];
    cameraSubTitleLable.textColor = [UIColor whiteColor];
    cameraSubTitleLable.font      = [ISWBarScannerUtilties pingfangFont:13];
    cameraSubTitleLable.textAlignment = NSTextAlignmentCenter;
    cameraSubTitleLable.numberOfLines = 1;
    [captureV addSubview:cameraSubTitleLable];
    [cameraSubTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(captureV);
        make.top.equalTo(captureV.mas_top).offset(306.0);
    }];
    cameraSubTitleLable.text = @"将二维码/条形码放入框内，即可自动扫描";
    
    if([self showInputModeBtn]) {
        UIButton *scanInputBgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [scanInputBgBtn addTarget:self action:@selector(scanInputPressed) forControlEvents:UIControlEventTouchUpInside];
        scanInputBgBtn.layer.cornerRadius  = 20.0;
        scanInputBgBtn.layer.masksToBounds = YES;
        scanInputBgBtn.backgroundColor = [UIColor blackColor];
        scanInputBgBtn.alpha  = 0.5;
        [captureV addSubview:scanInputBgBtn];
        [scanInputBgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@40);
            make.width.equalTo(@110);
            make.centerX.equalTo(captureV).offset(-105);
            make.top.equalTo(cameraSubTitleLable.mas_bottom).offset(60);
        }];

        UIButton *scanInputBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [ISWBarScannerUtilties setButtonImageForAllStates:scanInputBtn image:[ISWBarScannerUtilties imageNamed:@"icon_scan_manual_input"]];
        [ISWBarScannerUtilties setButtonTitleForAllStates:scanInputBtn title:@"手输"];
        [ISWBarScannerUtilties setButtonTitleColorForAllStates:scanInputBtn color:[UIColor whiteColor]];
        scanInputBtn.titleLabel.font = [ISWBarScannerUtilties pingfangFont:15];
        [scanInputBtn addTarget:self action:@selector(scanInputPressed) forControlEvents:UIControlEventTouchUpInside];
        scanInputBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 3.5, 0, 0);
        scanInputBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -3.5);
        scanInputBtn.backgroundColor = [UIColor clearColor];
        [captureV addSubview:scanInputBtn];
        [scanInputBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@40);
            make.width.equalTo(@110);
            make.centerX.equalTo(captureV).offset(-105);
            make.top.equalTo(cameraSubTitleLable.mas_bottom).offset(60);
        }];
    }

    UIButton *flashBgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    flashBgBtn.layer.cornerRadius  = 20.0;
    flashBgBtn.layer.masksToBounds = YES;
    flashBgBtn.backgroundColor = [UIColor blackColor];
    flashBgBtn.alpha  = 0.5;
    [flashBgBtn addTarget:self action:@selector(openLight:) forControlEvents:UIControlEventTouchUpInside];
    [captureV addSubview:flashBgBtn];
    [flashBgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.width.equalTo(@110);
        make.top.equalTo(cameraSubTitleLable.mas_bottom).offset(60);

        if([weakSelf showInputModeBtn])
            make.centerX.equalTo(captureV).offset(105);
        else
            make.centerX.equalTo(captureV);
    }];

    UIButton *flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ISWBarScannerUtilties setButtonImageForAllStates:flashBtn image:[ISWBarScannerUtilties imageNamed:@"icon_scan_turnon"]];
    [ISWBarScannerUtilties setButtonTitleForAllStates:flashBtn title:@"开灯"];
    [ISWBarScannerUtilties setButtonTitleColorForAllStates:flashBtn color:[UIColor whiteColor]];
    flashBtn.titleLabel.font = [ISWBarScannerUtilties pingfangFont:15];
    flashBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 3.5, 0, 0);
    flashBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -3.5);
    flashBtn.backgroundColor = [UIColor clearColor];
    [flashBtn addTarget:self action:@selector(openLight:) forControlEvents:UIControlEventTouchUpInside];
    [captureV addSubview:flashBtn];
    [flashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.width.equalTo(@110);
        make.top.equalTo(cameraSubTitleLable.mas_bottom).offset(60);

        if([weakSelf showInputModeBtn])
            make.centerX.equalTo(captureV).offset(105);
        else
            make.centerX.equalTo(captureV);
    }];

    cameraLoadingLable = [[UILabel alloc] init];
    cameraLoadingLable.backgroundColor = [UIColor blackColor];
    cameraLoadingLable.textColor = [UIColor whiteColor];
    cameraLoadingLable.font      = [ISWBarScannerUtilties pingfangFont:15];
    cameraLoadingLable.textAlignment = NSTextAlignmentCenter;
    cameraLoadingLable.numberOfLines = 1;
    [captureV addSubview:cameraLoadingLable];
    [cameraLoadingLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.top.equalTo(captureV);
    }];
    cameraLoadingLable.text = @"正在加载...";
    cameraLoadingLable.hidden = NO;

}

- (void)addScanAnimation
{
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    moveAnimation.removedOnCompletion = NO;
    moveAnimation.repeatCount = HUGE;
    moveAnimation.autoreverses = NO;
    moveAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    moveAnimation.toValue   = [NSNumber numberWithFloat:218.0f];
    moveAnimation.duration  = 1.5f;
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.removedOnCompletion = NO;
    alphaAnimation.repeatCount = HUGE;
    alphaAnimation.autoreverses = NO;
    alphaAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    alphaAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    alphaAnimation.duration  = 1.5f;
    
    CAAnimationGroup *groupAnimation    = [CAAnimationGroup animation];
    groupAnimation.removedOnCompletion = NO;
    groupAnimation.duration            = 1.5;
    groupAnimation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    groupAnimation.repeatCount         = HUGE;
    groupAnimation.animations          = [NSArray arrayWithObjects:
                                          moveAnimation,
                                          alphaAnimation,
                                          nil];

    [scanLine.layer addAnimation:groupAnimation forKey:@"scanGridAnimation"];
}

- (void)judgeAuthority
{
    //相机权限
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus ==AVAuthorizationStatusRestricted ||authStatus ==AVAuthorizationStatusDenied)
    {
        return;
    }

}

- (void)openLight:(UIButton *)sender
{
    UIButton *flashBtn = sender;

    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //Create an AV session
    if (flashSession != nil) {
        flashSession = [[AVCaptureSession alloc]init];
        
        // Create device input and add to current session
        AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        [flashSession addInput:input];
        
        // Create video output and add to current session
        AVCaptureVideoDataOutput * output = [[AVCaptureVideoDataOutput alloc]init];
        [flashSession addOutput:output];
    }
    
    // Start session configuration
    [flashSession beginConfiguration];
    [device lockForConfiguration:nil];
    
    // Set torch to on
    if (device.torchMode == AVCaptureTorchModeOn) {
        [device setTorchMode:AVCaptureTorchModeOff];
    }else{
        [device setTorchMode:AVCaptureTorchModeOn];
    }
    
    [device unlockForConfiguration];
    [flashSession commitConfiguration];
    
    // Start the session
    [flashSession startRunning];
    
    NSString *imgRsc = device.torchMode == AVCaptureTorchModeOff ? @"icon_scan_turnon" : @"icon_scan_switchon";
    NSString *title  = device.torchMode == AVCaptureTorchModeOff ? @"开灯" : @"关灯";
    
    [ISWBarScannerUtilties setButtonImageForAllStates:flashBtn image:[ISWBarScannerUtilties imageNamed:imgRsc]];
    [ISWBarScannerUtilties setButtonTitleForAllStates:flashBtn title:title];
}

- (void)setupCamera{
    static AVCaptureVideoPreviewLayer *preview;

    AVCaptureDevice            *device;
    AVCaptureDeviceInput       *input;
    AVCaptureMetadataOutput    *output;

    if (preview) {
        [preview removeFromSuperlayer];
    }

    // Device
    device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    input =  [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    // Output
    output = [[AVCaptureMetadataOutput alloc]init];
    
    //识别区域：距顶部48，水平居中，宽高224*224
    output.rectOfInterest = CGRectMake((48)/[ISWBarScannerUtilties screenHeight],
                                       (([ISWBarScannerUtilties screenWidth]-224)/2)/[ISWBarScannerUtilties screenWidth],
                                       224/[ISWBarScannerUtilties screenHeight],
                                       224/[ISWBarScannerUtilties screenWidth]);
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    videoSession = [[AVCaptureSession alloc]init];
    //高质量采集率
    [videoSession setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([videoSession canAddInput:input])
    {
        [videoSession addInput:input];
    }
    
    if ([videoSession canAddOutput:output])
    {
        [videoSession addOutput:output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    output.metadataObjectTypes = [self retMetadataObjectTypes];
    // Preview
    preview =[AVCaptureVideoPreviewLayer layerWithSession:videoSession];
    preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    preview.frame =CGRectMake(0, 0, [ISWBarScannerUtilties screenWidth] , [ISWBarScannerUtilties screenHeight]);
    
    [captureV.layer insertSublayer:preview atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    
    if(delayForRlt)
        return;

    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;

        if(self.resultScaned)
            self.resultScaned(stringValue);
        NSLog(@"松：获取结果");
    }

    [self pauseScan];
}

- (void)pauseScan
{
    delayForRlt = YES;
    [videoSession stopRunning];
    [scanLine.layer removeAllAnimations];
}

- (void)startScan
{
    delayForRlt = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        delayForRlt = NO;
    });

    [self addScanAnimation];
    [videoSession startRunning];
    cameraLoadingLable.hidden = YES;

}

- (void)scanInputPressed
{
    if(self.inputModeChanged)
        self.inputModeChanged();
}

@end
