//
//  PINViewController.m
//  MifiManager
//
//  Created by notion on 2018/4/25.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "PINViewController.h"
#import "NIPinPukModel.h"
#import "CPEInterfaceMain.h"
@interface PINViewController ()
@property (nonatomic, strong) NIPinPukModel *pin_puk;
@property (nonatomic, strong) CPESimStatus *pinModel;
@property (nonatomic, strong) UILabel *label ;
@end

@implementation PINViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self loadMainView];
    [self loadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotifyPINChange object:nil];
    // Do any additional setup after loading the view.
}

- (void)loadCPEData{
    WeakSelf;
    [CPEInterfaceMain getSimStatusSuccess:^(CPESimStatus *simStatus){
        weakSelf.pinModel = simStatus;
        NSString *tital = [NSString stringWithFormat:@"%@(%@%@%@)",@"请输入PIN码",@"还可尝试",simStatus.pinAttempts,@"次"];
        weakSelf.label.text = tital;
    } failure:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self mbShowToast:error.description];
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
    WeakSelf;
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
        weakSelf.pin_puk = pin_puk;
        NSString *tital = [NSString stringWithFormat:@"%@(%@%@%@)",@"请输入PIN码",@"还可尝试",pin_puk.pin_attempts,@"次"];
        weakSelf.label.text = tital;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self mbShowToast:error.localizedDescription];
    }];
}

