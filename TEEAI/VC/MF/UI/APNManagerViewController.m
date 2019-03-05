//
//  APNManagerViewController.m
//  MifiManager
//
//  Created by notion on 2018/4/25.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "APNManagerViewController.h"
#import "SwitchTypeTwoTableViewCell.h"
#import "ContentTableViewCell.h"

#import "NISelectModel.h"
#import "APNDefaultViewController.h"

#import "NIWanModel.h"
#import "CPEInterfaceMain.h"
@interface APNManagerViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NIWanModel *wanModel;
@property (nonatomic, strong) CPEWanConfig *wanConfig;
@end

@implementation APNManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    [self ininData];
    [self loadWanInfo];
//    [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(loadWanInfo) userInfo:nil repeats:YES];
    // Do any additional setup after loading the view.
}
- (void)loadMainView{
    
    CGRect frame = [self dealGetFrameWithX:0 Y:HeightNanvi Width:SCREEN_WIDTH Height:SCREEN_HEIGHT - HeightNanvi];
    UITableView *tableView =  [self dealSetTableViewWithCellHeight:HeightCell *Ratio frame:frame bgColor:ColorClear delegate:self];
    [tableView registerNib:[UINib nibWithNibName:@"SwitchTypeTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"SwitchTypeTwoTableViewCell"];
    [tableView registerNib:[UINib nibWithNibName:@"ContentTableViewCell" bundle:nil] forCellReuseIdentifier:@"ContentTableViewCell"];
    _tableView = tableView;
    [self.view addSubview:tableView];
    
}
#pragma mark - CPE
- (void)loadCPEWanInfo{
    WeakSelf;
    [CPEInterfaceMain getWanAPNConfigSuccess:^(CPEWanConfig *wanConfig){
        [weakSelf mbDismiss];
        weakSelf.wanConfig = wanConfig;
        if ([wanConfig.activedProfile isEqualToString:@"default"]) {
            [weakSelf reloadDataWithOpen:YES];
        }else{
            [weakSelf reloadDataWithOpen:NO];
        }
    } failure:^(NSError *error){
        [self mbDismiss];
        [self mbShowToast:error.localizedDescription];
    } errorCause:^(NSString *errorCause){
        [self mbDismiss];
        if ([errorCause isEqualToString:CPEResultNeedLogin]) {
            [self showNeedRelogin];
        }
    }];
}

/**
 设置CPE APN情况
 若autoAPN 则调用接口
 若非，则直接编辑查看当前第一个非auto APN

 @param autoAPN 是否为自动APN
 */
- (void)loadCEPWithAuto:(BOOL)autoAPN{
    WeakSelf;
    if (autoAPN) {
        NSMutableString *request = [[NSMutableString alloc] initWithString:@"<wan>"];
        [request appendString:@"<profile>"];
        [request appendFormat:@"<profile_name>default</profile_name>"];
        [request appendFormat:@"<action>3</action>"];
        [request appendString:@"</profile>"];
        [request appendString:@"</wan>"];
        NSMutableString *requestXML = [CPERequestXML getXMLWithPath:@"cm" method:@"configs_handler" addXML:request];
        [CPEInterfaceMain uploadCommonWithRequestXML:requestXML Success:^(CPEResultCommonData *resultData){
            [self mbDismiss];
            [weakSelf ininData];
            [weakSelf loadCPEWanInfo];
        } failure:^(NSError *error){
            [self mbDismiss];
            [self mbShowToast:error.localizedDescription];
        } errorCause:^(NSString *errorCause){
            [self mbDismiss];
            if ([errorCause isEqualToString:CPEResultNeedLogin]) {
                [self showNeedRelogin];
            }
        }];
    }else{
        APNDefaultViewController *apnDefault = [APNDefaultViewController new];
        apnDefault.title = Localized(@"APNDefault");
        if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
            if ([_wanConfig.activedProfile isEqualToString:@"default"]) {
                if (_wanConfig.apnArray.count > 1) {
                    apnDefault.apnModel = [_wanConfig.apnArray objectAtIndex:1];
                }
            }else{
                apnDefault.apnModel = _wanConfig.activeAPN;
            }
            
        }
        [self.navigationController pushViewController:apnDefault animated:YES];
    }
}
/**
 加载网络信息
 */
- (void)loadWanInfo{
    if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
        [self showWIFIAlert];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
        [self loadCPEWanInfo];
        return;
    }
    WeakSelf;
    NSString *url = [NSString stringWithFormat:@"%@", MIFI_WAN_GET_PATH];
    [NIHttpUtil get:url params:nil success:^(AFHTTPRequestOperation *operation, id responseObj) {
        [weakSelf mbDismiss];
        BOOL check = [weakSelf checkLoginWithOperationResponse:operation.responseString];
        if (check) {
            [weakSelf showNeedRelogin];
            return ;
        }
        NIWanModel *wan = [NIWanModel wanWithResponseXmlString:operation.responseString isRGWStartXml:YES];
        weakSelf.wanModel = wan;
        [weakSelf reloadDataWithOpen:[wan.auto_apn boolValue]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self mbDismiss];
        [self mbShowToast:error.localizedDescription];
    }];
}

