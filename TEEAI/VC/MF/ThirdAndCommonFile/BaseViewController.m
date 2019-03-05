//
//  BaseViewController.m
//  MifiManager
//
//  Created by notion on 2018/3/20.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
//#import "AppDelegate.h"
#import "NIWifiTool.h"
#import "ButtonContent.h"
#import "LoginViewController.h"
#import "ShowWIFIViewController.h"
#define NaviItemWidth 40
#define NaviItemHeight 44
const BOOL isShowBaseLog=NO;
#define BGImageTag 100
#define isPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
@interface BaseViewController ()
@property (nonatomic, strong) UIView *naviView;
@property (nonatomic, strong) UIImageView *bgView;


@end

@implementation BaseViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self dealNetChange];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    UIViewController *current = [self getPresentedViewController];
//    if ([current isKindOfClass:[ShowWIFIViewController class]]) {
//        [current dismissViewControllerAnimated:YES completion:nil];
//    }
}

- (void)viewDidLoad {
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:ColorGreenLight];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent; 
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealNetChange) name:NotifyNetChangeName object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appOut) name:UIApplicationWillResignActiveNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appIn) name:UIApplicationDidBecomeActiveNotification object:nil];
//    [self checkAPP];
    
    //设置导航栏背景颜色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:88/255.0 green:128/255.0 blue:192/255.0 alpha:1];
    
   
}


