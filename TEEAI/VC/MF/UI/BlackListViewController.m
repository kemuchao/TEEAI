//
//  BlackListViewController.m
//  MifiManager
//
//  Created by notion on 2018/4/23.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "BlackListViewController.h"
#import "ContentDetailImageTableViewCell.h"
#import "DeviceDetailViewController.h"
#import "BlackListViewController.h"

#import "DeviceManagement.h"
#import "DeviceInfo.h"
#import "CPEInterfaceMain.h"
#define HeightHeadView SCREEN_HEIGHT*0.4
@interface BlackListViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isShowBlack;
@property (nonatomic, strong) NSMutableArray *statusHelpArray;
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation BlackListViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_tableView) {
        [self loadData];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = ColorWhite;
    self.title = @"黑名单";
   
//    [self setRightBarWithTitle:Localized(@"blackList")];
    [self loadMainView];
    [self initAddBlackButton];
    [self loadData];
}

- (void)loadMainView{
    CGFloat bottomHeight = HeightCellLarge;
    CGRect frame = [self dealGetFrameWithX:0 Y:HeightNanvi Width:SCREEN_WIDTH Height:SCREEN_HEIGHT- bottomHeight-HeightNanvi];
    UITableView *tableView = [self dealSetTableViewWithCellHeight:HeightCell *Ratio frame:frame bgColor:ColorClear delegate:self];
    [tableView registerNib:[UINib nibWithNibName:@"ContentDetailImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView = tableView;
    [self.view addSubview:tableView];
    
    UIView *bottom = [[UIView alloc] initWithFrame:[self dealGetFrameWithX:0 Y:SCREEN_HEIGHT-bottomHeight Width:SCREEN_WIDTH Height:bottomHeight]];
    [bottom setBackgroundColor:ColorClear];
    [self.view addSubview:bottom];
    _bottomView = bottom;
}

/**
 添加黑名单按钮
 */
- (void)initAddBlackButton{
//    [_bottomView clear];
//    WeakSelf;
//    CGFloat bottomHeight = HeightCellLarge;
//    CGFloat labelWidth = [self getText:@"移除黑名单" WidthWithHeight:HeightLabel andFont:FontLarge]+50+3*MarginX;
//    CGFloat originX = (SCREEN_WIDTH - labelWidth)/2;
//    CGFloat originY = bottomHeight - 38/3-HeightButton;
//
//    CGRect buttonFrame = [self dealGetFrameWithX:originX Y:originY Width:labelWidth Height:HeightButton];
//    UIButton *button = [self dealSetButtonWithTitle:@"移除黑名单" color:[UIColor colorWithHexString:ColorBlueDeep] bgColor:ColorWhite font:FontLarge frame:buttonFrame image:nil];
//    //[UIImage imageNamed:@"iconBlackList"]
//    [self initButton:button];
//    [button setLayerWithBorderWidth:BorderWidth BorderColor:ColorWhite CornerRadius:BorderCircle];
//    [button addEvent:^(UIButton *btn){
//        [weakSelf initData];
//        [weakSelf initManulView];
//        weakSelf.isShowBlack = !weakSelf.isShowBlack;
//        [weakSelf.tableView reloadData];
//    }];
//    [_bottomView addSubview:button];
}

/**
 设置取消，确定按钮
 */
- (void)initManulView{
//    [_bottomView clear];
//    CGFloat bottomHeight = HeightCellLarge;
//    CGFloat originY = bottomHeight - 38/3-HeightButton;
//    CGFloat originX = 38/3;
//    CGFloat widthButton = (SCREEN_WIDTH - originX*3)/2;
//    CGFloat originX2 = widthButton+2*originX;
//    UIButton *buttonCancel = [self dealSetButtonWithTitle:@"取消" color:[UIColor colorWithHexString:ColorBlueNormal] bgColor:ColorWhite font:FontRegular frame:[self dealGetFrameWithX:originX Y:originY Width:widthButton Height:HeightButton] image:nil];
//    [buttonCancel addEvent:^(UIButton *btn){
//        [self initAddBlackButton];
//    }];
//    [buttonCancel setLayerWithBorderWidth:0 BorderColor:ColorWhite CornerRadius:BorderCircle];
//    [_bottomView addSubview:buttonCancel];
//
//    UIButton *buttonConfirm =  [self dealSetButtonWithTitle:@"确定" color:[UIColor colorWithHexString:ColorBlueDeep] bgColor:ColorWhite font:FontRegular frame:[self dealGetFrameWithX:originX2 Y:originY Width:widthButton Height:HeightButton] image:nil];
//    [buttonConfirm addEvent:^(UIButton *btn){
//        [self uploadBlackList];
//    }];
//    [buttonConfirm setLayerWithBorderWidth:0 BorderColor:ColorWhite CornerRadius:BorderCircle];
//    [_bottomView addSubview:buttonConfirm];
    
}
-(void)initButton:(UIButton*)btn{
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0 ,MarginX/2, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0, MarginX/2)];//图片距离右边框距离减少图片的宽度，其它不边
}

