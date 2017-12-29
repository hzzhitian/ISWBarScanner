//
//  ScanViewController.m
//  ISWBarScanner
//
//  Created by chenxiaosong on 2017/12/29.
//  Copyright © 2017年 chenxiaosong. All rights reserved.
//

#import "ScanViewController.h"

#import "ISWBarScanViewController.h"

#import <Masonry.h>

@interface ScanViewController ()
{
    ISWBarScanViewController *scanVC;
}
@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"扫码";

    // Do any additional setup after loading the view.
    [self setupScanUI];
    scanVC.hidden     = NO;
}

- (void)dealloc
{
    [scanVC pauseScan];
    [scanVC.view removeFromSuperview];
    scanVC = nil;
}

- (void)setupScanUI
{
    typeof(self) __weak weakSelf = self;

    scanVC = [[ISWBarScanViewController alloc] init];
    scanVC.resultScaned = ^(NSString *str) {
        [weakSelf resultDetected:str];
    };
    [self.view addSubview:scanVC.view];
    [scanVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
    }];
}

- (void)resultDetected:(NSString*)str
{
    [scanVC pauseScan];
    
    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle:@"扫码结果"
                                        message:[NSString stringWithFormat:@"内容：%@",str]
                                 preferredStyle:UIAlertControllerStyleAlert];

    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [scanVC startScan];
    }]];

    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
