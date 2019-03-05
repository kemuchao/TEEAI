//
//  AboutViewController.m
//  MifiManager
//
//  Created by yanlei jin on 2018/3/21.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "AboutViewController.h"
#define HeightHeadView SCREEN_HEIGHT*0.3
#import "ContentPlainTableViewCell.h"
#import "APPIconView.h"
#import "NIHttpUtil.h"
#import "NIAuthModel.h"
#import "NIStatus1Model.h"
#import "NISelectModel.h"
@interface  AboutViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NIStatus1Model *status1;
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = NormalBlue;
   
    [self loadMainView];
    [self loadData];
}

- (void)loadMainView{
    CGRect frame = [self dealGetFrameWithX:0 Y:HeightNanvi Width:SCREEN_WIDTH Height:SCREEN_HEIGHT-HeightNanvi];
    UITableView *tableView = [self dealSetTableViewWithCellHeight:40 frame:frame bgColor:ColorClear delegate:self];
    [tableView registerNib:[UINib nibWithNibName:@"ContentPlainTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
//    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NIHttpUtil get:url params:nil success:^(AFHTTPRequestOperation *operation, id responseObj) {
        [weakSelf mbDismiss];
        BOOL check = [weakSelf checkLoginWithOperationResponse:operation.responseString];
        if (check) {
            [weakSelf showNeedRelogin];
            return ;
        }
        NILog(@"%@",operation.responseString);
        NIStatus1Model *routerInfo = [NIStatus1Model status1WithResponseXmlString:operation.responseString];
        weakSelf.status1 = routerInfo;
        weakSelf.dataArray = (NSMutableArray *)@[
                                         [NISelectModel setTitle:@"设备类型" value:routerInfo.sysinfo.device_name],
                                         [NISelectModel setTitle:@"MAC地址" value:routerInfo.lan.mac],
                                         [NISelectModel setTitle:@"IMEI" value:routerInfo.wan.IMEI],
                                         [NISelectModel setTitle:@"序列号" value:routerInfo.wan.ICCID],
                                         [NISelectModel setTitle:@"软件版本" value:routerInfo.sysinfo.version_num],
                                         [NISelectModel setTitle:@"硬件版本" value:routerInfo.sysinfo.hardware_version],
                                         [NISelectModel setTitle:@"APP版本" value:routerInfo.sysinfo.ssg_version]
                                         ];
        [weakSelf.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf mbDismiss];
        [weakSelf mbShowToast:error.localizedDescription];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ContentPlainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.line.backgroundColor = NormalGray;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NISelectModel *cellModel = _dataArray[indexPath.row];
    cell.labelTitle.text = cellModel.title;
    cell.labelDetail.text = cellModel.value;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HeightHeadView*Ratio)];
    CGFloat iconWidth = 90*Ratio;
    CGFloat iconY = (HeightHeadView*Ratio - iconWidth)/2;
    CGFloat iconX = (SCREEN_WIDTH - iconWidth)/2;
    APPIconView *icon = [[APPIconView alloc] initWithFrame:[self dealGetFrameWithX:iconX Y:iconY Width:iconWidth Height:iconWidth]];
    [header addSubview:icon];
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UILabel *view = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HeightNanvi*Ratio)];
    view.text = @"版权2018 LET International Limited 版权所有";
    view.font = [UIFont systemFontOfSize:14];
    view.textColor = [UIColor blackColor];
    view.backgroundColor = ColorWhite;
    view.numberOfLines = 0;
    view.textAlignment = NSTextAlignmentCenter;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return HeightHeadView*Ratio;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return HeightNanvi *Ratio;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
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
