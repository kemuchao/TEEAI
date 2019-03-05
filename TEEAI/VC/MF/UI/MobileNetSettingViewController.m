//
//  MobileNetSettingViewController.m
//  MifiManager
//
//  Created by notion on 2018/3/20.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "MobileNetSettingViewController.h"
#import "MoreViewController.h"
#import "DetailTableViewCell.h"
#import "SwitchTableViewCell.h"

#import "PackageViewController.h"

#import "NISelectView.h"
#import "ActionView.h"

//数据Model
#import "NIWanModel.h"
#import "Statistics.h"
#import "NIGMBManagerTool.h"
#import "NINodeModel.h"

#import "CPEInterfaceMain.h"
@interface MobileNetSettingViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NIWanModel *wan;
@end

@implementation MobileNetSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self initData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData) name:NotifyPINChange object:nil];
    // Do any additional setup after loading the view.
}

/**
 加载数据
 */
- (void)initData{
    [self loadData];
    if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
        [self loadCPEPackage];
        [self loadCPEWanDB];
        [self loadCPEWitch];
    }else{
        [self loadStatisticsDB];
        [self loadWanDB];
    }
}


- (void)loadData{
    NSMutableArray *sectionOne = [NSMutableArray new];
    [sectionOne addObjectsFromArray: @[
                                       [NISelectModel setTitle:@"套餐设置" value:nil],
                                       [NISelectModel setTitle:@"首选方式" value:nil],
                                       [NISelectModel setTitle:@"网络数据开关" value:nil],
                                       [NISelectModel setTitle:@"禁止数据漫游" value:nil]
                                       ]];
    
    NSMutableArray *sectionTwo =   [NSMutableArray new];
    [sectionTwo addObjectsFromArray:@[[NISelectModel setTitle:@"更多" value:nil]]];
    _dataArray = [NSMutableArray arrayWithArray:@[sectionOne,sectionTwo]];
    [_tableView reloadData];
}

/**
 更新原始数据

 @param wan 获取数据
 */
- (void)reloadDataWithWan:(NIWanModel *)wan{
    // 首选方式
    NICellularModel *cellular = wan.cellular;
    NISelectModel *model = _dataArray[0][1];
    model.value = [self transforFromNWModeToStringWithMode:cellular.NW_mode];
    [self reloadAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] withModel:model];
    
    // z禁止数据漫游
    NISelectModel *dial = _dataArray[0][3];
    dial.value = [wan.Roaming_disable_auto_dial isEqualToString:@"0"] ?[NSNumber numberWithBool:false]:[NSNumber numberWithBool:YES];
    [self reloadAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] withModel:dial];
    [_tableView reloadData];
}
/**
 重置列表中显示数据

 @param indexPath 下标
 @param model 数据
 */
- (void)reloadAtIndexPath:(NSIndexPath *)indexPath withModel:(NISelectModel *)model{
    NSMutableArray *sectionDB = (NSMutableArray *)[_dataArray objectAtIndex:indexPath.section];
    [sectionDB replaceObjectAtIndex:indexPath.row withObject:model];
    [_dataArray replaceObjectAtIndex:indexPath.section withObject:sectionDB];
    
}
#pragma mark - 数据请求
#pragma mark - 1802
/**
 获取套餐数据
 */
