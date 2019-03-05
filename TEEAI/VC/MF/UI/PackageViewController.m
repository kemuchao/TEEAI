//
//  PackageViewController.m
//  MifiManager
//
//  Created by notion on 2018/3/22.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "PackageViewController.h"
#import "DetailTableViewCell.h"

#import "FlowNumberSetting.h"
#import "ActionView.h"
#import "NISelectModel.h"
#import "NISelectView.h"
#import "NICancelConfirmButton.h"
#define HeightBottomView 30

#import "WanStatistics.h"
#import "Statistics.h"
#import "NIRequestModelUtil.h"
#import "NIGMBManagerTool.h"
#import "NINodeModel.h"
#import "NIStatus1Model.h"
#import "CPEInterfaceMain.h"
@interface PackageViewController ()

<UITableViewDelegate,UITableViewDataSource,ActionViewEnterDelegate>
{
    dispatch_source_t _timer;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UILabel *labelHistory;
@property (nonatomic, strong) UIButton *buttonClear;
@property (nonatomic, strong) UIView *viewBottom;
@property (nonatomic, strong) CPEStatisticsStatSetting *wanStatistics;

@end

@implementation PackageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellOne"];
    
    
    [self loadData];
    if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
        [self loadCPEPackage];
    }else{
        [self loadNetPackageInfo];
        [self loadHistoryData];
    }
    NSTimeInterval period = 10.0; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    WeakSelf;
    dispatch_source_set_event_handler(_timer, ^{
        //在这里执行事件
        if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
            [weakSelf loadCPEUsedData];
        }else{
            [weakSelf loadHistoryData];
        }
    });
    
    dispatch_resume(_timer);
    // Do any additional setup after loading the view.
}

/**
 设置初始数据
 */
- (void)loadData{
    //    @[@"套餐设置类型",@"套餐流量",@"警戒范围",@"手动流量校正"];
    NISelectModel *style = [NISelectModel setTitle:@"套餐设置类型" value:nil];
    NISelectModel *flow = [NISelectModel setTitle:@"套餐流量" value:nil];
    //    NISelectModel *date = [NISelectModel setTitle:@"开始时间" value:nil];
    NISelectModel *range = [NISelectModel setTitle:@"警戒范围" value:nil];
    NISelectModel *manul = [NISelectModel setTitle:@"手动流量校正" value:nil];
    _dataArray = [NSMutableArray arrayWithObjects:style,flow,range,manul, nil];
    
}
#pragma mark - CPE
/**
 加载当前流量设置
 */
- (void)loadCPEPackage{
    WeakSelf;
    [CPEInterfaceMain getWanStatisticsSuccess:^(CPEStatisticsStatSetting *statisticsSetting){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        weakSelf.wanStatistics = statisticsSetting;
        //套餐
        NSString *packageName = [NSString new];
        NSString *packageDB = [NSString new];
        CPEBasicMon *monData = statisticsSetting.basicMon;
        if ([monData.enable isEqualToString:@"1"]) {
            packageDB = [NIGMBManagerTool getNetNumberWithDBString:monData.avlData];
            packageName = NWStatisticsTimeMonth;
            
        }else{
            packageName = NWStatisticsTimeUnlimited;
        }
        NISelectModel *packageMode = weakSelf.dataArray[0];
        packageMode.value = packageName;
        [self reloadAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] withModel:packageMode];
        //数值
        NISelectModel *packageModeDB = weakSelf.dataArray[1];
        packageModeDB.value = packageDB;
        [self reloadAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] withModel:packageModeDB];
        //限制
        CPEGeneral *general = statisticsSetting.general;
        if ([general.warnEnable isEqualToString:@"1"]) {
            float range = general.warnPercent.floatValue;
            NSString *rangeName = @"";
            if (range == 100) {
                rangeName = NWStatisticsUpperRangeNone;
            }else if (range >= 90){
                rangeName = NWStatisticsUpperRange10;
            }else if (range >= 80){
                rangeName = NWStatisticsUpperRange20;
            }else if (range >= 70){
                rangeName = NWStatisticsUpperRange30;
            }else{
                rangeName = NWStatisticsUpperRange40;
            }
            NISelectModel *generalModel = weakSelf.dataArray[2];
            generalModel.value = rangeName;
            [self reloadAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] withModel:generalModel];
        }else{
            NISelectModel *generalModel = weakSelf.dataArray[2];
            generalModel.value = NWStatisticsUpperRangeNone;
            [self reloadAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] withModel:generalModel];
        }
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self mbShowToast:error.localizedDescription];
    }errorCause:^(NSString *errorCause){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([errorCause isEqualToString:CPEResultNeedLogin]) {
            [self showNeedRelogin];
        }
    }];
    [CPEInterfaceMain getWanCurMonthSuccess:^(CPEStatCurMon *monStat){
        //流量
        
        NSString *monUsedStr = [NIGMBManagerTool getNetNumberWithDBString:monStat.basicMonUsed];
        NISelectModel *generalModel = weakSelf.dataArray[3];
        generalModel.value = monUsedStr;
        [self reloadAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] withModel:generalModel];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self mbShowToast:error.localizedDescription];
    } errorCause:^(NSString *errorCause){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([errorCause isEqualToString:CPEResultNeedLogin]) {
            [self showNeedRelogin];
        }
    }];
}