/**
 初始化数据，对应的符号来判断是否加入黑名单
 */
- (void)initData{
    _statusHelpArray = [[NSMutableArray alloc] initWithCapacity:_dataArray.count];
    for (int i = 0; i < _dataArray.count; i++) {
        NSNumber *object = [NSNumber numberWithBool:false];
        [_statusHelpArray addObject:object];
    }
}
#pragma mark - 数据加载
- (void)loadData{
    if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
        [self showWIFIAlert];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
        [self loadCPEData];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@", MIFI_GET_DEVICE_MANAGEMENT];
    [NIHttpUtil get:url params:nil success:^(AFHTTPRequestOperation *operation, id responseObj) {
        [self mbDismiss];
        [NIUerInfoAndCommonSave saveValue:[NSNumber numberWithBool:YES] key:DeviceRefresh];
        NILog(@"%@", operation.responseString);
        BOOL check = [self checkLoginWithOperationResponse:operation.responseString];
        if (check) {
            [self showNeedRelogin];
            return ;
        }
        DeviceManagement *management = [DeviceManagement initWithResponseXmlString:operation.responseString isRGWStartXml:YES];
        [self dealDeviceList:management.deviceArray];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self mbDismiss];
        [self mbShowToast:error.localizedDescription];
        
    }];
}
/**
 CPE加载当前连接设备
 */
- (void)loadCPEData{
    [CPEInterfaceMain getAllDevicesSuccess:^(NSArray *client){
        [self mbDismiss];
        [self dealDeviceList:client];
        [self initAddBlackButton];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotifyRefreshName object:nil];
    } failure:^(NSError *error){
        [self mbDismiss];
        [self mbShowToast:error.localizedDescription];
    }errorCause:^(NSString *errorCause){
        [self mbDismiss];
        if ([errorCause isEqualToString:CPEResultNeedLogin]) {
            [self showNeedRelogin];
        }
    }];
}
/**
 移除黑名单数据
 */
- (void)uploadBlackList:(NSArray *)macArray{
    
    NSMutableString *request = [[NSMutableString alloc] initWithString:@"<?xml version=\"1.0\" encoding=\"US-ASCII\"?> <RGW><device_management><device_control><action>3</action><mac>"];
    for (int i=0; i<macArray.count; i++) {
        [request appendString:macArray[i]];
        if (i != macArray.count - 1) {
            [request appendString:@","];
        }
    }
    [request appendString:@"</mac></device_control></device_management></RGW>"];
    NSString *url = [NSString stringWithFormat:@"%@", MIFI_SET_DEVICE_MANAGEMENT];
    [self mbShowLoadingText:Localized(@"saving")];
    WeakSelf;
    [NIHttpUtil post:url params:nil xmlString:request success:^(AFHTTPRequestOperation *operation, id responseObj) {
        [self mbDismiss];
        NILog(@"%@", operation.responseString);
        BOOL check = [self checkLoginWithOperationResponse:operation.responseString];
        if (check) {
            [self showNeedRelogin];
            return ;
        }
        DeviceManagement *management = [DeviceManagement initWithResponseXmlString:operation.responseString isRGWStartXml:YES];
        [weakSelf dealDeviceList:management.deviceArray];
        [weakSelf initAddBlackButton];
        //回调刷新上级页面
        if(weakSelf.block){
            weakSelf.block();
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NotifyRefreshName object:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf mbDismiss];
        [weakSelf mbShowToast:error.localizedDescription];
        
    }];
}
/**
 CPE 提交黑名单
 
 @param macArray mac 数组
 */
