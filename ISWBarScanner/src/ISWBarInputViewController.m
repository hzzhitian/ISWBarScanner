//
//  BarInputViewController.m
//  youngcity
//
//  Created by chenxiaosong on 2017/11/23.
//  Copyright © 2017年 Zhitian Network Tech. All rights reserved.
//

#import "ISWBarInputViewController.h"

#import "Masonry.h"

#import "ISWBarScannerUtilties.h"
#import "ISWBarScannerDefines.h"

@interface ISWBarInputViewController ()
{
    UIView      *manualView;

    UITextField *inputTextField;
    UIButton    *confirmBtn;
}
@end

@implementation ISWBarInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setHidden:(BOOL)hidden
{
    self.view.hidden = hidden;

    if(hidden) {
        [inputTextField resignFirstResponder];
        inputTextField.text = nil;
    } else {
        [inputTextField becomeFirstResponder];
    }
}

- (void)setupUI
{
    WEAKSELF

    manualView = [[UIView alloc] initWithFrame:CGRectZero];
    manualView.backgroundColor     = [UIColor whiteColor];
    [self.view addSubview:manualView];
    [manualView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view);
    }];

    UIView *manualBgView = [[UIView alloc] initWithFrame:CGRectZero];
    manualBgView.backgroundColor     = [UIColor blackColor];
    manualBgView.alpha               = 0.7;
    [manualView addSubview:manualBgView];
    [manualBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.top.equalTo(manualView);
    }];

    inputTextField = [[UITextField alloc] init];
    inputTextField.textColor = [ISWBarScannerUtilties colorWithHexString:ISWBarScannerColorDarkGray];
    inputTextField.font      = [ISWBarScannerUtilties pingfangFont:18];
    inputTextField.backgroundColor   = [UIColor whiteColor];
    inputTextField.layer.borderWidth = [ISWBarScannerUtilties onePixel];
    inputTextField.layer.borderColor = [ISWBarScannerUtilties colorWithHexString:ISWBarScannerColorOutline].CGColor;
    inputTextField.layer.cornerRadius = 1;
    inputTextField.textAlignment = NSTextAlignmentCenter;
    inputTextField.keyboardType = UIKeyboardTypeNumberPad;
    [inputTextField setValue:[ISWBarScannerUtilties pingfangFont:15] forKeyPath:@"_placeholderLabel.font"];
    [inputTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [manualView addSubview:inputTextField];
    [inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(manualView).offset(12);
        make.trailing.equalTo(manualView).offset(-12);
        make.top.equalTo(manualView).offset(80);
        make.height.equalTo(@50);
    }];

    if( [ISWBarScannerUtilties isEmptyString:_placeholdTxt])
        inputTextField.placeholder = @"请输入数字";
    else
        inputTextField.placeholder = _placeholdTxt;//请输入充值码数字
 
    confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setImage:[ISWBarScannerUtilties imageWithColor:[ISWBarScannerUtilties colorWithHexString:ISWBarScannerColorMajorNormal]]
                forState:UIControlStateNormal];
    [confirmBtn setImage:[ISWBarScannerUtilties imageWithColor:[ISWBarScannerUtilties colorWithHexString:ISWBarScannerColorMajorHighlight]]
                forState:UIControlStateHighlighted];
    [confirmBtn setImage:[ISWBarScannerUtilties imageWithColor:[ISWBarScannerUtilties colorWithHexString:ISWBarScannerColorLightGray]]
                forState:UIControlStateDisabled];
    [ISWBarScannerUtilties setButtonTitleColorForAllStates:confirmBtn color:[UIColor whiteColor]];
    confirmBtn.titleLabel.font = [ISWBarScannerUtilties pingfangFont:17];
    [ISWBarScannerUtilties setButtonTitleForAllStates:confirmBtn title:@"确定"];
    [confirmBtn addTarget:self action:@selector(txtConfirmPressed) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.enabled = NO;
    [manualView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.leading.trailing.equalTo(manualView);
        make.bottom.equalTo(manualView);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)textFieldChange:(UITextField *)textField
{
    NSString *str = [ISWBarScannerUtilties trimWhitespace:inputTextField.text];

    confirmBtn.enabled = ![ISWBarScannerUtilties isEmptyString:str];
    
}

- (void)txtConfirmPressed
{
    NSString *str = [ISWBarScannerUtilties trimWhitespace:inputTextField.text];
    
    if([ISWBarScannerUtilties isEmptyString:str])
        return;

    if(_resultInput) _resultInput(inputTextField.text);
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    //获取处于焦点中的view
    UIView       *followingView = confirmBtn;
    NSDictionary *userInfo = notification.userInfo;
    
    //获取键盘弹出的时间
    double duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //获取键盘上端Y坐标
    CGFloat keyboardY = [userInfo [UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    
    //获取输入框下端相对于window的Y坐标
    CGRect  rect = [followingView convertRect:followingView.bounds toView:[[[UIApplication sharedApplication] delegate] window]];
    CGPoint tmp = rect.origin;
    CGFloat inputBoxY = tmp.y + followingView.frame.size.height;
    //计算二者差值
    CGFloat ty = keyboardY - inputBoxY;
    NSLog(@"position keyboard: %f, inputbox: %f, ty: %f", keyboardY, inputBoxY, ty);
    
    //差值小于0，做平移变换
    [UIView animateWithDuration:duration animations:^{
        if (ty < 0) {
            followingView.transform = CGAffineTransformMakeTranslation(0, ty);
        }
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    //获取键盘弹出的时间
    double duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //还原
    [UIView animateWithDuration:duration animations:^{
        confirmBtn.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
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
