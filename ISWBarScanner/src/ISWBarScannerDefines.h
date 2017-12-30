//
//  ISWBarScannerConstants.h
//  youngcity
//
//  Created by chenxiaosong on 2017/12/29.
//  Copyright © 2017年 Zhitian Network Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const ISWBarScannerColorOutline;
extern NSString *const ISWBarScannerColorMajorNormal;
extern NSString *const ISWBarScannerColorMajorHighlight;
extern NSString *const ISWBarScannerColorDarkGray;
extern NSString *const ISWBarScannerColorLightGray;

typedef void(^ISWBarScannerResultFound)(NSString *rlt);

typedef void(^ISWBarScannerInputModeChanged)(void);