- (void)loadStatisticsDB{
    if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
        [self showWIFIAlert];
        return;
    }
    WeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@", MIFI_STATISTICS_GET_PATH];
    [NIHttpUtil get:url params:nil success:^(AFHTTPRequestOperation *operation, id responseObj) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        BOOL check = [weakSelf checkLoginWithOperationResponse:operation.responseString];
        if (check) {
            [weakSelf showNeedRelogin];
            return ;
        }
        Statistics *statistics = [Statistics initWithResponseXmlString:operation.responseString isRGWStartXml:YES];
        WanStatistics *wanStatistics = statistics.wanStatistics;
        NSString *mode = [NIGMBManagerTool getTimeLimitedWithTimeMode:wanStatistics.statMangMethod];
        if (wanStatistics.statMangMethod.intValue == NWStatisticsTimeForbidInt) {
            
        }else if (wanStatistics.statMangMethod.intValue == NWStatisticsTimeMonthInt){
            NSString *total = [NIGMBManagerTool getNetNumberWithDBString:wanStatistics.totalAvaliableMonth];
            mode = [NSString stringWithFormat:@"%@ %@",mode,total];
        }else if (wanStatistics.statMangMethod.intValue == NWStatisticsTimeUnlimitedInt){
            NSString *total = [NIGMBManagerTool getNetNumberWithDBString:wanStatistics.totalAvaliableUnlimit];
            mode = [NSString stringWithFormat:@"%@ %@",mode,total];
        }
        NISelectModel *packageMode = weakSelf.dataArray[0][0];
        packageMode.value = mode;
        [weakSelf reloadAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] withModel:packageMode];
        [weakSelf.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [weakSelf mbShowToast:error.localizedDescription];
    }];
}

/**
 获取移动网络数据
 */
- (void)loadWanDB{
    if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
        [self showWIFIAlert];
        return;
    }
    WeakSelf;
    NSString *url = [NSString stringWithFormat:@"%@", MIFI_WAN_GET_PATH];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NIHttpUtil get:url params:nil success:^(AFHTTPRequestOperation *operation, id responseObj) {
        NSString *responseXML = operation.responseString;
        BOOL check = [weakSelf checkLoginWithOperationResponse:responseXML];
        if (check) {
            [weakSelf showNeedRelogin];
            return ;
        }
        NIWanModel *wan = [NIWanModel wanWithResponseXmlString:responseXML isRGWStartXml:YES];
        [weakSelf reloadDataWithWan:wan];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [weakSelf mbShowToast:error.localizedDescription];
    }];
}
#pragma mark - CPE
/**
 加载当前流量设置
 */
- (void)loadCPEPackage{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    WeakSelf;
    [CPEInterfaceMain getWanStatisticsSuccess:^(CPEStatisticsStatSetting *statisticsSetting){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSString *package = [[NSString alloc] init];
        CPEBasicMon *monData = statisticsSetting.basicMon;
        if ([monData.enable isEqualToString:@"1"]) {
            NSString *total = [NIGMBManagerTool getNetNumberWithDBString:monData.avlData];
            package = [NSString stringWithFormat:@"%@ %@",NWStatisticsTimeMonth,total];
            
        }else{
            package = NWStatisticsTimeUnlimited;
        }
        NISelectModel *packageMode = weakSelf.dataArray[0][0];
        packageMode.value = package;
        [self reloadAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] withModel:packageMode];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [weakSelf mbShowToast:error.localizedDescription];
    }errorCause:^(NSString *errorCause){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([errorCause isEqualToString:CPEResultNeedLogin]) {
            [weakSelf showNeedRelogin];
        }
    }];
}

/**
 加载当前网络设置
 */
- (void)loadCPEWanDB{
    WeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CPEInterfaceMain getNetModeSuccess:^(CPENetMode *netMode){
        int netInt = [netMode.nwMode intValue];
        NSString *netName = [NSString new];
        if (netInt == 2) {
            netName = NWMode4G;
        }else if (netInt == 3){
            netName = NWMode4G3G;
        }else if (netInt == 5){
            netName = NWMode3G;
        }
        NISelectModel *packageMode = weakSelf.dataArray[1][0];
        packageMode.value = netName;
        [weakSelf reloadAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] withModel:packageMode];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [weakSelf mbShowToast:error.localizedDescription];
    }errorCause:^(NSString *errorCause){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([errorCause isEqualToString:CPEResultNeedLogin]) {
            [weakSelf showNeedRelogin];
        }
    }];
}

/**
 加载是否支持漫游
 */