- (void)uploadCPEAtIndex:(NSIndexPath *)index withModel:(NISelectModel *)model{
    NSMutableString *request = [[NSMutableString alloc] initWithString:@"<statistics>"];
    NSMutableString *requestXML = [NSMutableString new];
    if (index.row == 0) {
        //general
        CPEGeneral *general = _wanStatistics.general;
        [request appendString:@"<general>"];
        [request appendFormat:@"<warn_enable>%@</warn_enable>",general.warnEnable];
        [request appendFormat:@"<warn_percent>%@</warn_percent>",general.warnPercent];
        [request appendFormat:@"<dis_enable>%@</dis_enable>",general.disEnable];
        [request appendString:@"</general>"];
        //basic_mon
        CPEBasicMon *basicMon = _wanStatistics.basicMon;
        if ([model.value isEqualToString:NWStatisticsTimeMonth]) {
            [request appendString:@"<basic_mon>"];
            [request appendFormat:@"<enable>1</enable>"];
            [request appendFormat:@"<avl_data>%@</avl_data>",basicMon.avlData];
            [request appendString:@"</basic_mon>"];
        }else if ([model.value isEqualToString:NWStatisticsTimeUnlimited]){
            [request appendString:@"<basic_mon>"];
            [request appendFormat:@"<enable>0</enable>"];
            [request appendString:@"</basic_mon>"];
        }
        //idle
        [request appendString:@"<idle><enable>0</enable></idle>"];
        //period
        [request appendString:@"<period><enable>0</enable></period>"];
        [request appendString:@"</statistics>"];
        requestXML = [CPERequestXML getXMLWithPath:@"statistics" method:@"stat_set_settings" addXML:request];
    }else if (index.row == 1){
        //general
        CPEGeneral *general = _wanStatistics.general;
        [request appendString:@"<general>"];
        [request appendFormat:@"<warn_enable>%@</warn_enable>",general.warnEnable];
        [request appendFormat:@"<warn_percent>%@</warn_percent>",general.warnPercent];
        [request appendFormat:@"<dis_enable>%@</dis_enable>",general.disEnable];
        [request appendString:@"</general>"];
        //basic_mon
        NSString *net = [model.value substringToIndex:[model.value length] - 2];
        NSString *type = [model.value substringFromIndex:[model.value length] - 2];
        float netNumber = [NIGMBManagerTool getNetNumberWithString:net type:type];
        //        CPEBasicMon *basicMon = _wanStatistics.basicMon;
        [request appendString:@"<basic_mon>"];
        [request appendFormat:@"<enable>1</enable>"];
        [request appendFormat:@"<avl_data>%.0f</avl_data>",netNumber];
        [request appendString:@"</basic_mon>"];
        //idle
        [request appendString:@"<idle><enable>0</enable></idle>"];
        //period
        [request appendString:@"<period><enable>0</enable></period>"];
        [request appendString:@"</statistics>"];
        requestXML = [CPERequestXML getXMLWithPath:@"statistics" method:@"stat_set_settings" addXML:request];
    }else if (index.row == 2){
        //general
        float upper = 0;
        if ([model.value isEqualToString:NWStatisticsUpperRangeNone]) {
            upper = 100;
        }else if ([model.value isEqualToString:NWStatisticsUpperRange10]){
            upper = 90;
        }else if ([model.value isEqualToString:NWStatisticsUpperRange20]){
            upper = 80;
        }else if ([model.value isEqualToString:NWStatisticsUpperRange30]){
            upper = 70;
        }else if ([model.value isEqualToString:NWStatisticsUpperRange40]){
            upper = 60;
        }
        CPEGeneral *general = _wanStatistics.general;
        [request appendString:@"<general>"];
        if (upper == 100) {
            [request appendString:@"<warn_enable>0</warn_enable>"];
        }else{
            [request appendFormat:@"<warn_enable>1</warn_enabl>"];
            [request appendFormat:@"<warn_percent>%.0f</warn_percent>",upper];
            [request appendFormat:@"<dis_enable>%@</dis_enable>",general.disEnable];
        }
        [request appendString:@"</general>"];
        //basic_mon
        CPEBasicMon *basicMon = _wanStatistics.basicMon;
        if ([model.value isEqualToString:NWStatisticsTimeMonth]) {
            [request appendString:@"<basic_mon>"];
            [request appendFormat:@"<enable>1</enable>"];
            [request appendFormat:@"<avl_data>%@</avl_data>",basicMon.avlData];
            [request appendString:@"</basic_mon>"];
        }else if ([model.value isEqualToString:NWStatisticsTimeUnlimited]){
            [request appendString:@"<basic_mon>"];
            [request appendFormat:@"<enable>0</enable>"];
            [request appendString:@"</basic_mon>"];
        }
        //idle
        [request appendString:@"<idle><enable>0</enable></idle>"];
        //period
        [request appendString:@"<period><enable>0</enable></period>"];
        [request appendString:@"</statistics>"];
        requestXML = [CPERequestXML getXMLWithPath:@"statistics" method:@"stat_set_settings" addXML:request];
    }else if (index.row == 3){
        NSString *net = [model.value substringToIndex:[model.value length] - 2];
        NSString *type = [model.value substringFromIndex:[model.value length] - 2];
        float netNumber = [NIGMBManagerTool getNetNumberWithString:net type:type];
        [request appendFormat:@"<adjust_value>%.0f</adjust_value>",netNumber];
        [request appendString:@"</statistics>"];
        requestXML = [CPERequestXML getXMLWithPath:@"statistics" method:@"stat_adjust_used_mon" addXML:request];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CPEInterfaceMain uploadCommonWithRequestXML:requestXML Success:^(CPEResultCommonData *status){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([status.status isEqualToString:CPEResultOK]) {
            [self loadCPEPackage];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotifyPINChange object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotifyRefreshName object:nil];
        }
    } failure:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self mbShowToast:error.localizedDescription];
    }errorCause:^(NSString *errorCause){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([errorCause isEqualToString:CPEResultNeedLogin]) {
            [self showNeedRelogin];
        }
    }];
}