- (void)uploadBlockDeviceCPEWithMacArray:(NSArray *)macArray{
    NSMutableString *request = [[NSMutableString alloc] initWithString:@"<statistics><clients_mac>"];
    for (int i=0; i<macArray.count; i++) {
        [request appendString:macArray[i]];
        if (i != macArray.count - 1) {
            [request appendString:@","];
        }
    }
    [request appendString:@"</clients_mac></statistics>"];
    NSString *requestXML = [CPERequestXML getXMLWithPath:@"statistics" method:@"unblock_clients" addXML:request];
    WeakSelf;
    [CPEInterfaceMain uploadCommonWithRequestXML:requestXML Success:^(CPEResultCommonData *status){
        [self mbDismiss];
        if ([status.status isEqualToString:@"OK"]) {
            [self loadData];
        }
        //回调刷新上级页面
        if(weakSelf.block){
            weakSelf.block();
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NotifyRefreshName object:nil];
    } failure:^(NSError *error){
        [self mbDismiss];
        [self mbShowToast:error.localizedDescription];
    }errorCause:^(NSString *errorCause){
        [self mbDismiss];
        if ([errorCause isEqualToString:CPEResultNeedLogin]) {
            [self showNeedRelogin];
        }
    }];
}
/**
 处理连接设备信息
 
 @param deviceArray 设备
 */
- (void)dealDeviceList:(NSArray *)deviceArray{
    _dataArray = [NSMutableArray array];
    for (int i=0; i<deviceArray.count; i++) {
        DeviceInfo *deviceInfo = deviceArray[i];
        if ([deviceInfo.status isEqualToString:@"2"]) {
            [_dataArray addObject:deviceInfo];
        }
    }
    [self initData];
    [_tableView reloadData];
}

#pragma mark - 列表处理
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        DeviceInfo *deviceInfo =  _dataArray[indexPath.row];
        NSArray *array = @[deviceInfo.mac];
        [_dataArray removeObjectAtIndex:indexPath.row];
        [self uploadBlackList:array];
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"移除黑名单";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ContentDetailImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.iconImage.image = [UIImage imageNamed:@"listDevice"];
    DeviceInfo *cellInfo = [_dataArray objectAtIndex:indexPath.row];
    cell.imageMe.hidden = YES;
   
    cell.labelTitle.text = cellInfo.name;
    cell.labelDetail.text = cellInfo.connectTimeAt;
    cell.isNormal = NO;
    if ([cellInfo.ipAddress isEqualToString:[NIUerInfoAndCommonSave getValueFromKey:DeviceIP]]) {
        
        cell.imageMe.hidden = NO;
    }else if ([cellInfo.connType isEqualToString:@"USB"]){
        
    }else{
        
    }
    
    if(_isShowBlack == YES){
        
    }else{
      
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HeightCell*Ratio;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    DeviceInfo *dict = [_dataArray objectAtIndex:indexPath.row];
    if(_isShowBlack){
        ContentDetailImageTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        NSString *ip = [NIUerInfoAndCommonSave getValueFromKey:DeviceIP];
        if ([ip isEqualToString:dict.ipAddress]) {
            //自身
            return;
        }else if ([dict.connType isEqualToString:@"USB"]){
            //通过USB连接
            return;
        }
        BOOL isBlack = [[_statusHelpArray objectAtIndex:indexPath.row] boolValue];
//        cell.imageStatus.highlighted = !isBlack;
        [_statusHelpArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:!isBlack]];
    }else{
        DeviceDetailViewController *device = [DeviceDetailViewController new];
        device.deviceInfo = dict;
        [self.navigationController pushViewController:device animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}
- (void)topMoreClick{
    BlackListViewController *blackList = [BlackListViewController new];
    [self.navigationController pushViewController:blackList animated:YES];
}

#pragma mark - 重新
- (void)needToRefresh{
    [self loadData];
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