- (void)loadCPEWitch{
    WeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CPEInterfaceMain getWanSwitchSuccess:^(CPEWanSwitch *wanSwitch){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NISelectModel *dial = weakSelf.dataArray[0][3];
        dial.value = [wanSwitch.wanSwitch isEqualToString:@"0"] ?[NSNumber numberWithBool:false]:[NSNumber numberWithBool:YES];
        [weakSelf reloadAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] withModel:dial];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [weakSelf mbShowToast:error.localizedDescription];
    }errorCause:^(NSString *errorCause){
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([errorCause isEqualToString:CPEResultNeedLogin]) {
            [weakSelf showNeedRelogin];
        }
    }];
}

/**
 更新设置
 @param indexPath 单元格下标
 @param model 数据更新
 */
- (void)uploadAtIndexPath:(NSIndexPath *)indexPath withModel:(NISelectModel *)model{
    //更新网络选择
    WeakSelf;
    if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
        [self showWIFIAlert];
        return;
    }
    
    
    if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
        [self uploadCPEAtIndex:indexPath withModel:model];
        return;
    }
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSString *requestXml = @"";
    if (indexPath.section == 0 && indexPath.row == 1) {
        NSString *nwIntStr = [self transforFromModeStringToMode:model.value];
        [array addObject:[NINodeModel nodelModelWithNodeName:@"NW_mode" value:nwIntStr]];
        [array addObject:[NINodeModel nodelModelWithNodeName:@"prefer_mode" value:nwIntStr]];
        
        [array addObject:[NINodeModel nodelModelWithNodeName:@"NW_mode_action" value:@"1"]];
        [array addObject:[NINodeModel nodelModelWithNodeName:@"prefer_mode_action" value:@"1"]];
        requestXml = [NIRequestModelUtil XMLStringWithParentNodesName:@[@"wan",@"cellular"] subNodes:array];
        
    }else if (indexPath.section == 0 && indexPath.row == 3)
    {
        //更新是否漫游
        //0 为禁止漫游
        NSString *dial = [model.value boolValue] == YES ? @"1":@"0";
        [array addObject:[NINodeModel nodelModelWithNodeName:@"Roaming_disable_auto_dial" value:dial]];
        [array addObject:[NINodeModel nodelModelWithNodeName:@"Roaming_disable_auto_dial_action" value:@"1"]];
        requestXml = [NIRequestModelUtil XMLStringWithParentNodesName:@[@"wan"] subNodes:array];
        
    }
    NSString *url = [NSString stringWithFormat:@"%@", MIFI_WAN_SET_PATH];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NIHttpUtil post:url params:nil xmlString:requestXml success:^(AFHTTPRequestOperation *operation, id responseObj) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        BOOL check = [weakSelf checkLoginWithOperationResponse:operation.responseString];
        if (check) {
            [weakSelf showNeedRelogin];
            return ;
        }
        NIWanModel *wan = [NIWanModel wanWithResponseXmlString:operation.responseString isRGWStartXml:YES];
        [weakSelf reloadDataWithWan:wan];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotifyRefreshName object:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [weakSelf mbShowToast:error.localizedDescription];
    }];
    
}