- (void)loadCPEUsedData{
    
    [CPEInterfaceMain getCommonDataSuccess:^(CPEStatisticsCommonData *commonData){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *used = [NIGMBManagerTool getNetNumberWithDBString:[NSString stringWithFormat:@"%@",commonData.totalRxTxBytes]];
        [self reloadBottomViewWithUsedData:used];
    } failure:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self mbShowToast:error.localizedDescription];
    }errorCause:^(NSString *errorCause){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([errorCause isEqualToString:CPEResultNeedLogin]) {
            [self showNeedRelogin];
        }
    }];
}
- (void)uploadCPEClearData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *requestXML = [CPERequestXML getXMLWithPath:@"statistics" method:@"stat_clear_common_data" addXML:nil];
    [CPEInterfaceMain uploadCommonWithRequestXML:requestXML Success:^(CPEResultCommonData *status){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self loadCPEUsedData];
    } failure:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self mbShowToast:error.localizedDescription];
    }errorCause:^(NSString *errorCause){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([errorCause isEqualToString:CPEResultNeedLogin]) {
            [self showNeedRelogin];
        }
    }];
}
#pragma mark - 1802
/**
 加载初始数据
 */
- (void)loadNetPackageInfo{
    if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
        [self showWIFIAlert];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@", MIFI_STATISTICS_GET_PATH];
    [NIHttpUtil get:url params:nil success:^(AFHTTPRequestOperation *operation, id responseObj) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        BOOL check = [self checkLoginWithOperationResponse:operation.responseString];
        if (check) {
            [self showNeedRelogin];
            return ;
        }
        Statistics *statistics = [Statistics initWithResponseXmlString:operation.responseString isRGWStartXml:YES];
        [self reloadTableWithWanInfo:statistics];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self mbShowToast:error.localizedDescription];
    }];
}

