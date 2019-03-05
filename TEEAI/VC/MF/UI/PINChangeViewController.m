//
//  PINChangeViewController.m
//  MifiManager
//
//  Created by notion on 2018/4/25.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "PINChangeViewController.h"
#import "NIPinPukModel.h"
#import "CPEInterfaceMain.h"
@interface PINChangeViewController ()
@property (nonatomic, strong) NIPinPukModel *pin_puk;
@property (nonatomic, strong) CPESimStatus *pinModel;
@property (nonatomic, strong) UILabel *label ;
@end

@implementation PINChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
   
    [self loadMainView];
    [self loadData];
    // Do any additional setup after loading the view.
}
#pragma mark - CPE
- (void)loadCPEData{
    WeakSelf;
    [CPEInterfaceMain getSimStatusSuccess:^(CPESimStatus *simStatus){
        weakSelf.pinModel = simStatus;
        NSString *tital = [NSString stringWithFormat:@"%@(%@%@%@)",Localized(@"PINInput"),Localized(@"PINAttemptNumber"),simStatus.pinAttempts,Localized(@"PINAttemptTrail")];
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
- (void)uploadCPEOld:(NSString *)old new:(NSString *)new{
    NSMutableString *request = [[NSMutableString alloc] initWithString:@"<sim>"];
    [request appendString:@"<pin_puk>"];
    [request appendFormat:@"<pin>%@</pin>",old];
    [request appendFormat:@"<new_pin>%@</new_pin>",new];
    [request appendString:@"</pin_puk>"];
    [request appendString:@"</sim>"];
    NSMutableString *requestXML = [CPERequestXML getXMLWithPath:@"sim" method:@"change_pin" addXML:request];
    WeakSelf;
    [CPEInterfaceMain uploadCommonWithRequestXML:requestXML Success:^(CPEResultCommonData *status){
        if ([status.status isEqualToString:CPEResultOK]) {
            if (status.pinAttempts.intValue == 3) {
                [self mbShowToast:Localized(@"PINCmdStatus0")];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                //                NSString *cmd = [NSString stringWithFormat:@"PINCmdStatus%@",pin_puk.cmd_status];
                //                [self mbShowToast:Localized(cmd)];
                NSString *tital = [NSString stringWithFormat:@"%@(%@%@%@)",Localized(@"PINInput"),Localized(@"PINAttemptNumber"),status.pinAttempts,Localized(@"PINAttemptTrail")];
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

#pragma mark - 1802

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
        NSString *tital = [NSString stringWithFormat:@"%@(%@%@%@)",Localized(@"PINInput"),Localized(@"PINAttemptNumber"),pin_puk.pin_attempts,Localized(@"PINAttemptTrail")];
        weakSelf.label.text = tital;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self mbShowToast:error.localizedDescription];
    }];
}

- (void)uploadPinOld:(NSString *)old new:(NSString *)new{
    WeakSelf;
    NSMutableString *requestXML = [NSMutableString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"US-ASCII\"?>"];
    [requestXML appendString:@"<RGW><pin_puk><command>3</command>"];
    [requestXML appendFormat:@"<pin>%@</pin>",old];
    [requestXML appendFormat:@"<new_pin>%@</new_pin>",new];
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
            [self mbShowToast:Localized(@"PINCmdStatus0")];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            if (pin_puk.cmd_status.intValue <= 28 && pin_puk.cmd_status.intValue >= 2) {
                NSString *cmd = [NSString stringWithFormat:@"PINCmdStatus%@",pin_puk.cmd_status];
                [self mbShowToast:Localized(cmd)];
            }
            NSString *tital = [NSString stringWithFormat:@"%@(%@%@%@)",Localized(@"PINInput"),Localized(@"PINAttemptNumber"),pin_puk.pin_attempts,Localized(@"PINAttemptTrail")];
            weakSelf.label.text = tital;
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
    _label = labelTop;
    
    CGFloat originX = 20;
    CGFloat cellHeight = HeightButton;
    UITextField *textNow = [[UITextField alloc] initWithFrame:[self dealGetFrameWithX:originX Y:VIEW_BOTTOM(labelTop)+MarginY Width:SCREEN_WIDTH - 2*originX Height:cellHeight]];
    [textNow setTitle:Localized(@"PINCurrent") imageArray:@[IMAGE(@"loginPswNormal"),IMAGE(@"loginPswPress")] secureText:YES selected:false];
    [textNow setLayerWithBorderWidth:BorderWidth BorderColor:BorderColorGreen CornerRadius:BorderCircle];
    [self dealTextfield:textNow];
    [self.view addSubview:textNow];
    
    UIView *enterView = [[UIView alloc] initWithFrame:[self dealGetFrameWithX:originX Y:VIEW_BOTTOM(textNow)+MarginY Width:SCREEN_WIDTH-2*originX Height:cellHeight*2]];
    [self.view addSubview:enterView];
    
    UITextField *textNew = [[UITextField alloc] initWithFrame:[self dealGetFrameWithX:0 Y:0 Width:VIEW_WIDTH(enterView) Height:cellHeight]];
    [textNew setTitle:Localized(@"PINNew") imageArray:@[IMAGE(@"loginPswNormal"),IMAGE(@"loginPswPress")] secureText:YES selected:false];
    [self dealTextfield:textNew];
    [enterView addSubview:textNew];
    
    UITextField *textConfirm = [[UITextField alloc] initWithFrame:[self dealGetFrameWithX:0 Y:cellHeight Width:VIEW_WIDTH(enterView) Height:cellHeight]];
    [textConfirm setTitle:Localized(@"PINConfirm") imageArray:@[IMAGE(@"loginPswNormal"),IMAGE(@"loginPswPress")] secureText:YES selected:false];
    [self dealTextfield:textConfirm];
    [enterView addSubview:textConfirm];
    
    [enterView setLayerWithBorderWidth:BorderWidth BorderColor:BorderColorGreen CornerRadius:BorderCircle];
    [enterView setLinWithOriginX:0 originY:cellHeight color:BorderColorGreen];
    
    UIButton *button = [self dealSetButtonWithTitle:Localized(@"confirm") color:[UIColor colorWithHexString:ColorBlueDeep] bgColor:ColorWhite font:FontRegular frame:[self dealGetFrameWithX:originX Y:VIEW_BOTTOM(enterView)+MarginY Width:SCREEN_WIDTH -2*originX Height:cellHeight] image:nil];
    [button setLayerWithBorderWidth:BorderWidth BorderColor:ColorWhite CornerRadius:BorderCircle];
    [self.view addSubview:button];
    [button addEvent:^(UIButton *btn){
        if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
            [self showWIFIAlert];
            return;
        }
        if (textNew.text.length == 0 || textNow.text.length == 0 || textConfirm.text.length == 0) {
            [self mbShowToast:Localized(@"PINEmpty")];
            return ;
        }else if ([textNew.text isEqualToString:textNow.text]){
            [self mbShowToast:Localized(@"PINEqual")];
            return;
        }else if (![textNew.text isEqualToString:textConfirm.text]){
            [self mbShowToast:Localized(@"PINUnequal")];
            return;
        }
        if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
            [self uploadCPEOld:textNow.text new:textNew.text];
        }else{
            [self uploadPinOld:textNow.text new:textNew.text];
        }
    }];
}

- (void)dealTextfield:(UITextField *)textfield{
    [textfield setClearButtonMode:UITextFieldViewModeWhileEditing];
    [textfield setTextColor:ColorWhite];
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
