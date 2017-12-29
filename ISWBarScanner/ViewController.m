//
//  ViewController.m
//  ISWBarScanner
//
//  Created by chenxiaosong on 2017/12/29.
//  Copyright © 2017年 chenxiaosong. All rights reserved.
//

#import "ViewController.h"

#import <Masonry.h>

#import "ScanAndInputViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    scanBtn.titleLabel.text = @"去扫码";
    [scanBtn addTarget:self
                action:@selector(scanBtnPressed)
      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanBtn];
    [scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@44);
    }];

    UIButton *scanAndTxtBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    scanAndTxtBtn.titleLabel.text = @"扫码&手动输入";
    [scanAndTxtBtn addTarget:self
                action:@selector(scanAndTxtBtnPressed)
      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanAndTxtBtn];
    [scanAndTxtBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scanBtn.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@44);
    }];
}

- (void)scanBtnPressed
{

}

- (void)scanAndTxtBtnPressed
{
    UIViewController *scanPage = [[ScanAndInputViewController alloc] init];
    [self.navigationController pushViewController:scanPage animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
