//
//  MainViewController.m
//  MifiManager
//
//  Created by notion on 2018/3/20.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "MainViewController.h"
#define SectionHeight SCREEN_HEIGHT*0.45
#import "NIHttpUtil.h"
#import "NIAuthModel.h"
#import "NIStatus1Model.h"
#import "ActionView.h"

#import "MainHeaderView.h"
#import "MainTypeOneTableViewCell.h"
#import "MainTypeTwoTableViewCell.h"
#import "SettingViewController.h"

#import "ConnectDevicesViewController.h"
#import "MessageViewController.h"
#import "PackageViewController.h"

#import "WanStatistics.h"
#import "Statistics.h"
#import "NIGMBManagerTool.h"
@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) MainHeaderView *headerView;
@property (nonatomic, strong) NIStatus1Model *status1;
@property (nonatomic, assign) CGFloat cellHeight;
@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:YES];
    if (_status1 && _tableView) {
        [self loadData];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        image.image = [UIImage imageNamed:@"viewBG"];
    [self.view addSubview:image];
    [self loadMainView];
    [self loadData];
    [NSTimer timerWithTimeInterval:15 target:self selector:@selector(reloadData) userInfo:nil repeats:YES];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - UI
- (void)loadMainView{
    
    
    CGFloat heightHeaderView = 40;
    
    CGFloat cellHeight = (SCREEN_HEIGHT - heightHeaderView*Ratio - HeightStateBar - SectionHeight)/4;
    _cellHeight = cellHeight;
    
    UIView *headNaviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, heightHeaderView*Ratio+HeightStateBar)];
    headNaviView.backgroundColor = ColorClear;
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(MarginX, (heightHeaderView - HeightImageSmall)/2*Ratio+HeightStateBar, SCREEN_WIDTH, HeightImageSmall)];
//    image.backgroundColor = [UIColor redColor];
    image.image = [UIImage imageNamed:@"iconLogoCN"];
    image.contentMode = UIViewContentModeLeft;
    [headNaviView addSubview:image];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - MarginX - HeightImageSmall*Ratio, (heightHeaderView - HeightImageSmall)/2*Ratio+HeightStateBar, HeightImageSmall*Ratio, HeightImageSmall*Ratio)];
    [button setImage:[UIImage imageNamed:@"iconSetting"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pushToSetting) forControlEvents:UIControlEventTouchUpInside];
    [headNaviView addSubview:button];
    
    [self.view addSubview:headNaviView];
    
    CGRect frame = [self dealGetFrameWithX:0 Y:heightHeaderView*Ratio+HeightStateBar  Width:SCREEN_WIDTH Height:SCREEN_HEIGHT - heightHeaderView*Ratio - MarginY];
    UITableView *tableView = [self dealSetTableViewWithCellHeight:cellHeight frame:frame bgColor:ColorClear delegate:self];
    [tableView registerNib:[UINib nibWithNibName:@"MainTypeOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellOne"];
    [tableView registerNib:[UINib nibWithNibName:@"MainTypeTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellTwo"];
    _tableView = tableView;
    [self.view addSubview:tableView];
}

- (void)loadData{
    if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
        [self showWIFIAlert];
        return;
    }
    WeakSelf;
    NSString *url = [NSString stringWithFormat:@"%@", MIFI_STATUS1_PATH];
    [NIHttpUtil get:url params:nil success:^(AFHTTPRequestOperation *operation, id responseObj) {
        NILog(@"%@",operation.responseString);
        BOOL check = [self checkLoginWithOperationResponse:operation.responseString];
        if (check) {
            [self showNeedRelogin];
            return ;
        }
        NIStatus1Model *routerInfo = [NIStatus1Model status1WithResponseXmlString:operation.responseString];
        weakSelf.status1 = routerInfo;
        NSString *wlan = [routerInfo.wlan_security.ssid uniDecode];
        NSString *device = routerInfo.device_management.nr_connected_dev;
        NSString *message = routerInfo.message.sms_capacity_info.sms_unread_long_num;
        weakSelf.dataArray = (NSMutableArray *)@[@"",wlan,device,message];
        [weakSelf.tableView reloadData];
//        [self loadNetData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NILog(@"operation = %@, error = %@",operation.responseString, error);
    }];
}

- (void)loadNetData{
    if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
        [self showWIFIAlert];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@", MIFI_STATISTICS_GET_PATH];
    [NIHttpUtil get:url params:nil success:^(AFHTTPRequestOperation *operation, id responseObj) {
        BOOL check = [self checkLoginWithOperationResponse:operation.responseString];
        if (check) {
            [self showNeedRelogin];
            return ;
        }
        Statistics *statistics = [Statistics initWithResponseXmlString:operation.responseString isRGWStartXml:YES];
        [self reloadTableWithWanInfo:statistics];
        [self mbDismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self mbShowToast:error.localizedDescription];
        [self mbDismiss];
    }];
}

/**
 根据返回数据重新刷新表单
 
 @param statistics 数据
 */
