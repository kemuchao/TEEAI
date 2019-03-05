//
//  PINManagerViewController.m
//  MifiManager
//
//  Created by notion on 2018/4/25.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "PINManagerViewController.h"
#import "ContentTableViewCell.h"
#import "ContentDetailTableViewCell.h"
#import "SwitchTypeTwoTableViewCell.h"

#import "NISelectModel.h"

#import "PINViewController.h"
#import "PINChangeViewController.h"
#import "PUKViewController.h"//PUK界面
#import "NIPinPukModel.h"
#import "CPEInterfaceMain.h"
@interface PINManagerViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation PINManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
   
    [self initData];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:NotifyPINChange object:nil];
    // Do any additional setup after loading the view.
}

- (void)loadCPEData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CPEInterfaceMain getSimStatusSuccess:^(CPESimStatus *simStatus){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([simStatus.pinStatus isEqualToString:@"1"]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"PIN错误" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确认PIN码" style:UIAlertActionStyleDefault handler:^(UIAlertAction *ok){
                [self goBack];
            }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            return ;
        }
        [self loadDataWithBool:simStatus.pinEnabled.boolValue];
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
- (void)loadData{
    if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
        [self showWIFIAlert];
        return;
    }
    if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
        [self loadCPEData];
        return;
    }
    NSString *pinPukUrl = [NSString stringWithFormat:@"%@", MIFI_PIN_PUK_PATH];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NIHttpUtil get:pinPukUrl params:nil success:^(AFHTTPRequestOperation *operation, id responseObj) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        BOOL check = [self checkLoginWithOperationResponse:operation.responseString];
        if (check) {
            [self showNeedRelogin];
            return ;
        }
        NIPinPukModel *pin_puk = [NIPinPukModel pinPukWithResponseXmlString:operation.responseString isRGWStartXml:YES];
        NSLog(@"%@",pin_puk);
        
        if ([pin_puk.cmd_status isEqualToString:@"0"] || [pin_puk.cmd_status isEqualToString:@"1"]) {
//            [self mbShowToast:Localized(@"PINCmdStatus0")];
            [self loadDataWithBool:[pin_puk.pin_enabled boolValue]];
        }else if ([pin_puk.cmd_status isEqualToString:@"7"]){
            [self dealShowPUK];
        }else{
            if (pin_puk.cmd_status.intValue <= 28 && pin_puk.cmd_status.intValue >= 2) {
//                NSString *cmd = [NSString stringWithFormat:@"PINCmdStatus%@",pin_puk.cmd_status];
//                [self mbShowToast:Localized(cmd)];
                switch ([pin_puk.cmd_status intValue]) {
                    case 0:
                        [self mbShowToast:@"操作成功"];
                        break;
                    case 1:
                        [self mbShowToast:@"操作成功"];
                        break;
                    case 2:
                        [self mbShowToast:@"SIM失败"];
                        break;
                    case 3:
                        [self mbShowToast:@"存储问题"];
                        break;
                    case 4:
                        [self mbShowToast:@"SIMAT忙碌"];
                        break;
                    case 5:
                        [self mbShowToast:@"SIM缺失"];
                        break;
                    case 6:
                        [self mbShowToast:@"需要输入SIM PIN"];
                        break;
                    case 7:
                        [self mbShowToast:@"需要输入SIM PUK"];
                        break;
                    case 8:
                        [self mbShowToast:@"SIM忙碌"];
                        break;
                    case 9:
                        [self mbShowToast:@"SIM出错"];
                        break;
                    case 10:
                        [self mbShowToast:@"PIN密码错误"];
                        break;
                    case 11:
                        [self mbShowToast:@"需要输入PIN码"];
                        break;
                    case 12:
                        [self mbShowToast:@"需要输入PUK码"];
                        break;
                    case 13:
                        [self mbShowToast:@"操作非法"];
                        break;
                    case 14:
                        [self mbShowToast:@"存储已满"];
                        break;
                    case 15:
                        [self mbShowToast:@"SIM未知问题"];
                        break;
                    case 16:
                        [self mbShowToast:@"操作失败，个性化定制无效导致"];
                        break;
                    case 17:
                        [self mbShowToast:@"操作失败，个性化定制锁定导致"];
                        break;
                    case 18:
                        [self mbShowToast:@"操作失败，个性化定制不支持"];
                        break;
                    case 19:
                        [self mbShowToast:@"卡禁入"];
                        break;
                    case 20:
                        [self mbShowToast:@"卡关机"];
                        break;
                    case 21:
                        [self mbShowToast:@"卡已移除"];
                        break;
                    case 22:
                        [self mbShowToast:@"卡充电"];
                        break;
                    case 23:
                        [self mbShowToast:@"卡不支持"];
                        break;
                    case 24:
                        [self mbShowToast:@"参数非法"];
                        break;
                    case 25:
                        [self mbShowToast:@"请求非法"];
                        break;
                    case 26:
                        [self mbShowToast:@"SIM未就位"];
                        break;
                    case 27:
                        [self mbShowToast:@"接通拒绝"];
                        break;
                    case 28:
                        [self mbShowToast:@"请求非法，字符串过长"];
                        break;
                    default:
                        break;
                }
            }
        }
        if (pin_puk.pin_enabled.floatValue < 0){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"PIN错误" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *ok){
                [self goBack];
            }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self mbShowToast:error.localizedDescription];
    }];
}