/**
 初始化数据
 */
- (void)ininData{
    _dataArray = [NSMutableArray array];
    [_dataArray addObject:[NISelectModel setTitle:Localized(@"APNAutoAdaptive") value:[NSNumber numberWithBool:YES]]];
    [_tableView reloadData];
}

/**
 重载数据

 @param isOpen 是否AUTO
 */
- (void)reloadDataWithOpen:(BOOL)isOpen{
    _dataArray = [NSMutableArray array];
    [_dataArray addObject:[NISelectModel setTitle:Localized(@"APNAutoAdaptive") value:[NSNumber numberWithBool:isOpen]]];
    
    if (isOpen) {
        
    }else{
        //Localized(@"APNDefault")
        [_dataArray addObject:[NISelectModel setTitle:@"默认APN" value:nil]];
    }
    [_tableView reloadData];
}
/**
 切换是否自动匹配
 @param sender 切换按钮
 */
- (void)dealSwitch:(UISwitch *)sender{
    NISelectModel *autoModel = _dataArray[0];
    BOOL isOpen = [autoModel.value boolValue];
    if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
        [self loadCEPWithAuto:!isOpen];
    }else{
        [self loadDataWithIsOpen:!isOpen];
    }
}

- (void)loadDataWithIsOpen:(BOOL)isOpen{
    if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
        [self showWIFIAlert];
        return;
    }
    if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
        [self loadCEPWithAuto:isOpen];
        return;
    }
    NSString *autoAPN = isOpen?@"1":@"0";
    NSMutableString *request = [NSMutableString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"US-ASCII\"?> <RGW><wan><auto_apn>"];
    [request appendFormat:@"%@",autoAPN];
    [request appendFormat:@"</auto_apn><auto_apn_action>1</auto_apn_action></wan></RGW>"];
    NILog(@"requesetXml = %@", request);
    NSString *url = [NSString stringWithFormat:@"%@", MIFI_WAN_SET_PATH];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    WeakSelf;
    [NIHttpUtil post:url params:nil xmlString:request success:^(AFHTTPRequestOperation *operation, id responseObj) {
        [weakSelf mbDismiss];
        BOOL check = [weakSelf checkLoginWithOperationResponse:operation.responseString];
        if (check) {
            [weakSelf showNeedRelogin];
            return ;
        }
        weakSelf.dataArray = [NSMutableArray array];
        [self reloadDataWithOpen:isOpen];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self mbDismiss];
        [self mbShowToast:error.localizedDescription];
    }];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NISelectModel *cellData = _dataArray[indexPath.row];
    if (indexPath.row == 0) {
        SwitchTypeTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchTypeTwoTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *title = cellData.title;
        cell.labelTitle.text = title;
        [cell.labelTitle setColor:[UIColor colorWithHexString:ColorBlueDeep] font:FontRegular];
        BOOL isON = [cellData.value boolValue];
        NSString *detail = isON == YES?Localized(@"APNAutoAdaptiveOpen"):Localized(@"APNAutoAdaptiveClose");
        cell.labelDetail.text = detail;
        [cell.Switch setOn:isON];
        [cell.Switch addTarget:self action:@selector(dealSwitch:) forControlEvents:UIControlEventTouchUpInside];
        [cell.labelDetail setColor:[UIColor colorWithHexString:ColorBlueNormal] font:FontDetail];
        return cell;
    } else {
        ContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContentTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.labelTitle.text = cellData.title;
        [cell.labelTitle setColor:[UIColor colorWithHexString:ColorBlueDeep] font:FontRegular];
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}
#pragma mark - 选择跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        APNDefaultViewController *apnDefault = [APNDefaultViewController new];
        apnDefault.title = Localized(@"APNDefault");
        if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
            apnDefault.apnModel = _wanConfig.activeAPN;
        }
        [self.navigationController pushViewController:apnDefault animated:YES];
    }else{
        [self dealSwitch:nil];
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
