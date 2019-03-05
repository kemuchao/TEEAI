//
//  PUKViewController.m
//  MifiManager
//
//  Created by notion on 2018/5/11.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "PUKViewController.h"
#import "NIPinPukModel.h"
#import "MoreViewController.h"
@interface PUKViewController ()
@property (nonatomic, strong) NIPinPukModel *pin_puk;
@property (nonatomic, strong) UILabel *label ;
@end

@implementation PUKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = Localized(@"MorePIN");
   
    [self loadMainView];
    [self loadData];
    // Do any additional setup after loading the view.
}
- (void)loadData{
    if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
        [self showWIFIAlert];
        return;
    }
    WeakSelf;
    NSString *pinPukUrl = [NSString stringWithFormat:@"%@", MIFI_PIN_PUK_PATH];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NIHttpUtil get:pinPukUrl params:nil success:^(AFHTTPRequestOperation *operation, id responseObj) {
        [self mbDismiss];
        BOOL check = [self checkLoginWithOperationResponse:operation.responseString];
        if (check) {
            [self showNeedRelogin];
            return ;
        }
        NIPinPukModel *pin_puk = [NIPinPukModel pinPukWithResponseXmlString:operation.responseString isRGWStartXml:YES];
        NSLog(@"%@",pin_puk);
        weakSelf.pin_puk = pin_puk;
        NSString *tital = [NSString stringWithFormat:@"%@(%@%@%@)",Localized(@"PUKInput"),Localized(@"PINAttemptNumber"),pin_puk.puk_attempts,Localized(@"PINAttemptTrail")];
        weakSelf.label.text = tital;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self mbDismiss];
        [self mbShowToast:error.localizedDescription];
    }];
}
- (void)loadMainView{
    CGFloat originY = HeightNanvi+MarginY;
    UILabel *labelTop = [self dealSetLabelWithTitle:Localized(@"PUKInput") color:[UIColor colorWithHexString:ColorBlueDeep] bgColor:ColorClear font:FontNormal textAlign:NSTextAlignmentCenter frame:[self dealGetFrameWithX:0 Y:originY Width:SCREEN_WIDTH Height:HeightLabel]];
    [self.view addSubview:labelTop];
    _label = labelTop;
    
    CGFloat originX = 20;
    CGFloat cellHeight = HeightButton;
    UITextField *textNow = [[UITextField alloc] initWithFrame:[self dealGetFrameWithX:originX Y:VIEW_BOTTOM(labelTop)+MarginY Width:SCREEN_WIDTH - 2*originX Height:cellHeight]];
    [textNow setTitle:Localized(@"PUKCurrent") imageArray:nil secureText:false selected:false];
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
    WeakSelf;
    [button addEvent:^(UIButton *btn){
        if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
            [self showWIFIAlert];
            return;
        }
        if (textNow.text == nil) {
            [self mbShowToast:Localized(@"PUKEmpty")];
            return ;
        }else if (textNew.text == nil || textConfirm.text == nil) {
            [self mbShowToast:Localized(@"PINEmpty")];
            return ;
        }else if (![textNew.text isEqualToString:textConfirm.text]){
            [self mbShowToast:Localized(@"PINUnequal")];
            return;
        }
        NSMutableString *requestXML = [NSMutableString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"US-ASCII\"?>"];
        [requestXML appendString:@"<RGW><pin_puk><command>3</command>"];
        [requestXML appendFormat:@"<puk>%@</puk>",textNow.text];
        [requestXML appendFormat:@"<new_pin>%@</new_pin>",textNew.text];
        [requestXML appendFormat:@"</pin_puk></RGW>"];
        NILog(@"requesetXml = %@", requestXML);
        NSString *url = [NSString stringWithFormat:@"%@", MIFI_SET_PIN_PUK_PATH];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [NIHttpUtil post:url params:nil xmlString:requestXML success:^(AFHTTPRequestOperation *operation, id responseObj) {
            [self mbDismiss];
            BOOL check = [self checkLoginWithOperationResponse:operation.responseString];
            if (check) {
                [self showNeedRelogin];
                return ;
            }
            NIPinPukModel *pin_puk = [NIPinPukModel pinPukWithResponseXmlString:operation.responseString isRGWStartXml:YES];
            NSLog(@"%@",pin_puk);
            if ([pin_puk.cmd_status isEqualToString:@"0"] || [pin_puk.cmd_status isEqualToString:@"1"]) {
                [self mbShowToast:Localized(@"PINCmdStatus0")];
                [[NSNotificationCenter defaultCenter] postNotificationName:NotifyRefreshName object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                if (pin_puk.cmd_status.intValue <= 28 && pin_puk.cmd_status.intValue >= 2) {
                    NSString *cmd = [NSString stringWithFormat:@"PINCmdStatus%@",pin_puk.cmd_status];
                    [self mbShowToast:Localized(cmd)];
                }
                NSString *tital = [NSString stringWithFormat:@"%@(%@%@%@)",Localized(@"PINInput"),Localized(@"PINAttemptNumber"),pin_puk.puk_attempts,Localized(@"PINAttemptTrail")];
                weakSelf.label.text = tital;
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self mbDismiss];
            [self mbShowToast:error.localizedDescription];
        }];
    }];
}

- (void)dealTextfield:(UITextField *)textfield{
    [textfield setClearButtonMode:UITextFieldViewModeWhileEditing];
    [textfield setTextColor:ColorWhite];
    [textfield setFont:FontRegular];
    [textfield setKeyboardType:UIKeyboardTypeNumberPad];
}
#pragma mark - 重新返回
- (void)goBack{
    BOOL hasMobileViewCotrol = NO;
    for (UIViewController *viewControl in self.navigationController.viewControllers) {
        if ([viewControl isKindOfClass:[MoreViewController class]]) {
            hasMobileViewCotrol = YES;
            [self.navigationController popToViewController:viewControl animated:YES];
            break;
        }
    }
    if (hasMobileViewCotrol == NO) {
        [self.navigationController popToRootViewControllerAnimated:YES];
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
