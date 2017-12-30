//
//  NewBarScannerViewController.h
//  youngcity
//
//  Created by chenxiaosong on 2017/11/16.
//  Copyright © 2017年 Zhitian Network Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ISWBarScannerDefines.h"

@interface ISWBarScanViewController : UIViewController

@property (nonatomic,strong) ISWBarScannerInputModeChanged inputModeChanged;

@property (nonatomic,strong) ISWBarScannerResultFound resultScaned;

@property (nonatomic,assign) BOOL hidden;

- (void)pauseScan;
- (void)startScan;

@end