/**
 加载历史流量数据
 */
- (void)loadHistoryData{
    if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
        [self showWIFIAlert];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@", MIFI_STATUS1_PATH];
    [NIHttpUtil get:url params:nil success:^(AFHTTPRequestOperation *operation, id responseObj) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        BOOL check = [self checkLoginWithOperationResponse:operation.responseString];
        if (check) {
            [self showNeedRelogin];
            return ;
        }
        NIStatus1Model *routerInfo = [NIStatus1Model status1WithResponseXmlString:operation.responseString];
        if (routerInfo.wan == nil) {
            [self showNeedRelogin];
            return;
        }
        float usedFloat = routerInfo.statistics.WanStatistics.rx_byte_all.floatValue+routerInfo.statistics.WanStatistics.tx_byte_all.floatValue;
        NSString *used = [NIGMBManagerTool getNetNumberWithDBString:[NSString stringWithFormat:@"%.0f",usedFloat]];
        [self reloadBottomViewWithUsedData:used];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self mbShowToast:error.localizedDescription];
        NILog(@"operation = %@, error = %@",operation.responseString, error);
    }];
}
/**
 根据返回数据重新刷新表单
 
 @param statistics 数据
 */
- (void)reloadTableWithWanInfo:(Statistics *)statistics{
    [self loadData];
    WanStatistics *wanStatistics = statistics.wanStatistics;
    NSString *mode = [NIGMBManagerTool getTimeLimitedWithTimeMode:wanStatistics.statMangMethod];
    NISelectModel *packageMode = _dataArray[0];
    packageMode.value = mode;
    [self reloadAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] withModel:packageMode];
    NSString *totalString = [NSString new];
    NSString *upperString = [NSString new];
    NSString *usedString = [NSString new];
    
    if ([mode isEqualToString:NWStatisticsTimeForbid]) {
        _dataArray = [NSMutableArray arrayWithObject:_dataArray[0]];
        [_tableView reloadData];
        return;
    }else if([mode isEqualToString:NWStatisticsTimeMonth]){
        totalString = wanStatistics.totalAvaliableMonth;
        upperString = wanStatistics.upperValueMonth;
        usedString = wanStatistics.totalUsedMonth;
    }else if ([mode isEqualToString:NWStatisticsTimeUnlimited]){
        totalString = wanStatistics.totalAvaliableUnlimit;
        upperString = wanStatistics.upperValueUnlimit;
        usedString = wanStatistics.totalUsedUnlimit;
    }else{
        
    }
    
    NSString *avaliable = [NIGMBManagerTool getNetNumberWithDBString:totalString];
    //    NSString *used = [NIGMBManagerTool getNetNumberWithDBString:[NSString stringWithFormat:@"%.0f",usedFloat]];
    //    [self reloadBottomViewWithUsedData:used];
    
    NISelectModel *avaliableModel = _dataArray[1];
    avaliableModel.value = avaliable;
    [self reloadAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] withModel:avaliableModel];
    
    float upper = [upperString floatValue];
    float total = [totalString floatValue];
    
    float range = upper/total;
    NSString *rangeName = @"";
    if (range == 1 || total == 0 || upper == 0) {
        rangeName = NWStatisticsUpperRangeNone;
    }else if (range >= 0.85){
        rangeName = NWStatisticsUpperRange10;
    }else if (range >= 0.75){
        rangeName = NWStatisticsUpperRange20;
    }else if (range >= 0.65){
        rangeName = NWStatisticsUpperRange30;
    }else{
        rangeName = NWStatisticsUpperRange40;
    }
    NISelectModel *rangeModel = _dataArray[2];
    rangeModel.value = rangeName;
    [self reloadAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1] withModel:rangeModel];
    [_tableView reloadData];
}