#pragma mark MBProgress
-(void)initMBProgress{
    //初始化
    self.mbProgress=[[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:self.mbProgress];
    self.mbProgress.removeFromSuperViewOnHide=YES;
    
    //如果设置此属性则当前的view置于后台,有黑色阴影
    //    self.mbProgress.dimBackground = YES;
}

- (void)dealloc
{
    NSLog(@"释放类===%@",self.classForCoder);
}

-(void)mbShowLoading{
    [self mbShowLoadingText:@"正在加载"];
}

-(void)mbShowLoadingText:(NSString*)loadingText{
    if (!self.mbProgress) {
        [self initMBProgress];
    }else{
        if ([NSThread currentThread] == 0) {
            [self.view addSubview:self.mbProgress];
            self.mbProgress.label.text=loadingText;
            self.mbProgress.mode = MBProgressHUDModeIndeterminate;
            [self.mbProgress showAnimated:YES];
        }
    }
}

-(void)mbShowLoadingProgress:(NSString*)loadingText{
    if (!self.mbProgress) {
        [self initMBProgress];
    }else{
        [self.view addSubview:self.mbProgress];
    }
    self.mbProgress.progress=0;
    self.mbProgress.label.text=loadingText;
    self.mbProgress.mode = MBProgressHUDModeDeterminate;
    [self.mbProgress showAnimated:YES];
}
-(void)mbShowLoadingProgressSec:(NSString*)loadingText{
    if (!self.mbProgress) {
        [self initMBProgress];
    }else{
        [self.view addSubview:self.mbProgress];
    }
    self.mbProgress.progress=0;
    self.mbProgress.label.text=loadingText;
    self.mbProgress.mode = MBProgressHUDModeAnnularDeterminate;
    [self.mbProgress showAnimated:YES];
}
-(void)mbShowToast:(NSString*)str{
    if (!self.mbProgress) {
        [self initMBProgress];
    }else{
        [self.view addSubview:self.mbProgress];
    }
    self.mbProgress.label.text=str;
    self.mbProgress.mode = MBProgressHUDModeText;
    [self.mbProgress showAnimated:YES];
    [self performSelector:@selector(mbDismiss) withObject:nil afterDelay:3];
}

-(void)mbShowCustom:(UIView*)view withText:(NSString*)text{
    if (!self.mbProgress) {
        [self initMBProgress];
    }else{
        [self.view addSubview:self.mbProgress];
    }
    self.mbProgress.label.text=text;
    self.mbProgress.mode = MBProgressHUDModeCustomView;
    self.mbProgress.customView=view;
    [self.mbProgress showAnimated:YES];
}

-(void)mbDismissDelayTime:(NSTimeInterval)time{
    [self.mbProgress hideAnimated:YES afterDelay:time];
}

-(void)mbDismiss{
//    [self mbDismissDelayTime:0];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)loadSelfNavi{
//    self.navigationController.navigationBar.barTintColor = NormalBlue;
//    
//    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HeightNanvi)];
//    naviView.backgroundColor = NormalBlue;
//    [self.view addSubview:naviView];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, (HeightNaviBar - HeightLabel)/2+HeightStateBar, SCREEN_WIDTH, HeightLabel)];
//    label.text = self.title;
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [UIFont systemFontOfSize:20];
//    label.textColor = ColorWhite;
//    [naviView addSubview:label];
//    
//    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(MarginX, (HeightNaviBar - HeightImage)/2+HeightStateBar, 48, HeightImage)];
//    [back setImage:[UIImage imageNamed:@"arrowLeft"] forState:UIControlStateNormal];
//    [back addEvent:^(UIButton *btn){
//        [self.navigationController popViewControllerAnimated:YES];
//    }];
//    [naviView addSubview:back];
}

- (void)loadSubViewLayer:(UIView *)subView{
    subView.backgroundColor = NormalGray;
    subView.layer.borderColor = NormalGray.CGColor;
    subView.layer.borderWidth = BorderWidth;
    subView.layer.cornerRadius = BorderCircle;
    subView.clipsToBounds = YES;
}

- (void)loadSubViewLayer:(UIView *)subView withBorderCircle:(CGFloat)borderCircle borderColor:(UIColor *)borderColor{
    subView.layer.borderColor = borderColor.CGColor;
    subView.layer.borderWidth = BorderWidth;
    subView.layer.cornerRadius = borderCircle;
    subView.clipsToBounds = YES;
    
}

- (NSMutableAttributedString *)dealTrailText:(NSString *)text WithLength:(NSInteger)length MainFont:(UIFont *)mainFont mainColor:(UIColor *)mainColor AssFont:(UIFont*)assFont assColor:(UIColor *)assColor{
    NSRange rangeMain = NSMakeRange(0, text.length - length);
    NSRange rangeAss = NSMakeRange(text.length - length, length);
    NSMutableAttributedString *textAtt = [[NSMutableAttributedString alloc] initWithString:text];
//    UIFont *font = [UIFont systemFontOfSize:]
    [textAtt addAttribute:NSFontAttributeName value:mainFont range:rangeMain];
    [textAtt addAttribute:NSForegroundColorAttributeName value:mainColor range:rangeMain];
    [textAtt addAttribute:NSFontAttributeName value:assFont range:rangeAss];
    [textAtt addAttribute:NSForegroundColorAttributeName value:assColor range:rangeAss];
    return textAtt;
}

- (CGRect)dealGetFrameWithX:(CGFloat)X Y:(CGFloat)Y Width:(CGFloat)Width Height:(CGFloat)Height{
    CGRect frame = CGRectMake(X, Y, Width, Height);
    return frame;
}

- (UILabel *)dealSetLabelWithTitle:(NSString *)text color:(UIColor *)color bgColor:(UIColor *)bgColor font:(UIFont *)font textAlign:(NSTextAlignment)textAlign frame:(CGRect)frame{
    UILabel *label = [UILabel new];
    label.frame = frame;
    label.textColor = color;
    label.backgroundColor = bgColor;
    label.textAlignment = textAlign;
    label.font = font;
    label.text = text;
    return label;
}
- (ButtonContent *)dealGetButtonWithTitle:(NSString *)title color:(UIColor *)color bgColor:(UIColor *)bgColor font:(UIFont *)font frame:(CGRect)frame image:(UIImage *)image{
    ButtonContent *button = [[ButtonContent alloc] initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundColor:bgColor];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button.titleLabel setFont:font];
    
    if (image) {
        [button setImage:image forState:UIControlStateNormal];
    }
//    [button setNeedsLayout];
    [button layoutIfNeeded];
    return button;
}
- (UIButton *)dealSetButtonWithTitle:(NSString *)title color:(UIColor *)color bgColor:(UIColor *)bgColor font:(UIFont *)font frame:(CGRect)frame image:(UIImage *)image{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundColor:bgColor];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button.titleLabel setFont:font];
    
    if (image) {
        [button setImage:image forState:UIControlStateNormal];
    }
    [button setNeedsLayout];
    [button layoutIfNeeded];
    return button;
}

- (UITableView *)dealSetTableViewWithCellHeight:(CGFloat)cellHeight frame:(CGRect)frame bgColor:(UIColor *)bgColor delegate:(id)delegate{
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    tableView.delegate = delegate;
    tableView.dataSource = delegate;
    tableView.backgroundColor = bgColor;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.estimatedRowHeight = cellHeight;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return tableView;
}