- (void)uploadCPEAtIndex:(NSIndexPath *)indexPath withModel:(NISelectModel *)model{
    NSString *requestXML = [NSString new];
    WeakSelf;
    if (indexPath.row == 0 && indexPath.section == 1) {
        NSMutableString *wan = [[NSMutableString alloc] initWithString:@"<wan>"];
        NSString *mode = [self transformCPENetModeWithMode:model.value];
        [wan appendFormat:@"<nw_mode>%@</nw_mode>",[self transformCPENetModeWithMode:model.value]];
        if (mode.intValue == 3) {
            [wan appendFormat:@"<prefer_mode>3</prefer_mode>"];
        }else{
            [wan appendFormat:@"<prefer_mode></prefer_mode>"];
        }
        
        
        [wan appendString:@"</wan>"];
        requestXML = [CPERequestXML getXMLWithPath:@"util_wan" method:@"set_network_mode" addXML:wan];
    }else if (indexPath.section == 0 && indexPath.row == 4){
        //更新是否漫游
        //0 为禁止漫游
        NSString *dial = [model.value boolValue] == YES ? @"1":@"0";
        NSMutableString *wan = [[NSMutableString alloc] initWithString:@"<cm>"];
        [wan appendFormat:@"<switch>%@</switch>",dial];
        [wan appendString:@"</cm>"];
        requestXML = [CPERequestXML getXMLWithPath:@"cm" method:@"set_roaming_switch" addXML:wan];
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CPEInterfaceMain uploadCommonWithRequestXML:requestXML Success:^(CPEResultCommonData *status){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([status.status isEqualToString:CPEResultOK]) {
            [weakSelf reloadAtIndexPath:indexPath withModel:model];
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [weakSelf mbShowToast:error.localizedDescription];
    }errorCause:^(NSString *errorCause){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([errorCause isEqualToString:CPEResultNeedLogin]) {
            [self showNeedRelogin];
        }
    }];
}

-(void)updateShouXuan:(NSString *)title value:(id)value{
    NISelectModel *cellModel = [[NISelectModel alloc]init];
    cellModel.value = value;
    cellModel.title = title;
    if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
        [self uploadCPEAtIndex:[NSIndexPath indexPathForRow:1 inSection:0] withModel:cellModel];
    }else{
        [self uploadAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] withModel:cellModel];
    }
}
#pragma mark - 界面加载
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
    NISelectModel *model =  [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailTableViewCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.labelTitle.text = model.title;
                [cell.labelTitle setColor:[UIColor colorWithHexString:ColorBlueDeep] font:FontRegular];
                cell.labelDetail.text = model.value;
                [cell.labelDetail setColor:[UIColor colorWithHexString:ColorBlueNormal] font:FontNormal];
                return cell;
            }
            case 1:{
                DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailTableViewCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.labelTitle.text = model.title;
                [cell.labelTitle setColor:[UIColor colorWithHexString:ColorBlueDeep] font:FontRegular];
                cell.labelDetail.text = model.value;
                [cell.labelDetail setColor:[UIColor colorWithHexString:ColorBlueNormal] font:FontNormal];
                return cell;
            }
            case 2:{
                SwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchTableViewCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.labelTitle.text = model.title;
                [cell.labelTitle setColor:[UIColor colorWithHexString:ColorBlueDeep] font:FontRegular];
                cell.Switch.on = [model.value boolValue];
                [cell.Switch addTarget:self action:@selector(dealSwitch:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }
            case 3:{
                SwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchTableViewCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.labelTitle.text = model.title;
                [cell.labelTitle setColor:[UIColor colorWithHexString:ColorBlueDeep] font:FontRegular];
                cell.Switch.on = [model.value boolValue];
                [cell.Switch addTarget:self action:@selector(dealSwitch:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }
            default:{
                return [[DetailTableViewCell alloc]init];;
            }
        }
    } else {
        DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.labelTitle.text = model.title;
        [cell.labelTitle setColor:[UIColor colorWithHexString:ColorBlueDeep] font:FontRegular];
        cell.labelDetail.text = model.value?model.value:@"";
        [cell.labelDetail setColor:[UIColor colorWithHexString:ColorBlueNormal] font:FontNormal];
        return cell;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_dataArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_dataArray objectAtIndex:section] count];
}

