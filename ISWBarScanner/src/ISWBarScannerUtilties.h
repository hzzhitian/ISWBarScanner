//
//  ISWBarScannerUtilties.h
//  youngcity
//
//  Created by chenxiaosong on 2017/12/29.
//  Copyright © 2017年 Zhitian Network Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISWBarScannerUtilties : NSObject

+ (void)setButtonTitleForAllStates:(UIButton*)btn title:(NSString*)title;
+ (void)setButtonTitleColorForAllStates:(UIButton*)btn color:(UIColor*)titleColor;
+ (void)setButtonImageForAllStates:(UIButton*)btn image:(UIImage*)img;

+ (BOOL)isEmptyString:(NSString*)str;
+ (NSString*)trimWhitespace:(NSString*)str;

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIColor *)colorWithHexString:(NSString *)hexStr;

+ (UIFont *)pingfangFont:(CGFloat)size;

+ (CGFloat)onePixel;
+ (CGFloat)screenWidth;
+ (CGFloat)screenHeight;

+ (UIImage *)imageNamed:(NSString *)name;

@end
