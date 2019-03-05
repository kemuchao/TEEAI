//
//  NetServiceViewController.m
//  MifiManager
//
//  Created by notion on 2018/4/25.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "NetServiceViewController.h"
#import "ContentDetailTableViewCell.h"
#import "ContentTableViewCell.h"
#import "NISelectModel.h"

#import "NIHttpUtil.h"
#import "NIWanModel.h"
#import "NICellularModel.h"
#import "NIMannualNetworkItemModel.h"
#import "NINodeModel.h"
#import "NIRequestModelUtil.h"
#import "CPEInterfaceMain.h"
@interface NetServiceViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UILabel *labelNet;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NIWanModel *wan;
@end

@implementation NetServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
   
    [self initData];
    [self loadData];
    // Do any additional setup after loading the view.
}

#pragma mark - 初始化数据
- (void)initData{
    
    _dataArray = (NSMutableArray *)@[[NISelectModel setTitle:@"搜索网络" value:@"搜索所有可用网络"],[NISelectModel setTitle:@"自动选择" value:@"自动选择首选网络"]];
    [_tableView reloadData];
}
#pragma mark - CPE
- (void)loadCPEAllNet{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CPEInterfaceMain getNetWorkListSuccess:^(CPENetworkModel *networkModel){
        [self mbDismiss];
        [self loadCPEAllNet:networkModel];
    } failure:^(NSError *error){
        [self mbDismiss];
        [self mbShowToast:error.localizedDescription];
    } errorCause:^(NSString *errorCause){
        [self mbDismiss];
        if ([errorCause isEqualToString:CPEResultNeedLogin]) {
            [self showNeedRelogin];
        }else{
            [self mbShowToast:errorCause];
        }
    }];
}
- (void)uploadCPEWithIndex:(NSIndexPath *)index{
    NSMutableString *request = [[NSMutableString alloc] initWithString:@"<wan>"];
    if (index.row == 1) {
        [request appendFormat:@"<network_param>30</network_param>"];
    }else{
        NISelectModel *cellModel = _dataArray[index.row];
        CPENetListItem *netModel = cellModel.value;
        NSString *param = [NSString stringWithFormat:@"%@%%%@",netModel.act,netModel.plmn];
        [request appendFormat:@"<network_param>%@</network_param>",param];
    }
    [request appendString:@"</wan>"];
    NSString *requestXML = [CPERequestXML getXMLWithPath:@"util_wan" method:@"select_network" addXML:request];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CPEInterfaceMain uploadCommonWithRequestXML:requestXML Success:^(CPEResultCommonData *commonData){
        if ([commonData.status isEqualToString:CPEResultOK]) {
            [self goBack];
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
#pragma mark - 1802
- (void)loadData{
    if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
        return;
    }
    WeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@", MIFI_WAN_GET_PATH];
    [NIHttpUtil get:url params:nil success:^(AFHTTPRequestOperation *operation, id responseObj) {
        [self mbDismiss];
        BOOL check = [self checkLoginWithOperationResponse:operation.responseString];
        if (check) {
            [self showNeedRelogin];
            return ;
        }
        
        NIWanModel*wan = [NIWanModel wanWithResponseXmlString:operation.responseString isRGWStartXml:YES];
        if ([wan.cellular.manual_network_start isEqualToString:@"0"]) {
            weakSelf.labelNet.text = [NSString stringWithFormat:@"%@:%@",Localized(@"NetCurrentNet"),Localized(@"NetAuto")];
        }else{
            if (wan.cellular.network_param) {
                NSArray *netParamArray = [wan.cellular.network_param componentsSeparatedByString:@"%"];
                NSString *network = netParamArray[0];
                if ([network isEqualToString:@"30"]) {
                    network = Localized(@"NetAuto");
                }
                weakSelf.labelNet.text = [NSString stringWithFormat:@"%@:%@",Localized(@"NetCurrentNet"),network];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self mbDismiss];
        [self mbShowToast:error.localizedDescription];
    }];
}
#pragma mark - 搜索网络
- (void)loadAllNetwork{
    if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
        [self showWIFIAlert];
        return;
    }
    if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
        [self loadCPEAllNet];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@", MIFI_WAN_SET_PATH];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableString *requestXML = [NSMutableString new];
    [requestXML appendString:@"<?xml version=\"1.0\" encoding=\"US-ASCII\"?> <RGW><wan><cellular><search_network>1</search_network><network_select_done>0</network_select_done></cellular></wan></RGW>"];
    [NIHttpUtil longPostTimeOutInterval:300 url:url params:nil xmlString:requestXML success:^(AFHTTPRequestOperation *operation, id responseObj) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        BOOL check = [self checkLoginWithOperationResponse:operation.responseString];
        if (check) {
            [self showNeedRelogin];
            return ;
        }
        WeakSelf;
        [weakSelf loadWanData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self mbShowToast:error.localizedDescription];
    }];

}
//不断查询网络
- (void)loadWanData{
    WeakSelf;
    NSString *url = [NSString stringWithFormat:@"%@", MIFI_WAN_GET_PATH];
    [NIHttpUtil get:url params:nil success:^(AFHTTPRequestOperation *operation, id responseObj) {
        
        BOOL check = [self checkLoginWithOperationResponse:operation.responseString];
        if (check) {
            [self showNeedRelogin];
            return ;
        }
        NIWanModel*wan = [NIWanModel wanWithResponseXmlString:operation.responseString isRGWStartXml:YES];
        if (wan.cellular.mannual_network_list.count>0 && wan.cellular.mannual_network_list) {
            [self mbDismiss];
            weakSelf.wan =wan;
            [self loadAllNetworkListWithWan:wan];
        }else{
            [self loadWanData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self mbDismiss];
        [self mbShowToast:error.localizedDescription];
    }];
}
- (void)uploadAutoChooseNetwork{
    if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
        [self showWIFIAlert];
        return;
    }
    WeakSelf;
    //network_param 30
    //network_param_action 1
    //network_select_dons 0
    NSMutableArray *array = [NSMutableArray array];
    NSString *cellular = @"<network_param>30</network_param><network_param_action>1</network_param_action><network_select_dons>0<network_select_dons>";
    [array addObject:[NINodeModel nodelModelWithNodeName:@"cellular" value:cellular]];
    NSString *requestXml = [NIRequestModelUtil XMLStringWithParentNodesName:@[@"wan"] subNodes:array];
    NSString *url = [NSString stringWithFormat:@"%@", MIFI_WAN_SET_PATH];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NIHttpUtil longPostTimeOutInterval:120 url:url params:nil xmlString:requestXml success:^(AFHTTPRequestOperation *operation, id responseObj) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        BOOL check = [self checkLoginWithOperationResponse:operation.responseString];
        if (check) {
            [self showNeedRelogin];
            return ;
        }
        NIWanModel*wan = [NIWanModel wanWithResponseXmlString:operation.responseString isRGWStartXml:YES];
        weakSelf.wan = wan;
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self mbShowToast:error.localizedDescription];
        
       [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (void)uploadWithChooseIndex:(NSIndexPath *)index{
    if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
        [self showWIFIAlert];
        return;
    }
    if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
        [self uploadCPEWithIndex:index];
        return;
    }
    WeakSelf;
    NSArray *mannualNetworkList = self.wan.cellular.mannual_network_list;
    NSString *network_param;
    NIMannualNetworkItemModel *item = mannualNetworkList[index.row - 2];
    network_param = [self networkParamWithMannualNetworkItem:item];
    NSMutableString *requestXML = [[NSMutableString alloc] initWithString:@"<?xml version=\"1.0\" encoding=\"US-ASCII\"?> <RGW><wan><cellular>"];
    [requestXML appendFormat:@"<network_param>%@</network_param><network_param_action>1</network_param_action><network_select_done>0</network_select_done></cellular></wan></RGW>",network_param];
    NSString *url = [NSString stringWithFormat:@"%@", MIFI_WAN_SET_PATH];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NIHttpUtil longPostTimeOutInterval:120 url:url params:nil xmlString:requestXML success:^(AFHTTPRequestOperation *operation, id responseObj) {
        [self mbDismiss];
        BOOL check = [self checkLoginWithOperationResponse:operation.responseString];
        if (check) {
            [self showNeedRelogin];
            return ;
        }
        NIWanModel*wan = [NIWanModel wanWithResponseXmlString:operation.responseString isRGWStartXml:YES];
        weakSelf.wan = wan;
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self mbShowToast:error.localizedDescription];
        [self mbDismiss];
    }];
}
- (void)loadCPEAllNet:(CPENetworkModel *)networkModel{
    _dataArray = [NSMutableArray arrayWithArray:[_dataArray subarrayWithRange:NSMakeRange(0, 2)]];
    NSArray *mannualNetworkList = networkModel.netArray;
    for (CPENetListItem *item in mannualNetworkList) {
//        NSString *networkName = [self getNetworkStringWithMannualNetworkItem:item];
        NISelectModel *model = [NISelectModel setTitle:item.ispName value:item];
        [_dataArray addObject:model];
    }
    [_tableView reloadData];
}
/**
 加载所有网络选择

 @param wan 网络数据集合
 */