/**
 显示已用数据
 
 @param usedData 使用数据
 */
- (void)reloadBottomViewWithUsedData:(NSString *)usedData{
    [_viewBottom clear];
    CGFloat viewHeight = HeightBottomView*Ratio;
    
    NSString *historyAmount = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"dataHistoryNumber", nil),usedData];
    CGFloat stringWidth = [self getText:historyAmount WidthWithHeight:HeightLabel*Ratio andFont:FontNormal];
    CGRect frame = [self dealGetFrameWithX:(SCREEN_WIDTH - stringWidth - MarginX - 50)/2 Y:(viewHeight - HeightLabel)/2 Width:stringWidth Height:HeightLabel];
    
    UILabel *labelTop = [self dealSetLabelWithTitle:historyAmount color:[UIColor colorWithHexString:ColorBlueDeep] bgColor:ColorClear font:FontNormal textAlign:NSTextAlignmentRight frame:frame];
    [_viewBottom addSubview:labelTop];
    _labelHistory = labelTop;
    
    CGRect frameButton = CGRectMake(CGRectGetMaxX(labelTop.frame)+MarginX, (viewHeight - HeightLabel)/2, 50, HeightLabel);
    UIButton *button = [self dealSetButtonWithTitle:NSLocalizedString(@"dataClear", nil) color:[UIColor colorWithHexString:ColorBlueDeep] bgColor:ColorWhite font:FontNormal frame:frameButton image:nil];
    [self loadSubViewLayer:button withBorderCircle:HeightLabel/2 borderColor:ColorWhite];
    [button addEvent:^(UIButton *btn){
        if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
            [self uploadCPEClearData];
        }else{
            [self uploadClear];
        }
        
    }];
    [_viewBottom addSubview:button];
}
/**
 上传设置数据
 
 @param indexPath 下标位置
 @param model 上传数据
 */
