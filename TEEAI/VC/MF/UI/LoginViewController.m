//
//  LoginViewController.m
//  MifiManager
//
//  Created by notion on 2018/3/23.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "LoginViewController.h"
#import "NotionEnterView.h"
#import "UpdateButton.h"
#import "MainViewController.h"
#import "NIHttpUtil.h"
#import "UITextField+Validate.h"
#import "LoginEnterView.h"
#import "MainTabViewController.h"
#import "APPIconView.h"
#import "ButtonContent.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIView *loginEnterView;
@property (nonatomic, strong) LoginEnterView *enterView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorWhite;
    [self loadMainView];
    // Do any additional setup after loading the view.
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotifyNetChangeName object:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    CGFloat iconWidth = 90*Ratio;
    CGFloat iconX = (SCREEN_WIDTH - iconWidth)/2;
    
    APPIconView *icon = [[APPIconView alloc] initWithFrame:[self dealGetFrameWithX:iconX Y:iconX Width:iconWidth Height:iconWidth]];
    [self.view addSubview:icon];
    
    [self dealNetChange];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealNetChange:) name:NotifyNetChangeName object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMainView) name:UIApplicationDidBecomeActiveNotification object:nil];
}
#pragma mark - 输入密码
/**
 显示输入登录
 */
- (void)loadMainView{
    [self.view clear];
    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bg.image = [UIImage imageNamed:@"home_bg"];
    [self.view addSubview:bg];
    
    CGFloat iconWidth = 45*Ratio;
    CGFloat iconX = (SCREEN_WIDTH - iconWidth)/2;
    
    APPIconView *icon = [[APPIconView alloc] initWithFrame:[self dealGetFrameWithX:iconX Y:iconX Width:iconWidth Height:iconWidth]];
    [self.view addSubview:icon];
    
    CGFloat heightEnter = 45*Ratio;
    CGFloat heightEnterView = heightEnter*2 + 13*Ratio;
    CGFloat verticalPaddingLarge = 45*Ratio;
    CGFloat verticalPaddingBottom = 20*Ratio;
    CGFloat heightTool = 35*Ratio;
    
    CGFloat heightLoginEnter = heightEnterView+verticalPaddingLarge+heightEnter+verticalPaddingLarge+heightTool + verticalPaddingBottom;
    UIView *loginEnterView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - heightLoginEnter, SCREEN_WIDTH, heightLoginEnter)];
    loginEnterView.backgroundColor = ColorClear;
    [self.view addSubview:loginEnterView];
    NSString *name = [NIUerInfoAndCommonSave getValueFromKey:ADMIN_NAME];
    NSString *psw = [NIUerInfoAndCommonSave getValueFromKey:ADMIN_PSW];
    
    LoginEnterView *enterPsw = [[LoginEnterView alloc] initWithFrame:[self dealGetFrameWithX:0 Y:0 Width:SCREEN_WIDTH Height:heightEnterView] name:name psw:psw];
    [loginEnterView addSubview:enterPsw];
    [enterPsw.textPsw setDelegate:self];
    [enterPsw.textName setDelegate:self];
    _enterView = enterPsw;
    
    NSString *versionName = [NIUerInfoAndCommonSave getValueFromKey:VersionName];
    if ([versionName isEqualToString:VersionCPE]) {
//        [enterPsw.textName setText:@"admin"];
//        [enterPsw.textName setUserInteractionEnabled:NO];
    }else{
        if (name) {
            [enterPsw.textName setText:name];
        }else{
            [enterPsw.textName setText:@""];
        }
        [enterPsw.textName setUserInteractionEnabled:YES];
    }
    enterPsw.textName.text = @"admin";
    enterPsw.textPsw.text = @"123456";
    ButtonContent *button = [[ButtonContent alloc] initWithFrame:[self dealGetFrameWithX:VIEW_X(enterPsw.textName) Y:VIEW_BOTTOM(enterPsw)+verticalPaddingLarge Width:VIEW_WIDTH(enterPsw.textName) Height:VIEW_HEIGHT(enterPsw.textName)]];
    [button setTitle:@"连接MIFI" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:ColorBlueDeep] forState:UIControlStateNormal];
    [button setBackgroundColor:ColorWhite];
    WeakSelf;
    [button addEvent:^(UIButton *btn){ //@"connecting"
        if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [weakSelf showWIFIAlert];
            return;
        }
        NSString *nameValid = [weakSelf.enterView.textName validateWithMethod:ValidCommon];
        if (nameValid) {
//            [self mbShowToast:nameValid];
            [weakSelf.enterView becomeFirstResponder];
            return ;
        }
        NSString *pswValid = [weakSelf.enterView.textPsw validateWithMethod:ValidCommon];
        if (pswValid) {
//            [self mbShowToast:pswValid];
            [weakSelf.enterView.textPsw becomeFirstResponder];
            return;
        }
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [weakSelf loadDataWithName:enterPsw.textName.text password:enterPsw.textPsw.text];
    }];
    [button setLayerWithBorderWidth:0 BorderColor:ColorClear CornerRadius:5];
    [loginEnterView addSubview:button];
    
    UIView *buttom = [[UIView alloc] initWithFrame:CGRectMake(0, VIEW_BOTTOM(button)+verticalPaddingLarge, SCREEN_WIDTH, heightTool)];
    
    CGFloat imageWidth = 25*Ratio;
    UIImageView *toolImage = [[UIImageView alloc] initWithFrame:[self dealGetFrameWithX:SCREEN_WIDTH/2 - imageWidth - MarginX/2 Y:VIEW_HEIGHT(buttom)/2- imageWidth/2 Width:imageWidth Height:imageWidth]];
    toolImage.image = IMAGE(@"loginTool");
    [buttom addSubview:toolImage];
    
    UILabel *toolLabel = [[UILabel alloc] initWithFrame:[self dealGetFrameWithX:SCREEN_WIDTH/2+MarginX/2 Y:VIEW_HEIGHT(buttom)/2 - HeightLabel/2 Width:100 Height:HeightLabel]];
    toolLabel.text = Localized(@"tool");
    toolLabel.textColor = ColorWhite;
    UIFont *font = FontLarge;
    toolLabel.font = font;
    [buttom addSubview:toolLabel];
