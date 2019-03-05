//
//  MainTabViewController.m
//  MifiManager
//
//  Created by notion on 2018/4/19.
//  Copyright © 2018年 notion. All rights reserved.
//
#define ManulCellWidth (SCREEN_WIDTH - 12*2*Ratio-8*Ratio)/2
#define ManulCellHeight ManulCellWidth*2/3

#define ManulViewHeight ManulCellHeight*2+3*8*Ratio
#define TopViewHeight 40*Ratio
#define MainInfoViewHeight (320 - ManulViewHeight - 40*Ratio - 20)


#import "MainTabViewController.h"
#import "SettingViewController.h"
#import "MobileNetSettingViewController.h"
//pin
#import "PINManagerViewController.h"
#import "WiFiSettingViewController.h"
#import "AboutViewController.h"
#import "ConnectDevicesViewController.h"
#import "MessageViewController.h"
#import "PackageViewController.h"

#import "MainInfoView.h"
#import "ManulCellView.h"

#import "NIHttpUtil.h"
#import "NIAuthModel.h"
#import "NIStatus1Model.h"
#import "NISelectModel.h"

#import "WanStatistics.h"
#import "Statistics.h"
#import "NIGMBManagerTool.h"
#import "NICommonUtil.h"
#import "LanguageModel.h"
#import "CPEInterfaceMain.h"
#import "LoginViewController.h"
#import "Reachability.h"
#import "ZZCircleProgress.h"

@interface MainTabViewController ()
{
     dispatch_source_t _timer;
}
@property (nonatomic, assign) int updateDevice;
@property (nonatomic, strong) NIStatus1Model *status1;
@property (nonatomic, strong) Reachability *hostReachability;
@property (nonatomic, strong) Reachability *routerReachability;
@property (nonatomic, assign) NSInteger version;

@property (nonatomic, copy) NSString *ssid;


@property (weak, nonatomic) IBOutlet ZZCircleProgress *flowView;
@property (weak, nonatomic) IBOutlet ZZCircleProgress *powerView;
//@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (weak, nonatomic) IBOutlet UILabel *SIMLabel;
@property (weak, nonatomic) IBOutlet UILabel *noSIMLabel;
@property (weak, nonatomic) IBOutlet UILabel *wifiName;

@property (weak, nonatomic) IBOutlet UILabel *msmNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *liuliangLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceNumberLabel;


@property (nonatomic, strong)UIButton *backButton ;
//@property (nonatomic, strong) NSTimer *timer;

@end

@implementation MainTabViewController
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.title = @"随身路由器";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:NotifyRefreshName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:NotifyLoginSuccess object:nil];
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.tabBarController.tabBar setHidden:false];
    
    [self.tabBarController.navigationController.navigationBar setHidden:YES];
    [self.tabBarController.navigationController.tabBarController.tabBar setHidden:YES];
    [self.navigationController.navigationBar setHidden:NO];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMinY(self.navigationController.navigationBar.frame), self.navigationController.navigationBar.frame.size.height/38*24, self.navigationController.navigationBar.frame.size.height)];
    [self.backButton setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [self. backButton addTarget:self action:@selector(goBack) forControlEvents: UIControlEventTouchUpInside];
    [window addSubview:self.backButton];
    
}



- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.backButton removeFromSuperview];
    [self.navigationController.navigationBar setHidden:NO];
}

-(void)setSsid:(NSString *)ssid {
    _ssid = ssid;
    [self uploadDevice];
}

-(void)goBack {
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏背景颜色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:88/255.0 green:128/255.0 blue:192/255.0 alpha:1];

    self.flowView.pathBackColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
    self.flowView.pathFillColor = UIColor.whiteColor;
    self.flowView.progress = 0;
    self.flowView.showProgressText = NO;
    self.flowView.startAngle = -90;
    self.powerView.pathBackColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
    self.powerView.pathFillColor = UIColor.whiteColor;
    self.powerView.progress = 0;
    self.powerView.startAngle = -90;
    
    self.updateDevice = 0;
