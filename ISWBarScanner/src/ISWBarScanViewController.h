//
//  NewBarScannerViewController.h
//  youngcity
//
//  Created by chenxiaosong on 2017/11/16.
//  Copyright © 2017年 Zhitian Network Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ISWBarScanViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic,strong) void (^inputModeChanged) ();

@property (nonatomic,strong) void (^resultScaned) (NSString *str);

@property (nonatomic,assign) BOOL hidden;

- (void)pauseScan;
- (void)startScan;

@end