- (void)uploadAtIndexPath:(NSIndexPath *)indexPath withModel:(NISelectModel *)model{
    //更新网络选择
    if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
        [self showWIFIAlert];
        return;
    }
    
    NSMutableString *requestXML = [[NSMutableString alloc] initWithString:@"<?xml version=\"1.0\" encoding=\"US-ASCII\"?>"];
    [requestXML appendString:@"<RGW><statistics><WanStatistics>"];
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    if(indexPath.row == 0){
        [requestXML appendString:@"<set_action>set_mang_method</set_action>"];
        int method = 0;
        if ([model.value isEqualToString:NWStatisticsTimeForbid]) {
            method = 0;
        }else if ([model.value isEqualToString:NWStatisticsTimeMonth]){
            method = 1;
        }else if ([model.value isEqualToString:NWStatisticsTimeUnlimited]){
            method = 3;
        }
        [requestXML appendFormat:@"<stat_mang_method>%ld</stat_mang_method>",(long)method];
    }else if (indexPath.row == 1){
        NSString *net = [model.value substringToIndex:[model.value length] - 2];
        NSString *type = [model.value substringFromIndex:[model.value length] - 2];
        float netNumber = [NIGMBManagerTool getNetNumberWithString:net type:type];
        NSString *rangeModel = [(NISelectModel *)_dataArray[0] value];
        if ([rangeModel isEqualToString:NWStatisticsTimeForbid ]) {
            
        }else if ([rangeModel isEqualToString:NWStatisticsTimeMonth ]){
            //            return @"total_available_month";
            [requestXML appendFormat:@"<total_available_month>%.0f</total_available_month>",netNumber];
        }else if ([rangeModel isEqualToString:NWStatisticsTimeUnlimited ]){
            //            return @"total_avaliable_unlimit";
            [requestXML appendFormat:@"<total_avaliable_unlimit>%.0f</total_avaliable_unlimit>",netNumber];
        }else{
            
        }
    }else if (indexPath.row == 2){
        NISelectModel *netModel = _dataArray[1];
        NSString *net = [netModel.value substringToIndex:[netModel.value length] - 2];
        NSString *type = [netModel.value substringFromIndex:[netModel.value length] - 2];
        float netNumber = [NIGMBManagerTool getNetNumberWithString:net type:type];
        float upper = 0;
        if ([model.value isEqualToString:NWStatisticsUpperRangeNone]) {
            upper = 1;
        }else if ([model.value isEqualToString:NWStatisticsUpperRange10]){
            upper = 0.9;
        }else if ([model.value isEqualToString:NWStatisticsUpperRange20]){
            upper = 0.8;
        }else if ([model.value isEqualToString:NWStatisticsUpperRange30]){
            upper = 0.7;
        }else if ([model.value isEqualToString:NWStatisticsUpperRange40]){
            upper = 0.6;
        }
        netNumber = netNumber *upper;
        [array addObject:[NINodeModel nodelModelWithNodeName:@"set_section" value:@"set_upper_range_value"]];
        NSString *rangeModel = [(NISelectModel *)_dataArray[0] value];
        NSString *rangeName = [NIGMBManagerTool getUpperRangeNameWithTimeMode:rangeModel];
        [array addObject:[NINodeModel nodelModelWithNodeName:rangeName value:[NSString stringWithFormat:@"%.0f",netNumber]]];
        [requestXML appendString:@"<set_section>set_upper_range_value</set_section>"];
        if ([rangeModel isEqualToString:NWStatisticsTimeForbid ]) {
        }else if ([rangeModel isEqualToString:NWStatisticsTimeMonth ]){
            //           month
            [requestXML appendFormat:@"<upper_value_month>%.0f</upper_value_month>",netNumber];
        }else if ([rangeModel isEqualToString:NWStatisticsTimeUnlimited ]){
            //           unlimit
            [requestXML appendFormat:@"<upper_value_unlimit>%.0f</upper_value_unlimit>",netNumber];
        }else{
            
        }
        
    }else if (indexPath.row == 3){
        NSString *net = [model.value substringToIndex:[model.value length] - 2];
        NSString *type = [model.value substringFromIndex:[model.value length] - 2];
        float netNumber = [NIGMBManagerTool getNetNumberWithString:net type:type];
        NSString *rangeModel = [(NISelectModel *)_dataArray[0] value];
        if ([rangeModel isEqualToString:NWStatisticsTimeForbid ]) {
            
        }else if ([rangeModel isEqualToString:NWStatisticsTimeMonth ]){
            //month
            [requestXML appendFormat:@"<set_action>set_stat_value_month</set_action><corrected_value_month>%.0f</corrected_value_month>",netNumber];
        }else if ([rangeModel isEqualToString:NWStatisticsTimeUnlimited ]){
            //unlimit
            [requestXML appendFormat:@"<set_action>set_stat_value_unlimit</set_action><corrected_value_unlimit>%.0f</corrected_value_unlimit>",netNumber];
        }else{
            
        }
    }
    
    [requestXML appendString:@"</WanStatistics></statistics></RGW>"];
    NSString *url = [NSString stringWithFormat:@"%@", MIFI_STATISTICS_SET_PATH];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NIHttpUtil post:url params:nil xmlString:requestXML success:^(AFHTTPRequestOperation *operation, id responseObj) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        BOOL check = [self checkLoginWithOperationResponse:operation.responseString];
        if (check) {
            [self showNeedRelogin];
            return ;
        }
        Statistics *statistics = [Statistics initWithResponseXmlString:operation.responseString isRGWStartXml:YES];
        [self reloadTableWithWanInfo:statistics];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotifyPINChange object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotifyRefreshName object:nil];
        
        //        [self reloadAtIndexPath:indexPath withModel:model];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self mbShowToast:error.localizedDescription];
    }];
}
#pragma mark - 清空已用流量
/**
 清空使用数据
 */