#pragma mark - 选择
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    NISelectModel *title = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
             [self performSegueWithIdentifier:@"toPackageViewController" sender:self];
        }
        if (indexPath.row == 1) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"首选方式" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *cencel){
               
            }];
            UIAlertAction *confirm1 = [UIAlertAction actionWithTitle:@"4G/3G/2G" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [self updateShouXuan:@"首选模式" value:@"4G/3G/2G"];
            }];
            UIAlertAction *confirm2 = [UIAlertAction actionWithTitle:@"4G" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [self updateShouXuan:@"首选模式" value:@"4G"];
            }];
            UIAlertAction *confirm3 = [UIAlertAction actionWithTitle:@"4G/3G" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [self updateShouXuan:@"首选模式" value:@"4G/3G"];
            }];
            UIAlertAction *confirm4 = [UIAlertAction actionWithTitle:@"3G/2G" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [self updateShouXuan:@"首选模式" value:@"3G/2G"];
            }];
            UIAlertAction *confirm5 = [UIAlertAction actionWithTitle:@"3G" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [self updateShouXuan:@"首选模式" value:@"3G"];
            }];
            UIAlertAction *confirm6 = [UIAlertAction actionWithTitle:@"2G" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [self updateShouXuan:@"首选模式" value:@"2G"];
            }];
            [alert addAction:cancel];
            [alert addAction:confirm1];
            [alert addAction:confirm2];
            [alert addAction:confirm3];
            [alert addAction:confirm4];
            [alert addAction:confirm5];
            [alert addAction:confirm6];
            [self presentViewController:alert animated:YES completion:nil];
        }
        if (indexPath.row == 3) {
            SwitchTableViewCell *cell = (SwitchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SwitchTableViewCell" forIndexPath:indexPath];
            UISwitch *s = [cell viewWithTag:100];
            [self dealSwitch:s];
        }
    }
    if (indexPath.section == 1) {
         [self performSegueWithIdentifier:@"toMoreViewController" sender:self];
    }
}



/**
 转化 1、2、3、4、5、6 为网络名称

 @param nwMode 网络代号
 @return 网络名称
 */
- (NSString *)transforFromNWModeToStringWithMode:(NSString *)nwMode{
    NSString *modeString = @"";
    switch (nwMode.integerValue) {
        case NWModeForbidINT:
            modeString = NWModeForbid;
            break;
        case NWMode2GINT:
            modeString = NWMode2G;
            break;
        case NWMode3GINT:
            modeString = NWMode3G;
            break;
        case NWMode3G2GINT:
            modeString = NWMode3G2G;
            break;
        case NWMode4G3GINT:
            modeString = NWMode4G3G;
            break;
        case NWMode4GINT:
            modeString = NWMode4G;
            break;
        case NWModeCommonINT:
            modeString = NWModeCommon;
            break;
        default:
            modeString = NWModeAuto;
            break;
    }
    return modeString;
}

/**
 转化网络设置 为 1、2、3、4、5、6

 @param nwMode 字符型网络设置
 @return 包含int字符的字符串
 */
- (NSString *)transforFromModeStringToMode:(NSString *)nwMode{
    NSInteger modeString;
    if ([nwMode isEqualToString:NWModeCommon]) {
        modeString = NWModeCommonINT;
    }else if ([nwMode isEqualToString:NWMode4G]){
        modeString = NWMode4GINT;
    }else if ([nwMode isEqualToString:NWMode4G3G]){
        modeString = NWMode4G3GINT;
    }else if ([nwMode isEqualToString:NWMode3G2G]){
        modeString = NWMode3G2GINT;
    }else if ([nwMode isEqualToString:NWMode3G]){
        modeString = NWMode3GINT;
    }else if ([nwMode isEqualToString:NWMode2G]){
        modeString = NWMode2GINT;
    }else{
        modeString = NWModeForbidINT;
    }
    return [NSString stringWithFormat:@"%d",(int)modeString];
}

- (NSString *)transformCPENetModeWithMode:(NSString *)nwMode{
    NSInteger modeInter = 0;
    if ([nwMode isEqualToString:NWMode4G]) {
        modeInter = 2;
    }else if ([nwMode isEqualToString:NWMode4G3G]){
        modeInter = 3;
    }else {
        modeInter = 5;
    }
    return [NSString stringWithFormat:@"%d",(int)modeInter];
}
#pragma mark - 切换是否漫游
- (void)dealSwitch:(UISwitch *)swith{
    NISelectModel *dial = _dataArray[0][3];
    dial.value = [NSNumber numberWithBool:[swith isOn]];
    swith.on = ![swith isOn];
    [self uploadAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] withModel:dial];
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