/**
 处理textFiled 添加前标和后缀

 @param field 输入框
 @param title 标题
 @param imageArray 图片
 @param secureText 是否为密码输入符
 @param selected 是否显示密码
 */
- (void)dealSetTextField:(UITextField *)field title:(NSString *)title imageArray:(NSArray<UIImage *> *)imageArray secureText:(BOOL)secureText selected:(BOOL)selected{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH(field)/3, VIEW_HEIGHT(field))];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = FontLarge;
    label.backgroundColor = [UIColor redColor];
    label.text = title;
    field.leftView = label;
    field.secureTextEntry = secureText;
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    if (imageArray) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, VIEW_HEIGHT(field), VIEW_HEIGHT(field))];
        if(imageArray[0]){
            [button setImage:imageArray[0] forState:UIControlStateNormal];
        }
        if (imageArray[1]) {
            [button setImage:imageArray[1] forState:UIControlStateSelected];
        }
        [field setRightView:button];
        button.selected = selected;
        [button addEvent:^(UIButton *btn){
            btn.selected = !btn.selected;
            field.secureTextEntry = !field.secureTextEntry;
        }];
    }
}
/**得到字符高度*/
- (CGFloat)getText:(NSString *)text HeightWithWidth:(CGFloat)width andFont:(UIFont *)font{
    NSDictionary * attr=@{NSFontAttributeName:font};
    CGRect size = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil];
    return size.size.height;
}

/**
 获取字符串高度

 @param text 字符串
 @param height 高度
 @param font 字样
 @return 高度
 */
- (CGFloat)getText:(NSString *)text WidthWithHeight:(CGFloat)height andFont:(UIFont *)font{
    NSDictionary * attr=@{NSFontAttributeName:font};
    CGRect size = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil];
    return size.size.width;
}

- (void)topMoreClick {
}
#pragma mark - 网络检测
/**
每次打开项目都会判断网络是否被切换
 */
- (void)dealNetChange{
    
    NSString *netValue = [NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI];
    
    if ([netValue isEqualToString:NetValueLost]) {
        [self dealSetBGViewWithConnectStatus:false];
        //无网络
        [self showWIFIAlert];
    }else if ([netValue isEqualToString:NetValueCommonNet]){
        [self dealSetBGViewWithConnectStatus:false];
        //有网，但不是MIFI
        [self showWIFIAlert];
    }else if ([netValue isEqualToString:NetValueMIFINet]){
        
        [self dealSetBGViewWithConnectStatus:YES];
       
    }
}
/**
 获取当前网络状态
 */
- (void)getNetStateBlock:(void(^)(AFNetworkReachabilityStatus netState))Block{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager ] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case -1:
                NSLog(@"未知网络");
                break;
            case 0:
                NSLog(@"网络不可达");
                break;
            case 1:
                NSLog(@"GPRS网络");
                break;
            case 2:
                NSLog(@"wifi网络");
                break;
            default:
                break;
        }
        if (Block) {
            Block(status);
        }
        
        if(status == AFNetworkReachabilityStatusReachableViaWiFi)
        {
            NSLog(@"有网");
        }else
        {
            NSString *netName = [NIWifiTool getWifiName];
            NSString *baseName = [NIUerInfoAndCommonSave getValueFromKey:NET_NAME];
            if (![netName isEqualToString:baseName] && baseName) {
                [self showWIFIAlert];
            } else {
                
            }
            
        }
    }];
}

/**
 获取网络类型

 @return 当前类型
 */
- (NSString *)getNetType
{
    NSString * netconnType = [NSString string];
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    NSString *currentStatus = info.currentRadioAccessTechnology;
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]) {
        netconnType = @"GPRS";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]) {
        netconnType = @"2.75G EDGE";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
        netconnType = @"3G";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
        netconnType = @"3.5G HSDPA";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
        netconnType = @"3.5G HSUPA";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
        netconnType = @"2G";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
        netconnType = @"3G";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
        netconnType = @"3G";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
        netconnType = @"3G";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
        netconnType = @"HRPD";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
        netconnType = @"4G";
    }
    return netconnType;
}
- (void)showWIFIAlert{
    UIViewController *current = [self getPresentedViewController];
    if ([current isKindOfClass:[ShowWIFIViewController class]]) {
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前网络不是MIFI随身路由器" preferredStyle:UIAlertControllerStyleAlert];
    self.alert = alert;
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"更换网络" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self.alert dismissViewControllerAnimated:YES completion:nil];
        [self ShowWIFI];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"退出MiFI" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        [self.alert dismissViewControllerAnimated:YES completion:nil];
        [self.tabBarController.navigationController popViewControllerAnimated:true];
    }];
    [alert addAction:confirm];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
   
    
}
- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 弹窗提示

