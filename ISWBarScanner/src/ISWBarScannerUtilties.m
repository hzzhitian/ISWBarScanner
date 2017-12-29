//
//  ISWBarScannerUtilties.m
//  youngcity
//
//  Created by chenxiaosong on 2017/12/29.
//  Copyright © 2017年 Zhitian Network Tech. All rights reserved.
//

#import "ISWBarScannerUtilties.h"

@implementation ISWBarScannerUtilties

+ (void)setButtonTitleForAllStates:(UIButton*)btn title:(NSString*)title
{
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateDisabled];
    [btn setTitle:title forState:UIControlStateSelected];
}

+ (void)setButtonTitleColorForAllStates:(UIButton*)btn color:(UIColor*)titleColor
{
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateHighlighted];
    [btn setTitleColor:titleColor forState:UIControlStateDisabled];
    [btn setTitleColor:titleColor forState:UIControlStateSelected];
}

+ (void)setButtonImageForAllStates:(UIButton*)btn image:(UIImage*)img
{
    [btn setImage:img forState:UIControlStateNormal];
    [btn setImage:img forState:UIControlStateHighlighted];
    [btn setImage:img forState:UIControlStateDisabled];
    [btn setImage:img forState:UIControlStateSelected];
}

+ (UIFont *)pingfangFont:(CGFloat)size
{
    return [UIFont fontWithName:@"PingFangSC-Regular" size:size];
}

+ (NSString*)trimWhitespace:(NSString*)str
{
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}


+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (BOOL)isEmptyString:(NSString*)str
{
    return (str == nil || str.length == 0);
}

+ (UIColor *)colorWithHexString:(NSString *)hexStr {
    CGFloat r, g, b, a;
    if ([self hexStrToRGBA:hexStr red:&r green:&g blue:&b alpha:&a]) {
        return [UIColor colorWithRed:r green:g blue:b alpha:a];
    }
    return nil;
}

+ (BOOL)hexStrToRGBA:(NSString *)str red:(CGFloat *)r green:(CGFloat *)g blue:(CGFloat *)b alpha:(CGFloat *)a
{
    str = [[self trimWhitespace:str] uppercaseString];
    if ([str hasPrefix:@"#"]) {
        str = [str substringFromIndex:1];
    } else if ([str hasPrefix:@"0X"]) {
        str = [str substringFromIndex:2];
    }
    
    NSUInteger length = [str length];
    //         RGB            RGBA          RRGGBB        RRGGBBAA
    if (length != 3 && length != 4 && length != 6 && length != 8) {
        return NO;
    }
    
    //RGB,RGBA,RRGGBB,RRGGBBAA
    if (length < 5) {
        *r = hexStrToInt([str substringWithRange:NSMakeRange(0, 1)]) / 255.0f;
        *g = hexStrToInt([str substringWithRange:NSMakeRange(1, 1)]) / 255.0f;
        *b = hexStrToInt([str substringWithRange:NSMakeRange(2, 1)]) / 255.0f;
        if (length == 4)  *a = hexStrToInt([str substringWithRange:NSMakeRange(3, 1)]) / 255.0f;
        else *a = 1;
    } else {
        *r = hexStrToInt([str substringWithRange:NSMakeRange(0, 2)]) / 255.0f;
        *g = hexStrToInt([str substringWithRange:NSMakeRange(2, 2)]) / 255.0f;
        *b = hexStrToInt([str substringWithRange:NSMakeRange(4, 2)]) / 255.0f;
        if (length == 8) *a = hexStrToInt([str substringWithRange:NSMakeRange(6, 2)]) / 255.0f;
        else *a = 1;
    }
    return YES;
}


+ (CGFloat)onePixel
{
    return 1.0f/[UIScreen mainScreen].scale;
}

+ (CGFloat)screenWidth
{
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)screenHeight
{
    return [UIScreen mainScreen].bounds.size.height;
}

+ (NSBundle *)currentBundle
{
    static NSBundle *resourceBundle = nil;
    if (resourceBundle == nil) {
        // 这里不使用mainBundle是为了适配pod 1.x和0.x
        NSBundle *frameBundle   = [NSBundle bundleForClass:[ISWBarScannerUtilties class]];
        resourceBundle          = [NSBundle bundleWithPath:[frameBundle pathForResource:@"ISWBarScanner" ofType:@"bundle"]];
    }
    return resourceBundle;
}

+ (UIImage *)imageNamed:(NSString *)name {
    NSBundle *imageBundle = [self currentBundle];
    name = [name stringByAppendingString:@"@2x"];
    NSString *imagePath = [imageBundle pathForResource:name ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    if (!image) {
        // 兼容业务方自己设置图片的方式
        name = [name stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
        image = [UIImage imageNamed:name];
    }
    return image;
}

static inline NSUInteger hexStrToInt(NSString *str) {
    uint32_t result = 0;
    sscanf([str UTF8String], "%X", &result);
    return result;
}

@end