//    [loginEnterView addSubview:buttom];
    
}
#pragma mark - 自动登录
/**
 显示自动登录网络界面
 */
- (void)loadEnterView{
    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bg.image = [UIImage imageNamed:@"viewBG"];
    [self.view addSubview:bg];
    
    CGFloat labelWidth = [self getText:@"正在连接" WidthWithHeight:HeightLabel andFont:FontSuperLarge];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - labelWidth - 50)/2, SCREEN_HEIGHT - 311/3 - HeightLabel*2, labelWidth, HeightLabel*2)];
    label.font = FontSuperLarge;
    label.text = Localized(@"connecting");
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = ColorWhite;
    [self.view addSubview:label];
    
    UILabel *labelDot = [[UILabel alloc] initWithFrame:[self dealGetFrameWithX:VIEW_RIGHT(label) Y:VIEW_Y(label)+5 Width:50 Height:HeightLabel]];
    labelDot.textColor = ColorWhite;
    labelDot.text = @"...";
    labelDot.font = FontSuperLarge;
    [self.view addSubview:labelDot];
    CGFloat timeDuration = 2;
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.keyPath = @"position";
    anim.duration = timeDuration;
    anim.fromValue = [NSValue valueWithCGPoint:labelDot.center];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(labelDot.center.x+50, labelDot.center.y)];
    anim.repeatCount = MAXFLOAT;
//    [labelDot.layer addAnimation:anim forKey:nil];
    CABasicAnimation *showViewAnn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    showViewAnn.fromValue = [NSNumber numberWithFloat:1.0];
    showViewAnn.toValue = [NSNumber numberWithFloat:0.0];
    showViewAnn.duration = timeDuration;
    showViewAnn.repeatCount = MAXFLOAT;
//    [labelDot.layer addAnimation:showViewAnn forKey:@"myShow"];
//    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:ADMIN_NAME];
//    NSString *psw = [[NSUserDefaults standardUserDefaults] objectForKey:ADMIN_PSW];
    NSString *name = [NIUerInfoAndCommonSave getValueFromKey:ADMIN_NAME];
    NSString *psw = [NIUerInfoAndCommonSave getValueFromKey:ADMIN_PSW];
    if (name.length > 0 && psw.length > 0) {
//        [self loadDataWithName:name password:psw];
    }else{
        [self loadMainView];
    }
    
}
#pragma mark - 设置网络
/**
 显示设置网络界面
 */