- (void)uploadCPEPin:(NSString *)pin{
    WeakSelf;
    NSMutableString *request = [[NSMutableString alloc] initWithString:@"<sim>"];
    [request appendString:@"<pin_puk>"];
    [request appendFormat:@"<pin>%@</pin>",pin];
    [request appendString:@"</pin_puk>"];
    [request appendString:@"</sim>"];
    //若原来为1 则为disable 否则 enable
    NSString *pinEnable = [_pinModel.pinEnabled isEqualToString:@"1"]?@"disable_pin":@"enable_pin";
    NSMutableString *requestXML = [CPERequestXML getXMLWithPath:@"sim" method:pinEnable addXML:request];
    [CPEInterfaceMain uploadCommonWithRequestXML:requestXML Success:^(CPEResultCommonData *status){
        if ([status.status isEqualToString:CPEResultOK]) {
            if (status.pinAttempts.intValue == 3) {
                [self mbShowToast:@"操作成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:NotifyPINChange object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
//                NSString *cmd = [NSString stringWithFormat:@"PINCmdStatus%@",pin_puk.cmd_status];
//                [self mbShowToast:Localized(cmd)];
                NSString *tital = [NSString stringWithFormat:@"%@(%@%@%@)",@"请输入PIN码",@"还可尝试",status.pinAttempts,@"次"];
                weakSelf.label.text = tital;
            }
        }
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

- (void)uploadPin:(NSString *)pin{
    //若当前为好，则禁用 2
    //若当前禁用，则使能 1
    WeakSelf;
    NSInteger command = [_pin_puk.pin_enabled boolValue]?2:1;
    NSMutableString *requestXML = [NSMutableString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"US-ASCII\"?><RGW><pin_puk>"];
    [requestXML appendFormat:@"<command>%ld</command>",command];
    [requestXML appendFormat:@"<pin>%@</pin>",pin];
    [requestXML appendFormat:@"</pin_puk></RGW>"];
    NILog(@"requesetXml = %@", requestXML);
    NSString *url = [NSString stringWithFormat:@"%@", MIFI_SET_PIN_PUK_PATH];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NIHttpUtil post:url params:nil xmlString:requestXML success:^(AFHTTPRequestOperation *operation, id responseObj) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        BOOL check = [self checkLoginWithOperationResponse:operation.responseString];
        if (check) {
            [self showNeedRelogin];
            return ;
        }
        
        NIPinPukModel *pin_puk = [NIPinPukModel pinPukWithResponseXmlString:operation.responseString isRGWStartXml:YES];
        NSLog(@"%@",pin_puk);
        if ([pin_puk.cmd_status isEqualToString:@"0"] || [pin_puk.cmd_status isEqualToString:@"1"]) {
            [self mbShowToast:@"操作成功"];
            //                if (_block) {
            //                    _block([pin_puk.pin_enabled boolValue]);
            //                }
            [[NSNotificationCenter defaultCenter] postNotificationName:NotifyPINChange object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            if (pin_puk.cmd_status.intValue <= 28 && pin_puk.cmd_status.intValue >= 2) {
                NSString *cmd = [NSString stringWithFormat:@"PINCmdStatus%@",pin_puk.cmd_status];
                [self mbShowToast:Localized(cmd)];
            }
            NSString *tital = [NSString stringWithFormat:@"%@(%@%@%@)",@"请输入PIN码",@"还可尝试",pin_puk.pin_attempts,@"次"];
            weakSelf.label.text = tital;
//            textNew.text = @"";
//            textConfirm.text = @"";
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self mbShowToast:error.localizedDescription];
    }];
}

- (void)loadMainView{
    CGFloat originY = HeightNanvi+MarginY;
    UILabel *labelTop = [self dealSetLabelWithTitle:Localized(@"PINInput") color:[UIColor colorWithHexString:ColorBlueDeep] bgColor:ColorClear font:FontNormal textAlign:NSTextAlignmentCenter frame:[self dealGetFrameWithX:0 Y:originY Width:SCREEN_WIDTH Height:HeightLabel]];
    [self.view addSubview:labelTop];
    _label.textColor = [UIColor blackColor];
    _label = labelTop;
    
    CGFloat originX = 20;
    CGFloat cellHeight = HeightButton;
    
    UIView *enterView = [[UIView alloc] initWithFrame:[self dealGetFrameWithX:originX Y:VIEW_BOTTOM(labelTop)+MarginY Width:SCREEN_WIDTH-2*originX Height:cellHeight]];
    [self.view addSubview:enterView];
    
    UITextField *textNew = [[UITextField alloc] initWithFrame:[self dealGetFrameWithX:0 Y:0 Width:VIEW_WIDTH(enterView) Height:cellHeight]];
    [textNew setTitle:Localized(@"PINCode") imageArray:@[IMAGE(@"loginPswNormal"),IMAGE(@"loginPswPress")] secureText:YES selected:false];
    [self dealTextfield:textNew];
    [enterView addSubview:textNew];
    
    UITextField *textConfirm = [[UITextField alloc] initWithFrame:[self dealGetFrameWithX:0 Y:cellHeight Width:VIEW_WIDTH(enterView) Height:cellHeight]];
    [textConfirm setTitle:@"确认PIN码" imageArray:@[IMAGE(@"loginPswNormal"),IMAGE(@"loginPswPress")] secureText:YES selected:false];
    [self dealTextfield:textConfirm];
//    [enterView addSubview:textConfirm];
    
    [enterView setLayerWithBorderWidth:BorderWidth BorderColor:BorderColorGreen CornerRadius:BorderCircle];
//    [enterView setLinWithOriginX:0 originY:cellHeight color:BorderColorGreen];
    
    UIButton *button = [self dealSetButtonWithTitle:@"确定" color:[UIColor colorWithHexString:ColorBlueDeep] bgColor:ColorWhite font:FontRegular frame:[self dealGetFrameWithX:originX Y:VIEW_BOTTOM(enterView)+MarginY Width:SCREEN_WIDTH -2*originX Height:cellHeight] image:nil];
    [button setLayerWithBorderWidth:BorderWidth BorderColor:ColorWhite CornerRadius:BorderCircle];
    [self.view addSubview:button];
    [button addEvent:^(UIButton *btn){
        [textNew resignFirstResponder];
        [textConfirm resignFirstResponder];
        if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
            [self showWIFIAlert];
            return;
        }
        //|| textConfirm.text == nil
        if (textNew.text == nil || textConfirm.text.length == 0) {
            [self mbShowToast:@"PIN码不能为空"];
            return ;
        }
        if(textConfirm.text == nil || textConfirm.text.length == 0){
            return;
        }
//        else if (![textNew.text isEqualToString:textConfirm.text]){
//            [self mbShowToast:Localized(@"PINUnequal")];
//            return;
//        }
//        "<?xml version=\"1.0\" encoding=\"US-ASCII\"?>"
//        + "<RGW><pin_puk>" + "<command>" + command + "</command>"
//        + "<pin>" + pin + "</pin>" + "</pin_puk></RGW>"
        if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
            [self uploadCPEPin:textNew.text];
        }else{
            [self uploadPin:textNew.text];
        }
    }];
}

- (void)dealTextfield:(UITextField *)textfield{
    [textfield setClearButtonMode:UITextFieldViewModeWhileEditing];
    [textfield setTextColor:[UIColor blackColor]];
    [textfield setFont:FontRegular];
    [textfield setKeyboardType:UIKeyboardTypeNumberPad];
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