//    // 判断是不是添加mifi设备
//    TEETabBarVC *tabvc = (TEETabBarVC *)self.tabBarController;
//
//    if (tabvc.addmifi == true) {
//        [self jumpToNetSetting];
//    }
    
    
    //  现在的问题就首页检测不了mifi网络
    
     _version = [[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]?1:0;
    
    if([NIUerInfoAndCommonSave getValueFromKey:ADMIN_NAME] == nil || [NIUerInfoAndCommonSave getValueFromKey:ADMIN_PSW] == nil ) {
        [self showNeedRelogin];
    }else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self loadData];
        NSTimeInterval period = 10.0; //设置时间间隔
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
        WeakSelf;
        dispatch_source_set_event_handler(_timer, ^{
            //
            [weakSelf loadData];
        });
        
        dispatch_resume(_timer);
        [NIUerInfoAndCommonSave saveValue:[NSNumber numberWithBool:YES] key:Timer];

    }
    
    
    // 获取wifi信息-上报给服务器
//    [CPEInterfaceMain getWifiDetailSuccess:^(CPEWiFiDetail *wifiDetail){
//        [self mbDismiss];
//        [self setSsid:wifiDetail.ssid];
//    } failure:^(NSError *error){
//        [self mbDismiss];
//    }errorCause:^(NSString *errorCause){
//        [self mbDismiss];
//    }];

}

//把设备信息 上报给服务器
-(void)uploadDevice {
    if (self.updateDevice == 0) {
        NSArray *deviceArr  = [NIUerInfoAndCommonSave getValueFromKey:@"devices"];
        
        Boolean has = false;
        for (NSDictionary *deviceDist in deviceArr) {
            NSLog(@"list = %@",deviceDist);
            if ([deviceDist[@"deviceSsid"] isEqualToString:self.ssid]) {
                has = true;
            }
        }
        if (has == false) {
            NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,@"api/device/bind"];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"code"]       = @"100104";
            dict[@"token"]      = [NIUerInfoAndCommonSave getValueFromKey:@"access_token"];
            dict[@"deviceType"] = @"1"; // 0:路由器,1:mifi
            dict[@"deviceMac"]  = @"mac";//[NIWifiTool getWiFiMac];
            dict[@"deviceIp"]   = [NIWifiTool getIPAddress]; // @"deviceIp";
            
            dict[@"deviceName"] = self.ssid; //@"mifi09f3";//
            dict[@"deviceSsid"] = self.ssid;//[NIWifiTool getWifiName];
            dict[@"deviceUserName"] = @"admin";//[NIWifiTool getWifiName];
            dict[@"deviceIcon"] = @"deviceIcon";//[NIWifiTool getWifiName];
            dict[@"devicePassWord"] = @"123456";//[NIWifiTool getWifiName];
            
            // 把设备信息 上报给服务器
            [NIHttpUtil postWithIp:url params:dict xmlString:nil success:^(AFHTTPRequestOperation *operation, id responseObj) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self setUpdateDevice:1];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
        }
    }
}