- (void)loadSetNetView{
//    WeakSelf;
//    [self jumpToNetSetting];
    [self.view clear];
    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bg.image = [UIImage imageNamed:@"home_bg"];
    [self.view addSubview:bg];

    CGFloat iconWidth = 90*Ratio;
    CGFloat iconX = (SCREEN_WIDTH - iconWidth)/2;

    APPIconView *icon = [[APPIconView alloc] initWithFrame:[self dealGetFrameWithX:iconX Y:iconX Width:iconWidth Height:iconWidth]];
    [self.view addSubview:icon];

    UILabel *labelWarning = [self dealSetLabelWithTitle:@"您没有连接到路由器" color:ColorWhite bgColor:ColorClear font:FontRegular textAlign:NSTextAlignmentCenter frame:[self dealGetFrameWithX:0 Y:VIEW_BOTTOM(icon)+MarginY Width:SCREEN_WIDTH Height:HeightLabel]];
    [self.view addSubview:labelWarning];

    ButtonContent *button = [self dealGetButtonWithTitle:@"连接" color:[UIColor colorWithHexString:ColorBlueDeep] bgColor:ColorWhite font:FontRegular frame:[self dealGetFrameWithX:20 Y:(SCREEN_HEIGHT - (SCREEN_HEIGHT - VIEW_BOTTOM(labelWarning))/2) Width:SCREEN_WIDTH - 40 Height:HeightButton] image:nil];
    [button setLayerWithBorderWidth:0 BorderColor:ColorWhite CornerRadius:BorderCircle];
    [self.view addSubview:button];
    [button addEvent:^(UIButton *btn){
        float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    
}
#pragma mark - 登录
- (void)loadDataWithName:(NSString *)name password:(NSString*)password{
    
    if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showWIFIAlert];
        return;
    }
    WeakSelf;

    [NIHttpUtil loginWithUsername:name password:password success:^(id responseObj) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [NIUerInfoAndCommonSave saveValue:name key:ADMIN_NAME];
        [NIUerInfoAndCommonSave saveValue:password key:ADMIN_PSW];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotifyLoginSuccess object:nil];
        
        
        [self dismissViewControllerAnimated:true completion:nil];
        
        return;
    } failure:^(NSError *error) {
        [NIUerInfoAndCommonSave saveValue:@"" key:ADMIN_PSW];
        [weakSelf loadMainView];
//        [self mbShowToast:Localized(@"loginFail")];
        [weakSelf mbShowToast:error.localizedDescription];
    }];
}
#pragma mark - 根据当前网络显示界面
/**
 处理网络切换问题

 */
- (void)dealNetChange{
    
    NSString *netChangeValue = [[NSUserDefaults standardUserDefaults]valueForKey:@"netChange"];
    NSLog(@"%@",netChangeValue);
    if ([netChangeValue isEqualToString:NetValueLost]) {
        //无网络
        [self loadSetNetView];
    }else if ([netChangeValue isEqualToString:NetValueCommonNet]){
        //有网，但不是MIFI
        [self loadSetNetView];
    }else if ([netChangeValue isEqualToString:NetValueMIFINet]){
        //重新与MIFI连接
//        NSString *name = [NIUerInfoAndCommonSave getValueFromKey:ADMIN_NAME];
//        NSString *psw = [NIUerInfoAndCommonSave getValueFromKey:ADMIN_PSW];
//        if (name && psw) {
//            [self loadMainView];
//        }else{
//            [self loadMainView];
//        }
        [self loadMainView];
    }
}
- (void)showError:(NSNotification *)noti{
    
}
#pragma mark - 输入框监控
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _enterView.textName) {
        NSString *nameValid = [_enterView.textName validateWithMethod:ValidCommon];
        if (nameValid) {
            [self mbShowToast:nameValid];
        }else{
            [_enterView.textPsw becomeFirstResponder];
        }
    }else{
        NSString *nameValid = [_enterView.textName validateWithMethod:ValidCommon];
        if (nameValid) {
            [self mbShowToast:nameValid];
        }
        NSString *pswValid = [_enterView.textPsw validateWithMethod:ValidCommon];
        if (pswValid) {
            [self mbShowToast:pswValid];
        }
        [textField resignFirstResponder];
//        [self loadDataWithName:_enterView.textName.text password:_enterView.textPsw.text];
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