- (void)uploadClear{
    if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
        [self showWIFIAlert];
        return;
    }
    
    NSMutableString *requestXML = [[NSMutableString alloc] init];
    [requestXML appendString:@"<?xml version=\"1.0\" encoding=\"US-ASCII\"?> <RGW><statistics><WanStatistics><reset>1</reset></WanStatistics></statistics></RGW>"];
    NSString *url = [NSString stringWithFormat:@"%@", MIFI_STATISTICS_SET_PATH];
    
    [NIHttpUtil post:url params:nil xmlString:requestXML success:^(AFHTTPRequestOperation *operation, id responseObj) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        BOOL check = [self checkLoginWithOperationResponse:operation.responseString];
        if (check) {
            [self showNeedRelogin];
            return ;
        }
        [self loadHistoryData];
        //        Statistics *statistics = [Statistics initWithResponseXmlString:operation.responseString isRGWStartXml:YES];
        //        [self reloadTableWithWanInfo:statistics];
        //        [self mbDismiss];
        //        [[NSNotificationCenter defaultCenter] postNotificationName:NotifyRefreshName object:nil];
        //        //        [self reloadAtIndexPath:indexPath withModel:model];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self mbShowToast:error.localizedDescription];
    }];
    
}


#pragma mark - 刷新
/**
 重置列表中显示数据
 
 @param indexPath 下标
 @param model 数据
 */
- (void)reloadAtIndexPath:(NSIndexPath *)indexPath withModel:(NISelectModel *)model{
    [_dataArray replaceObjectAtIndex:indexPath.row withObject:model];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return MarginY*Ratio;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return MarginY*Ratio;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"flowSetCell"];
    
    NISelectModel *model = [_dataArray objectAtIndex:indexPath.row];
    cell.labelTitle.text = model.title;
    cell.labelDetail.text = model.value?model.value:@"";
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NISelectModel *cellOne = _dataArray[0];
    if ([cellOne.value isEqualToString:NWStatisticsTimeUnlimited]) {
        return 1;
    }else{
        return [_dataArray count];
    }
}
#pragma mark - 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self dealSetFlowStyle];
    } else if(indexPath.row == 1){
        [self dealSetActionWithIndexpath:[NSIndexPath indexPathForRow:1 inSection:0] title:@"输入套餐流量"];
    } else if(indexPath.row == 2){
        [self dealSetAlarmRange];
    }else if(indexPath.row == 3){
        [self dealSetActionWithIndexpath:[NSIndexPath indexPathForRow:3 inSection:0] title:@"输入校正流量"];
    }else{
        
    }
}


#pragma mark - 选择

/**
 显示套餐
 */
- (void)dealSetFlowStyle{
    NSArray *modelArray = @[
                            [NISelectModel setTitle:NWStatisticsTimeForbid value:nil],
                            [NISelectModel setTitle:NWStatisticsTimeMonth value:nil],
                            [NISelectModel setTitle:NWStatisticsTimeUnlimited value:nil]
                            ];
    if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
        modelArray = @[
                       [NISelectModel setTitle:NWStatisticsTimeMonth value:nil],
                       [NISelectModel setTitle:NWStatisticsTimeUnlimited value:nil]
                       ];
    }

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"选择套餐类型" preferredStyle:UIAlertControllerStyleActionSheet];
    for (NISelectModel * seleModel in modelArray) {
        UIAlertAction *forbid = [UIAlertAction actionWithTitle:seleModel.title style:UIAlertActionStyleDefault handler:^(UIAlertAction *ok){
            [self setFlow:seleModel.title];
        }];
        [alert addAction:forbid];
    }
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *ok){

    }];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];

}

-(void)setFlow:(NSString *)title {
    NISelectModel *cellModel = _dataArray[0];
    cellModel.title = @"套餐设置类型";
    cellModel.value = title;
    if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
        [self uploadCPEAtIndex:[NSIndexPath indexPathForRow:0 inSection:0] withModel:cellModel];
    }else{
        [self uploadAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] withModel:cellModel];
    }
}

/**
 显示流量
 */
- (void)dealSetFlowNumber{
    //    NISelectModel *model = [_dataArray objectAtIndex:1];
    
}

/**
 设置弹框
 */
