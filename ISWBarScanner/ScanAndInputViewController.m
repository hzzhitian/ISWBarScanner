//
//  ScanViewController.m
//  ISWBarScanner
//
//  Created by chenxiaosong on 2017/12/29.
//  Copyright © 2017年 chenxiaosong. All rights reserved.
//

#import "ScanAndInputViewController.h"

#import <Masonry.h>

#import "ISWBarScanViewController.h"
#import "ISWBarInputViewController.h"

@interface ScanAndInputViewController ()
{
    ISWBarScanViewController    *scanVC;
    ISWBarInputViewController   *inputVC;
}

@property (nonatomic,assign)BOOL manualMode;

@end

@implementation ScanAndInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    // Do any additional setup after loading the view.
//    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightBtn  yc_titleForAllState:@"扫码输入"];
//    [rightBtn setTitleColor:kColorDark forState:UIControlStateNormal];
//    [rightBtn setTitleColor:kColorDark forState:UIControlStateHighlighted];
//    rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 12);
    
    [self setupPages];

    self.manualMode = NO;
}

- (void)dealloc
{
    NSLog(@"ScanViewController dealloc");
}

- (void)setupPages
{
    typeof(self) __weak weakSelf = self;

    //扫码页面
    scanVC = [[ISWBarScanViewController alloc] init];
    scanVC.inputModeChanged = ^{
        weakSelf.manualMode = YES;
    };
    scanVC.resultScaned = ^(NSString *str) {
        [weakSelf resultDetected:str byScan:YES];
    };
    [self.view addSubview:scanVC.view];
    [scanVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
    }];

    //手动输入页面
    inputVC = [[ISWBarInputViewController alloc] init];
    inputVC.placeholdTxt = @"请输入数字";
    inputVC.resultInput = ^(NSString *str) {
        [weakSelf resultDetected:str byScan:NO];
    };

    [self.view addSubview:inputVC.view];
    [inputVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
    }];
}

- (void)resultDetected:(NSString*)str byScan:(BOOL)byScan
{
    if(byScan) {
       [scanVC pauseScan];
    }

    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"获取%@结果",byScan?@"扫码输入":@"手动输入"]
                                        message:[NSString stringWithFormat:@"内容：%@",str]
                                 preferredStyle:UIAlertControllerStyleAlert];

    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if(byScan) {
            [scanVC startScan];
        }
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)setManualMode:(BOOL)manualMode
{
    _manualMode = manualMode;

    if(manualMode) {
        self.title        = @"手动输入";
        //rightBtn.hidden   = NO;
        scanVC.hidden     = YES;
        inputVC.hidden    = NO;
    } else {
        self.title        = @"扫码";
        //rightBtn.hidden   = YES;
        scanVC.hidden     = NO;
        inputVC.hidden    = YES;
    }
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