-(void)dealNetChange {
    [super dealNetChange];
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
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 数据相关
/**
 加载数据
 */
- (void)loadCPE{
    //设置电池
//    [self mbShowLoading];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self dealSetBattery];
    //获取流量
    WeakSelf;
    [CPEInterfaceMain getCPEENGStartSuccess:^(CPEStatisticsStatSetting *statisticsStr){
        
    } failure:^(NSError *error){
        
    } errorCause:^(NSString *str){
        
    }];
    [CPEInterfaceMain getWanStatisticsSuccess:^(CPEStatisticsStatSetting *statisticsSetting){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *total = nil;
        NSString *used = @"0.0KB";
        BOOL alarm = NO;
        CGFloat progress = 0;
        //套餐
        CPEBasicMon *monData = statisticsSetting.basicMon;
        if ([monData.enable isEqualToString:@"1"]) {
            [CPEInterfaceMain getWanCurMonthSuccess:^(CPEStatCurMon *monStat){
                BOOL warning = NO;
                NSString *monTotalStr = [NIGMBManagerTool getNetNumberWithDBString:statisticsSetting.basicMon.avlData];
                NSString *monUsedStr = [NIGMBManagerTool getNetNumberWithDBString:monStat.basicMonUsed];
                float monTotal = statisticsSetting.basicMon.avlData.floatValue;
                float monUsed = monStat.basicMonUsed.floatValue;
                float monWarnging = monTotal * (1 - statisticsSetting.general.warnPercent.floatValue/100);
                float monProgress = monUsed/monTotal;
                if (monProgress > 1) {
                    monProgress = 1;
                }
                if (monUsed > monWarnging) {
                    warning = YES;
                }
                if (![statisticsSetting.general.warnEnable isEqualToString:@"1"]) {
                    warning = false;
                }
//                [weakSelf dealSetFlowDataTitleWithAlarm:warning];
                [weakSelf dealShowFlowPlanTotal:monTotalStr used:monUsedStr progress:monProgress  isAlarm:warning];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            } failure:^(NSError *error){
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                //[weakSelf mbShowToast:error.localizedDescription];
            } errorCause:^(NSString *errorCause){
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                if ([errorCause isEqualToString:CPEResultNeedLogin]) {
                    [weakSelf showNeedRelogin];
                }
            }];
        }else{
            [weakSelf dealShowFlowPlanTotal:total used:used progress:progress  isAlarm:alarm];
        }
        
    } failure:^(NSError *error){
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        //[weakSelf mbShowToast:error.localizedDescription];
        //流量
        NSString *total = nil;
        NSString *used = @"0.0KB";
        BOOL alarm = NO;
        CGFloat progress = 0;

        [weakSelf dealShowFlowPlanTotal:total used:used progress:progress  isAlarm:alarm];
    }errorCause:^(NSString *errorCause){
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([errorCause isEqualToString:CPEResultNeedLogin]) {
            [weakSelf showNeedRelogin];
        }
    }];
    
    
    //获取网络情况
    [CPEInterfaceMain getSimStatusSuccess:^(CPESimStatus *simStatus){
        [NIUerInfoAndCommonSave saveValue:simStatus.simStatus key:StatusSIM];
        [NIUerInfoAndCommonSave saveValue:simStatus.pinStatus key:StatusPIN];
        NSString *netName = [NICommonUtil getCPENetNameWithSimStatus:simStatus.simStatus PinStaus:simStatus.pinStatus];

        self.SIMLabel.text = netName;
        [self.noSIMLabel setHidden:YES];
        
    } failure:^(NSError *error){
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.SIMLabel.text = @"SIM卡";
        [self.noSIMLabel setHidden:YES];
        //[weakSelf mbShowToast:error.localizedDescription];
    } errorCause:^(NSString *errorCause){
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.SIMLabel.text = @"SIM卡";
        [self.noSIMLabel setHidden:YES];
        if ([errorCause isEqualToString:CPEResultNeedLogin]) {
            [weakSelf showNeedRelogin];
        }
    }];
    
    //获取路由器wifi
    [CPEInterfaceMain getWifiDetailSuccess:^(CPEWiFiDetail *wifiDetail){
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [self loadViewWithName:wifiDetail.ssid key:wifiDetail.key];
        [NIUerInfoAndCommonSave saveValue:wifiDetail.ssid key:NET_NAME];

        self.wifiName.text = wifiDetail.ssid;
        if (![wifiDetail.ssid isEqualToString:@""]) {
            self.ssid = wifiDetail.ssid;
        }
    } failure:^(NSError *error){
         [MBProgressHUD hideHUDForView:self.view animated:YES];
       // [weakSelf mbShowToast:error.localizedDescription];
    }errorCause:^(NSString *errorCause){
         [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    //获取连接设备
    [CPEInterfaceMain getConnectDevicesSuccess:^(NSArray *client){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *device = [NSString stringWithFormat:@"%d",(int)client.count];
        self.deviceNumberLabel.text =  [NSString stringWithFormat:@"(%@)",device];
    } failure:^(NSError *error){
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        //[weakSelf mbShowToast:error.localizedDescription];
        
        self.deviceNumberLabel.text = @"(0)";
    }errorCause:^(NSString *errorCause){
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        self.deviceNumberLabel.text = @"(0)";
        if ([errorCause isEqualToString:CPEResultNeedLogin]) {
            [weakSelf showNeedRelogin];
        }
    }];
    
    //获取短信
    [CPEInterfaceMain getUnreadMessageSuccess:^(CPEUnreadSMS *unreadMessage){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *message = [NSString stringWithFormat:@"%d",(int)unreadMessage.unreadNum];
//        NSString *messageText = [NSString stringWithFormat:@"%@ %@",message,Localized(@"MainTitleFour")];
        
        self.msmNumberLabel.text = [NSString stringWithFormat:@"(%@)",message];
    } failure:^(NSError *error){
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        //[weakSelf mbShowToast:error.localizedDescription];
        self.msmNumberLabel.text = @"(0)";
    } errorCause:^(NSString *errorCause){
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([errorCause isEqualToString:CPEResultNeedLogin]) {
            [weakSelf showNeedRelogin];
        }
        self.msmNumberLabel.text = @"(0)";
    }];
    //
}

- (void)dealloc
{
    NSLog(@"MainTabViewController  dealloc");
}


- (void)loadContext{
    
}

- (void)loadEng{
    
}

- (void)loadData{
    
    if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
        [self reloadManulView];
        return;
    }
    
    if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
        [self loadCPE];
        return;
    }
    
    
    WeakSelf;
    NSString *url = [NSString stringWithFormat:@"%@", MIFI_STATUS1_PATH];
    NSLog(@"url==%@",url);
    [NIHttpUtil get:url params:nil success:^(AFHTTPRequestOperation *operation, id responseObj) {
        NILog(@"%@",operation.responseString);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        // 检测是否需要登录
        BOOL check = [weakSelf checkLoginWithOperationResponse:operation.responseString];
        if (check) {
            
            [weakSelf showNeedRelogin];
            return ;
        }
        [weakSelf dealSetBGViewWithConnectStatus:YES];
        NIStatus1Model *routerInfo = [NIStatus1Model status1WithResponseXmlString:operation.responseString];
        if (routerInfo.wan == nil) {
            [weakSelf showNeedRelogin];
            return;
        }
        weakSelf.status1 = routerInfo;
        [weakSelf reloadManulWithInfo:routerInfo];
        [weakSelf loadNetData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf mbShowToast:@"获取数据失败"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"error===%@",error);
       // [weakSelf mbShowToast:error.localizedDescription];
    }];
}

- (void)loadNetData{
    WeakSelf;
    NSString *url = [NSString stringWithFormat:@"%@", MIFI_STATISTICS_GET_PATH];
    [NIHttpUtil get:url params:nil success:^(AFHTTPRequestOperation *operation, id responseObj) {
        Statistics *statistics = [Statistics initWithResponseXmlString:operation.responseString isRGWStartXml:YES];
        [weakSelf reloadMainWithInfo:statistics];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //[weakSelf mbShowToast:error.localizedDescription];
    }];
}

/**
 准备初始化数据
 */
- (void)setInitData{
    _dataArray = [NSMutableArray array];
    [_dataArray addObject:[NISelectModel setTitle:@"--" value:IMAGE(@"MainOne1")]];
    [_dataArray addObject:[NISelectModel setTitle:Localized(@"MainTitleTwo") value:IMAGE(@"MainTwo")]];
    [_dataArray addObject:[NISelectModel setTitle:Localized(@"MainTitleThree") value:IMAGE(@"MainThree")]];
    [_dataArray addObject:[NISelectModel setTitle:Localized(@"MainTitleFour") value:IMAGE(@"MainFour")]];
}

#pragma mark - 重载数据
#pragma mark - CPE
- (void)loadCPESimStatus:(CPESimStatus *)simStatus{
    
}
#pragma mark - 1802
/**
 重载信息面板数据
 
 @param statistics 信息
 */
- (void)reloadMainWithInfo:(Statistics *)statistics{
    
    //流量
//    [_flowView.viewSignal clear];
//    [_flowView.viewCircle clear];
//    [_flowView.viewSignal setBackgroundColor:ColorClear];
    //设置UI
    WanStatistics *wanStatistics = statistics.wanStatistics;
    NSInteger statMangMethod = [wanStatistics.statMangMethod integerValue];
    NSString *total = @"0.0KB";
    NSString *used = @"0.0KB";
    BOOL alarm = NO;
    CGFloat progress = 0;
    if (statMangMethod == NWStatisticsTimeForbidInt) {
//        [self dealSetFlowDataTitleWithAlarm:alarm];
        
        [self dealShowFlowPlanTotal:total used:used progress:progress  isAlarm:alarm];
    }else {
        if (statMangMethod == NWStatisticsTimeMonthInt){
            if (wanStatistics.totalAvaliableMonth.floatValue > 0 && wanStatistics.totalAvaliableMonth) {
                total = [NIGMBManagerTool getNetNumberWithDBString:wanStatistics.totalAvaliableMonth];
            }
            if (wanStatistics.totalUsedMonth) {
                used = [NIGMBManagerTool getNetNumberWithDBString:wanStatistics.totalUsedMonth];
            }
            if (wanStatistics.totalAvaliableMonth && wanStatistics.totalUsedMonth) {
                progress = [wanStatistics.totalUsedMonth floatValue]/[wanStatistics.totalAvaliableMonth floatValue];
                if (progress>=1) {
                    progress = 1;
                }
                alarm = [wanStatistics.totalUsedMonth floatValue]>=[wanStatistics.totalAvaliableMonth floatValue]?YES:NO;
            }
//            [self dealSetFlowDataTitleWithAlarm:alarm];
            [self dealShowFlowPlanTotal:total used:used progress:progress  isAlarm:alarm];
        }else if (statMangMethod == NWStatisticsTimeUnlimitedInt){
            if (wanStatistics.totalAvaliableUnlimit.floatValue > 0 && wanStatistics.totalAvaliableUnlimit) {
                total = [NIGMBManagerTool getNetNumberWithDBString:wanStatistics.totalAvaliableUnlimit];
            }
            if (wanStatistics.totalUsedUnlimit) {
                used = [NIGMBManagerTool getNetNumberWithDBString:wanStatistics.totalUsedUnlimit];
            }
            if (wanStatistics.totalAvaliableUnlimit && wanStatistics.totalUsedUnlimit) {
                progress = [wanStatistics.totalUsedUnlimit floatValue]/[wanStatistics.totalAvaliableUnlimit floatValue];
                if (progress>=1) {
                    progress = 1;
                }
                alarm = [wanStatistics.totalUsedUnlimit floatValue]>=[wanStatistics.totalAvaliableUnlimit floatValue]?YES:NO;
            }
//            [self dealSetFlowDataTitleWithAlarm:alarm];
            [self dealShowFlowPlanTotal:total used:used progress:progress  isAlarm:alarm];
        }
        
    }
    [self dealSetBattery];
    
}
/**
 重载控制面板数据
 
 @param routerInfo 数据
 */
- (void)reloadManulWithInfo:(NIStatus1Model *)routerInfo{
    [NIUerInfoAndCommonSave saveValue:routerInfo.wan.cellular.sim_status key:StatusSIM];
    [NIUerInfoAndCommonSave saveValue:routerInfo.wan.cellular.pin_status key:StatusPIN];
    NSString *netName = [NICommonUtil getNetName:routerInfo.wan.network_name ModeName:routerInfo.wan.sys_submode SIMStatus:routerInfo.wan.cellular.sim_status PINStatus:routerInfo.wan.cellular.pin_status];
    self.SIMLabel.text = netName;
    
    NSString *wlan = [routerInfo.wlan_security.ssid uniDecode];
    if(wlan == nil){
        wlan = [NIWifiTool getWifiName];
    }
    [NIUerInfoAndCommonSave saveValue:wlan key:NET_NAME];
    [NIUerInfoAndCommonSave saveValue:routerInfo.lan.ip key:NET_PATH];
    self.wifiName.text = wlan;
    if (![wlan isEqualToString:@""]) {
        self.ssid = wlan;
    }
    NSString *device = routerInfo.device_management.nr_connected_dev;
    self.deviceNumberLabel.text =  [NSString stringWithFormat:@"(%@)",device];;
    NSString *message = routerInfo.message.sms_capacity_info.sms_unread_long_num;
    self.msmNumberLabel.text = [NSString stringWithFormat:@"(%@)",message];
}

/**
 在不连接MIFI的情况下，刷新网络
 */
- (void)reloadManulView{
    NSString *netName = [NIWifiTool getWifiName];
    if(netName == nil || netName.length == 0){
        netName = [self getNetType];
    }
    
    
    
    // 回主线称
    dispatch_async(dispatch_get_main_queue(), ^{
         self.wifiName.text = netName;
        if (![netName isEqualToString:@""]) {
            self.ssid = netName;
        }
    });
}
#pragma mark - 视图相关

/**
 设置流量套餐数据及进度
 
 @param total 总流量
 @param used 已用流量
 @param progress 进度
 */
- (void)dealShowFlowPlanTotal:(NSString *)total used:(NSString *)used progress:(float)progress isAlarm:(BOOL)alarm{
    if (self.flowView.progress != progress) {
        self.flowView.progress = progress;
    }
    _liuliangLabel.text = [NSString stringWithFormat:@"%@",used];
}

/**
 设置电池信息
 */
- (void)dealSetBattery{
    NSString *battery =_status1.wan.Battery_voltage;
    if (battery == nil) {
        battery = @"0";
    }
    NSString *s1 = [NSString stringWithFormat:@"%.2f",_powerView.progress];
    NSString *s2 = [self roundFloat:battery];
    
    if (![s1 isEqualToString:s2]) {
        _powerView.progress = [s2 floatValue];
    }
}

-(NSString *)roundFloat:(NSString *)battery{
    NSString *str = [NSString stringWithFormat:@"%.2f",[battery floatValue]/100];
    return str;
    
}

#pragma mark - 跳转

- (void)pushToManulView:(UIButton *)button{
    if (button.tag == 0) {
        if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
            //            [self showWIFIAlert];
            return;
        }
        NSString *pinStatus = [NIUerInfoAndCommonSave getValueFromKey:StatusPIN];
        NSString *simStatus = [NIUerInfoAndCommonSave getValueFromKey:StatusSIM];
        NSLog(@"%@",simStatus);
        if (pinStatus.integerValue == 1 || pinStatus.integerValue == 2 ) {
            if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE] && pinStatus.intValue == 1) {
                [self mbShowToast:Localized(@"NetSIMError")];
                return;
            }
            PINManagerViewController *pin = [PINManagerViewController new];
            [self.navigationController pushViewController:pin animated:YES];
        }
       
        else{
            MobileNetSettingViewController *mobil = [MobileNetSettingViewController new];
            mobil.title = Localized(@"settingMobilNet");
            [self.navigationController pushViewController:mobil animated:YES];
        }
    }else if (button.tag == 1){
        if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
            [self showWIFIAlert];
            return;
        }
        WiFiSettingViewController *wifi = [WiFiSettingViewController new];
        wifi.title = @"Wi-Fi设置";
        [self.navigationController pushViewController:wifi animated:YES];
    }else if (button.tag == 2){
        if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
            //            [self showWIFIAlert];
            return;
        }
        ConnectDevicesViewController *device = [ConnectDevicesViewController new];
        device.title = @"设备列表";
        [self.navigationController pushViewController:device animated:YES];
    }else{
        if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
            //            [self showWIFIAlert];
            return;
        }
        MessageViewController *message = [MessageViewController new];
        message.title = @"信息列表";
        [self.navigationController pushViewController:message animated:YES];
    }
}

/**
 跳转到设置
 */
- (void)pushToSetting{
    if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
        [self showWIFIAlert];
        return;
    }
    SettingViewController *setting = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:setting animated:YES];
}


#pragma mark - 尾
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 点击事件

- (IBAction)toMessageAction:(id)sender {
    
    [self performSegueWithIdentifier:@"toMessageViewControllerVC" sender:self];
}
- (IBAction)toWiFiSettingVC:(id)sender {
    self.hidesBottomBarWhenPushed = NO;
    [self performSegueWithIdentifier:@"toWiFiSettingViewController" sender:self];
}

- (IBAction)ussdAction:(id)sender {
   [self performSegueWithIdentifier:@"toUSSDServiceViewController" sender:self];
}


- (IBAction)deviceManager:(id)sender {
    [self performSegueWithIdentifier:@"toConnectDevicesViewController" sender:self];
}

// 移动网络设置
- (IBAction)nettSetAction:(id)sender {
    [self performSegueWithIdentifier:@"toMobileNetSettingViewController" sender:self];
}


@end