- (void)loadAllNetworkListWithWan:(NIWanModel *)wan{
    _dataArray = [NSMutableArray arrayWithArray:[_dataArray subarrayWithRange:NSMakeRange(0, 2)]];
    NSArray *mannualNetworkList = wan.cellular.mannual_network_list;
    for (NIMannualNetworkItemModel *item in mannualNetworkList) {
        NSString *networkName = [self getNetworkStringWithMannualNetworkItem:item];
        NISelectModel *model = [NISelectModel setTitle:networkName value:nil];
        [_dataArray addObject:model];
    }
    [_tableView reloadData];
}

#pragma mark - lieb
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
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
    ContentDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContentDetailTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.labelTitle.text = cellData.title;
    [cell.labelTitle setColor:[UIColor colorWithHexString:ColorBlueDeep] font:FontRegular];
    cell.labelDetail.text = cellData.value;
    [cell.labelDetail setColor:[UIColor colorWithHexString:ColorBlueNormal] font:FontDetail];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}
#pragma mark - 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        //搜索网络
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"搜索网络" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *cancel){
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:cancel];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *confirm){
            [self loadAllNetwork];
        }];
        [alert addAction:confirm];
        [self presentViewController:alert animated:YES completion:nil];
    }else if (indexPath.row == 1){
        //自动选择
        if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
            [self uploadCPEWithIndex:indexPath];
        }else{
            [self uploadAutoChooseNetwork];
        }
        
    }else{
        [self uploadWithChooseIndex:indexPath];
    }
}