- (void)dealSetActionWithIndexpath:(NSIndexPath *)indexPath title:(NSString *)title{
    CGFloat viewHeightTop = HeightButton +3*MarginY+HeightLabel ;
    CGFloat viewHeightBottom = HeightButton +2*MarginY;
    
    ActionView *action = [[ActionView alloc] initWithSubView:nil];
    action.delegate = self;
    FlowNumberSetting *flowNumber = [[FlowNumberSetting alloc] initWithFrame:[self dealGetFrameWithX:0 Y:SCREEN_HEIGHT - viewHeightTop - viewHeightBottom - NAVIHEIGHT - TABBARHEIGHT Width:SCREEN_WIDTH  Height:viewHeightTop] title:title andFlowType:FlowTypeGB];
    
    [action resetSubView:flowNumber];
    [self.view addSubview:action];
    WeakSelf;
    NICancelConfirmButton *buttonGroup = [[NICancelConfirmButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - viewHeightBottom - NAVIHEIGHT - TABBARHEIGHT, SCREEN_WIDTH, viewHeightBottom) withBlock:^(ButtonEnventType type,UIButton *btn){
        [action hide];
        if(type == ButtonEnventConfirm){
            NISelectModel *model = [weakSelf.dataArray objectAtIndex:indexPath.row];
            NSString *typeName = type == flowNumber.type == FlowTypeGB ? @"GB":@"MB";
            NSString *value = [flowNumber getValue];
            if (value) {
                if (value.floatValue < 1 && [typeName isEqualToString:@"GB"]) {
                    value = [NSString stringWithFormat:@"%.1f",value.floatValue*1024];
                    typeName = @"MB";
                }
                model.value = [NSString stringWithFormat:@"%@%@",value,typeName];
                if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
                    [self uploadCPEAtIndex:indexPath withModel:model];
                }else{
                    [self uploadAtIndexPath:indexPath withModel:model];
                }
            }
        }
    }];
    [action addIndexPath:indexPath];
    [action setBorderMarginY:viewHeightBottom];
    [action addSubview:buttonGroup];
    [action show];
}

/**
 告警范围
 */
- (void)dealSetAlarmRange{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"设置警告范围" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"无限制" style:UIAlertActionStyleDefault handler:^(UIAlertAction *ok){
        [self setworning:@"无限制"];
    }];
    [alert addAction:no];
    UIAlertAction *ten = [UIAlertAction actionWithTitle:@"剩余10%" style:UIAlertActionStyleDefault handler:^(UIAlertAction *ok){
        [self setworning:@"剩余10%"];
    }];
    [alert addAction:ten];
    UIAlertAction *two = [UIAlertAction actionWithTitle:@"剩余20%" style:UIAlertActionStyleDefault handler:^(UIAlertAction *ok){
        [self setworning:@"剩余20%"];
    }];
    [alert addAction:two];
    UIAlertAction *three = [UIAlertAction actionWithTitle:@"剩余30%" style:UIAlertActionStyleDefault handler:^(UIAlertAction *ok){
        [self setworning:@"剩余30%"];
    }];
    [alert addAction:three];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *ok){
    }];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)setworning:(NSString *)value{
    NISelectModel *cellModel = [[NISelectModel alloc]init];
    cellModel.title = @"警戒范围";
    cellModel.value = value;
    if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
        [self uploadCPEAtIndex:[NSIndexPath indexPathForRow:2 inSection:0] withModel:cellModel];
    }else{
        [self uploadAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] withModel:cellModel];
    }
}

/**
 手动流量校正
 */
- (void)dealManulFlowAdjust{
    
}
#pragma mark - 接受代理
- (void)actionView:(ActionView *)actionView atIndexPath:(NSIndexPath *)indexPath ReceiveEnterValue:(NSString *)enterValue flowType:(FlowType)type{
    NISelectModel *model = [_dataArray objectAtIndex:indexPath.row];
    NSString *typeName = type == FlowTypeGB ? @"GB":@"MB";
    NSString *value = enterValue;
    if (value.floatValue < 1 && [typeName isEqualToString:@"GB"]) {
        value = [NSString stringWithFormat:@"%.1f",value.floatValue*1024];
        typeName = @"MB";
    }
    model.value = [NSString stringWithFormat:@"%@%@",value,typeName];
    
    [self reloadAtIndexPath:indexPath withModel:model];
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
