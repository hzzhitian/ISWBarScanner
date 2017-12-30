//
//  BarInputViewController.h
//  youngcity
//
//  Created by chenxiaosong on 2017/11/23.
//  Copyright © 2017年 Zhitian Network Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ISWBarScannerDefines.h"

@interface ISWBarInputViewController : UIViewController

@property (nonatomic,assign) BOOL hidden;

@property (nonatomic,strong) NSString *placeholdTxt;

@property (nonatomic,strong) ISWBarScannerResultFound resultInput;

@end