///**
// 隐藏弹框
// */
//- (void)dealHideAlert{
//
////    if (_alert) {
////        [_alert dismissViewControllerAnimated:YES completion:nil];
////    }
//}
/**
 检测是否需要登录

 @param response 检测字符
 @return 是否
 */
- (BOOL)checkLoginWithOperationResponse:(NSString *)response{
    LoginStatus *status = [LoginStatus initWithResponseXmlString:response];
    if (status && [status.loginStatus isEqualToString:@"KICKOFF"]) {
        [self showNeedLoginAlert];
        return YES;
    }else{
        return NO;
    }
}

/**
 展示需要重新登录
 */
- (void)showNeedLoginAlert{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"请重新登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *cancel){
        [self dealExitAPP];
        [self.tabBarController.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *confirm){
        [alert dismissViewControllerAnimated:YES completion:nil];
        LoginViewController *login = [LoginViewController alloc];
        [self presentViewController:login animated:YES completion:nil];
    }];
    [alert addAction:cancel];
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];
    _alert = alert;
}

/**
 状态修改后需要重新登录
 */
- (void)showNeedRelogin{
    //needRelogin
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"请重新登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *cancel){
        [self dealExitAPP];
        [self.tabBarController.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *confirm){
        [alert dismissViewControllerAnimated:YES completion:nil];
        LoginViewController *login = [LoginViewController alloc];
        [self presentViewController:login animated:YES completion:nil];
    }];
    [alert addAction:cancel];
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];
    _alert = alert;
}

- (void)dealExitAPP{
//    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    UIWindow *window = app.window;
//
//    [UIView animateWithDuration:1.0f animations:^{
//        window.alpha = 0;
//        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
//    } completion:^(BOOL finished) {
//        exit(0);
//    }];
    
    //exit(0);
}



//返回根视图
- (void)dealGotoRoot{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
/**
 跳转到WIFI设置界面
 */
- (void)jumpToNetSetting{
    BOOL appVersion = [[NIUerInfoAndCommonSave getValueFromKey:@"APP"] boolValue];
    if (appVersion) {
        [self ShowWIFI];
    }else{
        [self ShowWIFI];
    }
}

- (void)ShowWIFI{
    ShowWIFIViewController *showWIFI = [ShowWIFIViewController new];
    
    [self presentViewController:showWIFI animated:YES completion:nil];
}

- (void)showWIFISetting{
    //跳转到“About”(关于本机)页面
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

/**
 设置控制器背景图片

 @param connectStatus 是否连接MIFI
 */
- (void)dealSetBGViewWithConnectStatus:(BOOL)connectStatus{
    if (connectStatus) {
        _bgView.image = IMAGE(@"viewBG");
    }else{
        _bgView.image = IMAGE(@"bgImageTwo");
    }
}
#pragma mark - 界面切换处理
//- (void)appOut{
////    NILog(@"123out");
//    [self dealHideAlert];
//}
//- (void)appIn{
////    NILog(@"app in");
//    [self dealHideAlert];
//    [self needToRefresh];
//}

- (void)checkAPP{
    //1384329212
    NSString *ver = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil]];
    //POST必须上传的字段
    NSDictionary *dict = @{@"id":@"1384329212"};//此处的Apple ID
    [mgr POST:@"https://itunes.apple.com/lookup" parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSArray *array = responseObject[@"results"];
        NSDictionary *dict = array.firstObject;
        //判断版本  [dict[@"version"] floatValue] > [ver floatValue]
        BOOL appStandard = ([dict[@"version"] floatValue] >= [ver floatValue]);
        if([dict[@"version"] floatValue]==0 && dict)
        {
            appStandard = YES;
        }
        appStandard = YES;
        [NIUerInfoAndCommonSave saveValue:[NSNumber numberWithBool:appStandard] key:@"APP"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [NIUerInfoAndCommonSave saveValue:[NSNumber numberWithBool:false] key:@"APP"];
    }];
}
- (UIViewController *)getPresentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}
/**
 界面刷新
 */
- (void)needToRefresh{
    
}

#pragma mark - 尾
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
