//
//  DeviceDetailViewController.m
//  MifiManager
//
//  Created by notion on 2018/3/28.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "DeviceDetailViewController.h"
#import "ImageContentTableViewCell.h"

#import "SendMessage.h"
//#define HeightHeadView SCREEN_HEIGHT*0.4
@interface DeviceDetailViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITextField *remark;
@end

@implementation DeviceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = Localized(@"deviceInfo");

    _dataArray = [[NSMutableArray alloc] init];
    [self loadMainView];
    [self loadData];
}

- (void)loadMainView{
    
    CGRect frame = [self dealGetFrameWithX:0 Y:HeightNanvi Width:SCREEN_WIDTH Height:SCREEN_HEIGHT-HeightNanvi];
    UITableView *tableView = [self dealSetTableViewWithCellHeight:HeightCellLarge *Ratio frame:frame bgColor:ColorClear delegate:self];
    [tableView registerNib:[UINib nibWithNibName:@"ImageContentTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];

    _tableView = tableView;
    [self.view addSubview:tableView];
    
}

- (void)loadData{
    
    _dataArray = [NSMutableArray arrayWithObjects:@{@"value":@"无备注",@"title":@"备注",@"icon":@"deviceNote"},
                  @{@"value":_deviceInfo.name,@"title":@"名称",@"icon":@"deviceName"},
                  @{@"value":_deviceInfo.mac,@"title":@"MAC地址",@"icon":@"deviceAddress"},
                  @{@"value":_deviceInfo.ipAddress,@"title":@"IP地址",@"icon":@"deviceIP"},
                  @{@"value":_deviceInfo.connType,@"title":@"连接类型",@"icon":@"设备类型"
                    },
                  @{@"value":_deviceInfo.connectTimeAt,@"title":@"连接时长",@"icon":@"deviceTime"}, nil];
    
    [_tableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HeightCell*Ratio;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ImageContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary *cellInfo = [_dataArray objectAtIndex:indexPath.row];
    cell.labelTitle.text = cellInfo[@"value"];
    [cell.labelTitle setColor:[UIColor colorWithHexString:ColorBlueDeep] font:FontRegular];
    cell.labelContent.text = cellInfo[@"title"];
    [cell.labelContent setColor:[UIColor colorWithHexString:ColorBlueNormal] font:FontNormal];
    cell.imageIcon.image = [UIImage imageNamed:cellInfo[@"icon"]];
    cell.line.backgroundColor = NormalGray;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        [self showAlertToChangeRemark];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
#pragma mark - 修改备注
- (void)showAlertToChangeRemark{
    WeakSelf;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否要修改备注？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *cancel){
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:cancel];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *confirm){
        [self mbShowToast:weakSelf.remark.text];
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"请输入备注名称";
        weakSelf.remark = textField;
        
    }];
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];
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