- (void)reloadTableWithWanInfo:(Statistics *)statistics{
    WanStatistics *wanStatistics = statistics.wanStatistics;
    NSInteger statMangMethod = [wanStatistics.statMangMethod integerValue];
    NSString *total = @"0.0KB";
    NSString *used = @"0.0KB";
    CGFloat progress = 0;
    if (statMangMethod == NWStatisticsTimeForbidInt) {
        _headerView.imageFlow.hidden = NO;
        _headerView.labelFlowNumber.text = @"设置流量";
    }else {
        if (statMangMethod == NWStatisticsTimeMonthInt){
            total = [NIGMBManagerTool getNetNumberWithDBString:wanStatistics.totalAvaliableMonth];
            used = [NIGMBManagerTool getNetNumberWithDBString:wanStatistics.totalUsedMonth];
            progress = [wanStatistics.totalUsedMonth floatValue]/[wanStatistics.totalAvaliableMonth floatValue];
        }else if (statMangMethod == NWStatisticsTimeUnlimitedInt){
            total = [NIGMBManagerTool getNetNumberWithDBString:wanStatistics.totalAvaliableUnlimit];
            used = [NIGMBManagerTool getNetNumberWithDBString:wanStatistics.totalUsedUnlimit];
            progress = [wanStatistics.totalUsedUnlimit floatValue]/[wanStatistics.totalAvaliableUnlimit floatValue];
        }
        _headerView.labelFlow.attributedText = [self dealTrailText:[NSString stringWithFormat:@"%@",used] WithLength:2 MainFont:FontSfWithSize(70) mainColor:ColorWhite AssFont:FontSfWithSize(20) assColor:WhiteAlpha(0.5)];
        _headerView.labelFlowNumber.attributedText = [self dealTrailText:[NSString stringWithFormat:@"%@",total] WithLength:2 MainFont:FontSfWithSize(35) mainColor:ColorWhite AssFont:FontSfWithSize(20) assColor:WhiteAlpha(0.5)];
        _headerView.progressFlow.progress = progress;
        _headerView.imageFlow.hidden = YES;
    }
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MainHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"MainHeaderView" owner:self options:nil] lastObject];
    headerView.backgroundColor = ColorClear;
    
    headerView.labelFlow.attributedText = [self dealTrailText:@"0.0GB" WithLength:2 MainFont:FontSfWithSize(70) mainColor:ColorWhite AssFont:FontSfWithSize(20) assColor:WhiteAlpha(0.5)];
    headerView.progressFlow.progress = 100;
    headerView.labelBattery.attributedText = [self dealTrailText:@"100%" WithLength:1 MainFont:FontSfWithSize(70) mainColor:ColorWhite AssFont:FontSfWithSize(20) assColor:WhiteAlpha(0.5)];
    headerView.progressBattery.progress = 100;
    headerView.labelTotalFlow.text = @"总流量";
    headerView.labelTotalBattery.text = @"总电量";
    headerView.labelFlowTitle.text = @"路由器已用电量";
    _headerView = headerView;
    
    if (_status1) {
        NSString *battery =_status1.wan.Battery_voltage;
        NSString *charging = [_status1.wan.Battery_charging isEqualToString:@"0"]?@"路由器剩余电量":@"正在充电";
        _headerView.labelBatteryTitle.text = charging;
        _headerView.labelBattery.attributedText = [self dealTrailText:[NSString stringWithFormat:@"%@%%",battery] WithLength:1 MainFont:FontSfWithSize(70) mainColor:ColorWhite AssFont:FontSfWithSize(20) assColor:WhiteAlpha(0.5)];
        _headerView.progressBattery.progress = battery.floatValue;

    }
    
    [headerView.buttonSettingFlow addEvent:^(UIButton *btn){
//        UIView *subView = [[UIView alloc] initWithFrame:[self dealGetFrameWithX:0 Y:SCREEN_HEIGHT-50 Width:SCREEN_WIDTH Height:50]];
//        ActionView *action = [[ActionView alloc] initWithSubView:subView];
//        [self.view addSubview:action];
//        [action show];
        PackageViewController *package = [PackageViewController new];
        package.title = @"套餐设置";
        [self.navigationController pushViewController:package animated:YES];
        
    }];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SectionHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < 2) {
        MainTypeOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellOne"];
        if (indexPath.row == 0) {
            cell.imageIcon.image = [UIImage imageNamed:@"listIconSignal"];
            cell.labelTitle.hidden = NO;
            cell.labelDetail.hidden = NO;
            cell.labelDeviceName.hidden = YES;
            
        } else {
            cell.imageIcon.image = [UIImage imageNamed:@"listIconMF"];
            cell.labelTitle.hidden = YES;
            cell.labelDetail.hidden = YES;
            cell.labelDeviceName.hidden = NO;
            cell.labelDeviceName.text = _dataArray[indexPath.row];
        }
        cell.backgroundColor = ColorClear;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        MainTypeTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellTwo"];
        if (indexPath.row == 2) {
            cell.imageIcon.image = [UIImage imageNamed:@"listIconDevice"];
            cell.labelTitle.text = @"台";
            cell.labelDetail.text = @"连接设备";
            cell.labelNumber.text = _dataArray[indexPath.row];
        }else{
            cell.imageIcon.image = [UIImage imageNamed:@"listIconMessage"];
            cell.labelTitle.text =@"条";
            cell.labelDetail.text = @"未读信息";
            cell.labelNumber.text = _dataArray[indexPath.row];
            
        }
        cell.backgroundColor = ColorClear;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(_status1){
        return 1;
    }else{
        return 0;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        
    }else if (indexPath.row == 1){
        
    }else if (indexPath.row == 2){
        ConnectDevicesViewController *device = [ConnectDevicesViewController new];
        device.title = @"连接设备";
        [self.navigationController pushViewController:device animated:YES];
    }else{
        MessageViewController *message = [MessageViewController new];
        message.title = @"未读短信";
        [self.navigationController pushViewController:message animated:YES];
    }
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - 跳转处理
- (void)pushToSetting{
    SettingViewController *setting = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:setting animated:YES];
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
