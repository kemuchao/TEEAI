//
//  APNDefaultViewController.m
//  MifiManager
//
//  Created by notion on 2018/4/25.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "APNDefaultViewController.h"
#import "SelectTypeView.h"
#import "NIPdpSupportedListItemModel.h"
#import "NISelectView.h"
#import "NISelectModel.h"
#import "ActionView.h"
#import "NINodeModel.h"
#import "CPEInterfaceMain.h"
#import "MoreViewController.h"
@interface APNDefaultViewController ()
@property (nonatomic, strong) SelectTypeView *ipType;
@property (nonatomic, strong) SelectTypeView *authType;

@end

@implementation APNDefaultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self loadData];
    
    // Do any additional setup after loading the view.
}

- (void)loadCPEData{
    WeakSelf;
    CGFloat originX = 20;
    CGFloat originY = HeightNanvi + MarginY;
    CGFloat cellHeight = HeightCell*Ratio;
    CGFloat cellWidth = SCREEN_WIDTH - 2*originX;
    CGFloat viewHeight = cellHeight*6;
    UIView *mainView = [[UIView alloc] initWithFrame:[self dealGetFrameWithX:originX Y:originY Width:SCREEN_WIDTH - 2*originX Height:viewHeight]];
    [mainView setLayerWithBorderWidth:BorderWidth BorderColor:BorderColorGreen CornerRadius:BorderCircle];
    [mainView setBackgroundColor:[UIColor colorWithHexString:ColorGreenLight]];
    [self.view addSubview:mainView];
    
    //name
    UITextField *name = [[UITextField alloc] initWithFrame:[self dealGetFrameWithX:0 Y:0 Width:cellWidth Height:cellHeight]];
    [mainView addSubview:name];
    [name setText:@"Default APN"];
    [name setTitle:@"名称" imageArray:nil secureText:false selected:false];
    name.text = _apnModel.apnFileName;
    [self dealTextfield:name];
//    [name setUserInteractionEnabled:false];
    //APN
    UITextField *APN = [[UITextField alloc] initWithFrame:[self dealGetFrameWithX:0 Y:cellHeight Width:cellWidth Height:cellHeight]];
    [mainView addSubview:APN];
    [APN setTitle:Localized(@"APN") imageArray:nil secureText:false selected:false];
    [self dealTextfield:APN];
    APN.text = _apnModel.apn;
    //IPType
    UITextField *IPType = [[UITextField alloc] initWithFrame:[self dealGetFrameWithX:0 Y:cellHeight*2 Width:cellWidth Height:cellHeight]];
    [mainView addSubview:IPType];
    [IPType setTitle:@"IP类型" imageArray:nil secureText:false selected:false];
    [self dealTextfield:IPType];
    [IPType setUserInteractionEnabled:false];
    SelectTypeView *ipType = [[SelectTypeView alloc] initWithFrame:IPType.frame title:nil value:IPType0];
    _ipType = ipType;
    [mainView addSubview:ipType];
    [ipType resetValue:[self getIPTypeWithType:_apnModel.ipType.integerValue]];
    [ipType.button addEvent:^(UIButton *btn){
        [self dealShowIPType];
    }];
    
    //AuthType
    UITextField *AuthType = [[UITextField alloc] initWithFrame:[self dealGetFrameWithX:0 Y:cellHeight*3 Width:cellWidth Height:cellHeight]];
    [mainView addSubview:AuthType];
    [AuthType setTitle:@"鉴权类型" imageArray:nil secureText:false selected:false];
    [self dealTextfield:AuthType];
    [AuthType setUserInteractionEnabled:false];
    SelectTypeView *AuthTypeSelect = [[SelectTypeView alloc] initWithFrame:AuthType.frame title:nil value:IPType0];
    _authType = AuthTypeSelect;
    [mainView addSubview:AuthTypeSelect];
    
    [AuthTypeSelect resetValue:_apnModel.authtype2g3g];
    [AuthTypeSelect.button addEvent:^(UIButton *btn){
        [self dealShowAuthType];
    }];
    
    //用户名
    UITextField *UserName = [[UITextField alloc] initWithFrame:[self dealGetFrameWithX:0 Y:cellHeight*4 Width:cellWidth Height:cellHeight]];
    [mainView addSubview:UserName];
    [self dealTextfield:UserName];
    [UserName setTitle:@"用户名" imageArray:nil secureText:false selected:false];
    [UserName setText:_apnModel.usr2g3g];
    //密码
    UITextField *UserPSW = [[UITextField alloc] initWithFrame:[self dealGetFrameWithX:0 Y:cellHeight*5 Width:cellWidth Height:cellHeight]];
    [mainView addSubview:UserPSW];
    [self dealTextfield:UserPSW];
    [UserPSW setTitle:@"密码" imageArray:@[IMAGE(@"loginPswNormal"),IMAGE(@"loginPswPress")] secureText:YES selected:false];
    [UserPSW setText:_apnModel.pswd2g3g];
    
    for (int i = 1; i<6; i++) {
        [mainView setLinWithOriginX:0 originY:i*cellHeight color:BorderColorGreen];
    }
    //确定按钮
    UIButton *button = [self dealSetButtonWithTitle:@"确定" color:[UIColor colorWithHexString:ColorBlueDeep] bgColor:ColorWhite font:FontLarge frame:[self dealGetFrameWithX:VIEW_X(mainView) Y:VIEW_BOTTOM(mainView)+MarginY Width:VIEW_WIDTH(mainView) Height:cellHeight] image:nil];
    [button setLayerWithBorderWidth:BorderWidth BorderColor:ColorWhite CornerRadius:BorderCircle];
    [button addEvent:^(UIButton *btn){
        [self.view resignFirstResponder];
        if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
            [self showWIFIAlert];
            return;
        }
        if (APN.text.length == 0 || [APN.text isEqualToString:@""]) {
            //APN名称为空
            [self mbShowToast:@"APN名称不能为空"];
            [APN becomeFirstResponder];
            return;
        }
        if ([UserName.text isEqualToString:@""] || UserName.text.length == 0) {
            //用户名为空
            [self mbShowToast:@"用户名不能为空"];
            [UserName becomeFirstResponder];
            return;
        }
        if ([UserPSW.text isEqualToString:@""] || UserPSW.text.length == 0) {
            //密码为空
            [self mbShowToast:@"密码不能为空"];
            [UserPSW becomeFirstResponder];
            return;
        }
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        if (weakSelf.apnModel) {
            NSMutableString *request = [[NSMutableString alloc] initWithString:@"<wan>"];
            [request appendString:@"<profile>"];
            [request appendFormat:@"<profile_name>%@</profile_name>",name.text];
            //若新增则为 4
            //若修改为  6
            NSInteger action = weakSelf.apnModel?6:4;
            [request appendFormat:@"<action>%d</action>",(int)action];
            [request appendString:@"</profile>"];
            
            [request appendString:@"<pdp_info>"];
            [request appendFormat:@"<pswd_2g3g>%@</pswd_2g3g>",UserPSW.text];
            [request appendFormat:@"<usr_2g3g>%@</usr_2g3g>",UserName.text];
            [request appendFormat:@"<apn>%@</apn>",APN.text];
            [request appendFormat:@"<ip_type>%ld</ip_type>",(long)[weakSelf getTypeWithIPTyep:ipType.labelValue.text]];
            [request appendString:@"</pdp_info>"];
            [request appendString:@"</wan>"];
            NSString *requestXML = [CPERequestXML getXMLWithPath:@"cm" method:@"configs_handler" addXML:request];
            [CPEInterfaceMain uploadCommonWithRequestXML:requestXML Success:^(CPEResultCommonData *resultData){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if ([resultData.status isEqualToString:CPEResultOK]) {
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
            } failure:^(NSError *error){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self mbShowToast:error.localizedDescription];
            } errorCause:^(NSString *errorCause){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if ([errorCause isEqualToString:CPEResultNeedLogin]) {
                    [self showNeedRelogin];
                }
            }];
        }else{
            NSMutableString *check = [[NSMutableString alloc] initWithFormat:@"<wan>"];
            [check appendFormat:@"<profile><profile_name>%@</profile_name><action>1</action></profile>",name.text];
            [check appendString:@"</wan>"];
            NSMutableString *checkXML = [CPERequestXML getXMLWithPath:@"cm" method:@"configs_handler" addXML:check];
            [CPEInterfaceMain uploadCommonWithRequestXML:checkXML Success:^(CPEResultCommonData *resultDB){
                if ([resultDB.status isEqualToString:CPEResultOK]) {
                    NSMutableString *request = [[NSMutableString alloc] initWithString:@"<wan>"];
                    [request appendString:@"<profile>"];
                    [request appendFormat:@"<profile_name>%@</profile_name>",name.text];
                    //若新增则为 4
                    //若修改为  6
                    NSInteger action = weakSelf.apnModel?6:4;
                    [request appendFormat:@"<action>%d</action>",(int)action];
                    [request appendString:@"</profile>"];
                    
                    [request appendString:@"<pdp_info>"];
                    [request appendFormat:@"<pswd_2g3g>%@</pswd_2g3g>",UserPSW.text];
                    [request appendFormat:@"<usr_2g3g>%@</usr_2g3g>",UserName.text];
                    [request appendFormat:@"<apn>%@</apn>",APN.text];
                    [request appendFormat:@"<ip_type>%ld</ip_type>",(long)[weakSelf getTypeWithIPTyep:ipType.labelValue.text]];
                    [request appendString:@"</pdp_info>"];
                    [request appendString:@"</wan>"];
                    
                    
                    NSString *requestXML = [CPERequestXML getXMLWithPath:@"cm" method:@"configs_handler" addXML:request];
                    [CPEInterfaceMain uploadCommonWithRequestXML:requestXML Success:^(CPEResultCommonData *resultData){
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        if ([resultData.status isEqualToString:CPEResultOK]) {
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
       
    }];
    [self.view addSubview:button];
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@", MIFI_WAN_GET_PATH];
    [NIHttpUtil get:url params:nil success:^(AFHTTPRequestOperation *operation, id responseObj) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NILog(@"loadData operation.responseString = %@",operation.responseString);
        BOOL check = [self checkLoginWithOperationResponse:operation.responseString];
        if (check) {
            [self showNeedRelogin];
            return ;
        }
        NIWanModel *wan = [NIWanModel wanWithResponseXmlString:operation.responseString isRGWStartXml:YES];
        [self loadMainViewWithWanModel:wan];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self mbShowToast:error.localizedDescription];
    }];
}
- (void)loadMainViewWithWanModel:(NIWanModel *)wanModel{
    NSArray <NIPdpSupportedListItemModel *>*APNArray = wanModel.cellular.pdp_supported_list;
    NIPdpSupportedListItemModel *cellModel = APNArray[0];
    for (NIPdpSupportedListItemModel *cellData in APNArray) {
        NSInteger index = [APNArray indexOfObject:cellData];
        if ([cellData.pdefault isEqualToString:@"1"]) {
            cellModel = APNArray[index];
        }
    }
    
    CGFloat originX = 20;
    CGFloat originY = HeightNanvi + MarginY;
    CGFloat cellHeight = HeightCell*Ratio;
    CGFloat cellWidth = SCREEN_WIDTH - 2*originX;
    CGFloat viewHeight = cellHeight*6;
    UIView *mainView = [[UIView alloc] initWithFrame:[self dealGetFrameWithX:originX Y:originY Width:SCREEN_WIDTH - 2*originX Height:viewHeight]];
    [mainView setLayerWithBorderWidth:BorderWidth BorderColor:BorderColorGreen CornerRadius:BorderCircle];
    [mainView setBackgroundColor:[UIColor colorWithHexString:ColorGreenLight]];
    [self.view addSubview:mainView];
    
    //name
    UITextField *name = [[UITextField alloc] initWithFrame:[self dealGetFrameWithX:0 Y:0 Width:cellWidth Height:cellHeight]];
    [mainView addSubview:name];
    [name setText:@"Default APN"];
    [name setTitle:@"名称" imageArray:nil secureText:false selected:false];
    name.text = cellModel.rulename;
    [self dealTextfield:name];
    [name setUserInteractionEnabled:false];
    //APN
    UITextField *APN = [[UITextField alloc] initWithFrame:[self dealGetFrameWithX:0 Y:cellHeight Width:cellWidth Height:cellHeight]];
    [mainView addSubview:APN];
    [APN setTitle:Localized(@"APN") imageArray:nil secureText:false selected:false];
    [self dealTextfield:APN];
    APN.text = cellModel.apn;
    //IPType
    UITextField *IPType = [[UITextField alloc] initWithFrame:[self dealGetFrameWithX:0 Y:cellHeight*2 Width:cellWidth Height:cellHeight]];
    [mainView addSubview:IPType];
    [IPType setTitle:@"IP类型" imageArray:nil secureText:false selected:false];
    [self dealTextfield:IPType];
    [IPType setUserInteractionEnabled:false];
    SelectTypeView *ipType = [[SelectTypeView alloc] initWithFrame:IPType.frame title:nil value:IPType0];
    _ipType = ipType;
    [mainView addSubview:ipType];
    [ipType resetValue:[self getIPTypeWithType:cellModel.iptype.integerValue]];
    [ipType.button addEvent:^(UIButton *btn){
        [self dealShowIPType];
    }];
    
    //AuthType
    UITextField *AuthType = [[UITextField alloc] initWithFrame:[self dealGetFrameWithX:0 Y:cellHeight*3 Width:cellWidth Height:cellHeight]];
    [mainView addSubview:AuthType];
    [AuthType setTitle:@"鉴权类型" imageArray:nil secureText:false selected:false];
    [self dealTextfield:AuthType];
    [AuthType setUserInteractionEnabled:false];
    SelectTypeView *AuthTypeSelect = [[SelectTypeView alloc] initWithFrame:AuthType.frame title:nil value:IPType0];
    _authType = AuthTypeSelect;
    [mainView addSubview:AuthTypeSelect];
    
    [AuthTypeSelect resetValue:cellModel.authtype4g];
    [AuthTypeSelect.button addEvent:^(UIButton *btn){
        [self dealShowAuthType];
    }];
    
    //用户名
    UITextField *UserName = [[UITextField alloc] initWithFrame:[self dealGetFrameWithX:0 Y:cellHeight*4 Width:cellWidth Height:cellHeight]];
    [mainView addSubview:UserName];
    [self dealTextfield:UserName];
    [UserName setTitle:@"用户名" imageArray:nil secureText:false selected:false];
    [UserName setText:cellModel.usr4g];
    //密码
    UITextField *UserPSW = [[UITextField alloc] initWithFrame:[self dealGetFrameWithX:0 Y:cellHeight*5 Width:cellWidth Height:cellHeight]];
    [mainView addSubview:UserPSW];
    [self dealTextfield:UserPSW];
    [UserPSW setTitle:@"密码" imageArray:@[IMAGE(@"loginPswNormal"),IMAGE(@"loginPswPress")] secureText:YES selected:false];
    [UserPSW setText:cellModel.paswd4g];
    
    for (int i = 1; i<6; i++) {
        [mainView setLinWithOriginX:0 originY:i*cellHeight color:BorderColorGreen];
    }
    //确定按钮
    UIButton *button = [self dealSetButtonWithTitle:@"确定" color:[UIColor colorWithHexString:ColorBlueDeep] bgColor:ColorWhite font:FontLarge frame:[self dealGetFrameWithX:VIEW_X(mainView) Y:VIEW_BOTTOM(mainView)+MarginY Width:VIEW_WIDTH(mainView) Height:cellHeight] image:nil];
    [button setLayerWithBorderWidth:BorderWidth BorderColor:ColorWhite CornerRadius:BorderCircle];
    [button addEvent:^(UIButton *btn){
        [self.view resignFirstResponder];
        if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
            [self showWIFIAlert];
            return;
        }
        if (APN.text.length == 0 || [APN.text isEqualToString:@""]) {
            //APN名称为空
            [self mbShowToast:@"APN名称不能为空"];
            [APN becomeFirstResponder];
            return;
        }
        if ([UserName.text isEqualToString:@""] || UserName.text.length == 0) {
            //用户名为空
            [self mbShowToast:@"用户名不能为空"];
            [UserName becomeFirstResponder];
            return;
        }
        if ([UserPSW.text isEqualToString:@""] || UserPSW.text.length == 0) {
            //密码为空
            [self mbShowToast:@"密码不能为空"];
            [UserPSW becomeFirstResponder];
            return;
        }
        NSMutableString *requestStr = [NSMutableString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"US-ASCII\"?> <RGW><wan><cellular><pdp_supported_list><Item index=\"0\">"];
        [requestStr appendFormat:@"<rulename>%@</rulename>",name.text];
        [requestStr appendString:@"<connnum>1</connnum><pconnnum>NA</pconnnum><enable>1</enable><conntype>0</conntype><default>1</default><secondary>1</secondary>"];
        [requestStr appendFormat:@"<apn>%@</apn><lte_apn>%@</lte_apn>",APN.text,APN.text];
        [requestStr appendFormat:@"<iptype>%ld</iptype>",(long)[self getTypeWithIPTyep:ipType.labelValue.text]];
        [requestStr appendFormat:@"<qci>0</qci><hastft>0</hastft><authtype2g3>%@</authtype2g3>",AuthTypeSelect.labelValue.text];
        [requestStr appendFormat:@"<usr2g3>%@</usr2g3><paswd2g3>%@</paswd2g3>",UserName.text,UserPSW.text];
        [requestStr appendFormat:@"<authtype4g>%@</authtype4g>",AuthTypeSelect.labelValue.text];
        [requestStr appendFormat:@"<usr4g>%@</usr4g><paswd4g>%@</paswd4g>",UserName.text,UserPSW.text];
        [requestStr appendFormat:@"</Item></pdp_supported_list></cellular></wan></RGW>"];

        NILog(@"requesetXml = %@", requestStr);
        NSString *url = [NSString stringWithFormat:@"%@", MIFI_WAN_SET_PATH];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [NIHttpUtil post:url params:nil xmlString:requestStr success:^(AFHTTPRequestOperation *operation, id responseObj) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            BOOL check = [self checkLoginWithOperationResponse:operation.responseString];
            if (check) {
                [self showNeedRelogin];
                return ;
            }
//            [self mbShowToast:@"update success"];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self mbShowToast:error.localizedDescription];
        }];
    }];
    [self.view addSubview:button];
}


- (void)dealTextfield:(UITextField *)textfield{
    [textfield setClearButtonMode:UITextFieldViewModeWhileEditing];
    [textfield setTextColor:ColorWhite];
    [textfield setFont:FontRegular];
}
#pragma mark - 转化
/**
 IP type
 */
- (void)dealShowIPType{
    WeakSelf;
    NSString *type = _ipType.labelValue.text;
    NSArray *modelArray = @[
                            [NISelectModel setTitle:IPType0 value:nil],
                            [NISelectModel setTitle:IPType1 value:nil],
                            [NISelectModel setTitle:IPType2 value:nil]];
    ActionView *action = [[ActionView alloc] initWithSubView:nil];
    NSInteger preSelectIndex = 0;
    for (NISelectModel *model in modelArray) {
        NSInteger index= [modelArray indexOfObject:model];
        if([type isEqualToString:model.title]) {
            preSelectIndex = index;
            break;
        }
    }
    NISelectView *selectView = [[NISelectView alloc] initWithData:modelArray preSelectIndex:preSelectIndex andBlock:^(NISelectModel *model){
        [action hide];
        [weakSelf.ipType resetValue:model.title];
    }];
    [action resetSubView:selectView];
    [self.view addSubview:action];
    [action show];
}
/**
 Auth type
 */
- (void)dealShowAuthType{
    WeakSelf;
    NSString *type = _authType.labelValue.text;
    NSArray *modelArray = @[
                            [NISelectModel setTitle:AuthType0 value:nil],
                            [NISelectModel setTitle:AuthType1 value:nil],
                            [NISelectModel setTitle:AuthType2 value:nil]];
    ActionView *action = [[ActionView alloc] initWithSubView:nil];
    NSInteger preSelectIndex = 0;
    for (NISelectModel *model in modelArray) {
        NSInteger index= [modelArray indexOfObject:model];
        if([type isEqualToString:model.title]) {
            preSelectIndex = index;
            break;
        }
    }
    NISelectView *selectView = [[NISelectView alloc] initWithData:modelArray preSelectIndex:preSelectIndex andBlock:^(NISelectModel *model){
        [action hide];
        [weakSelf.authType resetValue:model.title];
    }];
    [action resetSubView:selectView];
    [self.view addSubview:action];
    [action show];
}
/**
 获取IPtype名称

 @param type 数字 012
 @return 名称
 */
- (NSString *)getIPTypeWithType:(NSInteger)type{
    if (type == 0) {
        return IPType0;
    }else if (type == 1){
        return IPType1;
    }else{
        return IPType2;
    }
}

- (NSInteger)getTypeWithIPTyep:(NSString *)type{
    if ([type isEqualToString:IPType0]) {
        return 0;
    }else if([type isEqualToString:IPType1]){
        return 1;
    }else{
        return 2;
    }
}
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