/**
 初始化数据
 */
- (void)initData{
    NSArray *sectionOne = @[[NISelectModel setTitle:@"锁定SIM卡" value:[NSNumber numberWithBool:false]]];
    _dataArray = [NSMutableArray arrayWithObject:sectionOne];
    [_tableView reloadData];
}

- (void)dealSwitch:(UISwitch *)sender{
//    NISelectModel *pinModel = _dataArray[0][0];
//    BOOL isOn = [pinModel.value boolValue];
//    if (isOn == false) {
//
//    }
//    [self loadDataWithBool:!isOn];
    PINViewController *pin = [PINViewController new];
    pin.title = self.title;
    pin.block = ^(BOOL pinEnabled){
        [self loadDataWithBool:pinEnabled];
    };
    [self.navigationController pushViewController:pin animated:YES];
}

- (void)loadDataWithBool:(BOOL)isON{
    NSArray *sectionOne = @[[NISelectModel setTitle:@"锁定SIM卡" value:[NSNumber numberWithBool:isON]]];
    
    NSArray *sectionTwo = @[[NISelectModel setTitle:@"修改PIN码" value:nil]];
    _dataArray = [NSMutableArray array];
    [_dataArray addObject:sectionOne];
    if (isON) {
        [_dataArray addObject:sectionTwo];
    }
    [_tableView reloadData];
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
    NISelectModel *cellData = _dataArray[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        SwitchTypeTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchTypeTwoTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *title = cellData.title;
        cell.labelTitle.text = title;
        [cell.labelTitle setColor:[UIColor colorWithHexString:ColorBlueDeep] font:FontRegular];
        cell.labelDetail.text = @"需要输入PIN才能使用";
        [cell.labelDetail setColor:[UIColor colorWithHexString:ColorBlueNormal] font:FontDetail];
        [cell.Switch setOn:[cellData.value boolValue]];
        [cell.Switch addTarget:self action:@selector(dealSwitch:) forControlEvents:UIControlEventTouchUpInside];
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
    return [_dataArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_dataArray objectAtIndex:section] count];
}
#pragma mark - 点击跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self dealSwitch:nil];
    }else{
        PINChangeViewController *pin = [PINChangeViewController new];
        pin.title = Localized(@"PINChange");
        [self.navigationController pushViewController:pin animated:YES];
    }
}


#pragma mark - PUK
- (void)dealShowPUK{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"PIN码不可用，需要输入PUK码来开启PIN" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *cancel){
        [self goBack];
    }];
    [alert addAction:cancel];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        PUKViewController *puk = [PUKViewController new];
        
        [self.navigationController pushViewController:puk animated:YES];
    }];
   
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];
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