#pragma mark - 处理
-(NSString *) getNetworkStringWithMannualNetworkItem:(NIMannualNetworkItemModel *) mannualNetworkItem {
    NSMutableString *result = [[NSMutableString alloc]init];
    [result appendFormat:@"%@ ", mannualNetworkItem.name];
    if ([mannualNetworkItem.act isEqualToString:@"0"]) {
        [result appendString:@"2G"];
    } else if ([mannualNetworkItem.act isEqualToString:@"1"]) {
        [result appendString:@"2G C"];
    } else if ([mannualNetworkItem.act isEqualToString:@"2"]) {
        [result appendString:@"3G"];
    } else if ([mannualNetworkItem.act isEqualToString:@"3"]) {
        [result appendString:@"2G C"];
    } else if ([mannualNetworkItem.act isEqualToString:@"4"]) {
        [result appendString:@"2G(EDGE)"];
    } else if ([mannualNetworkItem.act isEqualToString:@"5"]) {
        [result appendString:@"3G(HSDPA)"];
    } else if ([mannualNetworkItem.act isEqualToString:@"6"]) {
        [result appendString:@"3G(HSUPA)"];
    } else if ([mannualNetworkItem.act isEqualToString:@"7"]) {
        [result appendString:@"4G(LTE)"];
    }
    return [result copy];
}

-(NSString *) networkParamWithMannualNetworkItem:(NIMannualNetworkItemModel *) mannualNetworkItem {
    NSMutableString *result = [[NSMutableString alloc]init];
    [result appendFormat:@"%@",mannualNetworkItem.name];
    [result appendString:@"%"];
    [result appendFormat:@"%@",mannualNetworkItem.act];
    [result appendString:@"%"];
    [result appendFormat:@"%@",mannualNetworkItem.plmm_name];
    return [result mutableCopy];
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
