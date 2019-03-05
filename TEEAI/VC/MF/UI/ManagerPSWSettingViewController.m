//
//  ManagerPSWSettingViewController.m
//  MifiManager
//
//  Created by notion on 2018/3/20.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "ManagerPSWSettingViewController.h"
#import "NotionEnterGroup.h"
#import "NotionConfirmButton.h"
#import "UIButton+Event.h"
#import "NINodeModel.h"
#import "NIRequestModelUtil.h"
#import "CPEInterfaceMain.h"
@interface ManagerPSWSettingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *nameTextBtn;
@property (weak, nonatomic) IBOutlet UIButton *textPswBtn;
@property (weak, nonatomic) IBOutlet UIButton *confrmPsw;

@property (weak, nonatomic) IBOutlet UIImageView *nameIcon;

@property (weak, nonatomic) IBOutlet UIImageView *npIcon;

@property (weak, nonatomic) IBOutlet UIImageView *confrmIcon;

@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *textPswNew;
@property (weak, nonatomic) IBOutlet UITextField *textPswConfirm;

@end

@implementation ManagerPSWSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.nameTextBtn addTarget:self action:@selector(nameTextTouchDown)forControlEvents: UIControlEventTouchDown];
    [self.nameTextBtn addTarget:self action:@selector(nameTextTouchUp)forControlEvents:  UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    
    [self.textPswBtn addTarget:self action:@selector(textPswNewTouchDown)forControlEvents: UIControlEventTouchDown];
    [self.textPswBtn addTarget:self action:@selector(textPswNewTouchUp)forControlEvents: UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    
    [self.confrmPsw addTarget:self action:@selector(textPswConfirmTouchDown)forControlEvents: UIControlEventTouchDown];
    [self.confrmPsw addTarget:self action:@selector(textPswConfirmTouchUp)forControlEvents: UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
  
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tabBarController.tabBar setHidden:YES];
}

-(void)nameTextTouchDown {
    NSLog(@"按下");
    _nameText.secureTextEntry = NO;
    _nameIcon.image = [UIImage imageNamed:@"psw_height"];
}

-(void)nameTextTouchUp {
    NSLog(@"松开");
    _nameText.secureTextEntry = YES;
    _nameIcon.image = [UIImage imageNamed:@"psw_default"];
}

-(void)textPswNewTouchDown {
    NSLog(@"按下");
    _textPswNew.secureTextEntry = NO;
    _npIcon.image = [UIImage imageNamed:@"psw_height"];
}


-(void)textPswNewTouchUp {
    NSLog(@"松开");
    _textPswNew.secureTextEntry = YES;
    _npIcon.image = [UIImage imageNamed:@"psw_default"];
}

-(void)textPswConfirmTouchDown {
    NSLog(@"按下");
    _textPswConfirm.secureTextEntry = NO;
    _confrmIcon.image = [UIImage imageNamed:@"psw_height"];
}

-(void)textPswConfirmTouchUp {
    NSLog(@"松开");
    _textPswConfirm.secureTextEntry = YES;
    _confrmIcon.image = [UIImage imageNamed:@"psw_default"];
}

- (IBAction)configAction:(id)sender {
    bool valid = YES;
    UITextField *textFieldPswNew = _textPswNew;
    UITextField *textFielfPswConfirm = _textPswConfirm;
    
    if (![self.nameText.text isEqualToString:[NIUerInfoAndCommonSave getValueFromKey:ADMIN_PSW]]) {
        [self mbShowToast:@"当前密码不正确"];
        return;
    }
    
    if ([textFieldPswNew validateWithMethod:ValidCommon] || [textFielfPswConfirm validateWithMethod:ValidCommon]) {
        [self mbShowToast:@"密码不合法"];
        valid = false;
    }
    if(!valid) return ;
    if (![[textFieldPswNew text] isEqualToString:[textFielfPswConfirm text]]) {
        [self mbShowToast:@"两次输入密码不一样"];
        return;
    }
    [self loadNewDataWithPSW:textFieldPswNew.text];
}


- (IBAction)showNewPsw:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) { // 按下去了就是明文
        _textPswNew.secureTextEntry = NO;
    } else { // 暗文
        _textPswNew.secureTextEntry = YES;
    }
}

- (IBAction)showSurePsw:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) { // 按下去了就是明文
        _textPswConfirm.secureTextEntry = NO;
    } else { // 暗文
        _textPswConfirm.secureTextEntry = YES;
    }
}

- (void)uploadCPEWithPSW:(NSString *)password{
    NSString *username = [NIUerInfoAndCommonSave getValueFromKey:ADMIN_NAME];
    NSMutableString *request = [[NSMutableString alloc] initWithString:@"<account>"];
    [request appendString:@"<user_management>"];
    [request appendFormat:@"<action>1</action>"];
    [request appendFormat:@"<username>%@</username>",username];
    [request appendFormat:@"<password>%@</password>",password];
    [request appendString:@"</user_management>"];
    [request appendString:@"</account>"];
    NSString *xmlString = [CPERequestXML getXMLWithPath:@"account" method:@"set_account" addXML:request];
    [CPEInterfaceMain uploadCommonWithRequestXML:xmlString Success:^(CPEResultCommonData *commonData){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([commonData.status isEqualToString:CPEResultOK]) {
            [self mbShowToast:@"update success"];
            [NIUerInfoAndCommonSave saveValue:password key:ADMIN_PSW];
            [self.navigationController popViewControllerAnimated:YES];
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
- (void)loadNewDataWithPSW:(NSString *)password{
    if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
        [self showWIFIAlert];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
        [self uploadCPEWithPSW:password];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *username = [NIUerInfoAndCommonSave getValueFromKey:ADMIN_NAME];
    NSMutableString *requestXML = [[NSMutableString alloc] initWithString:@"<?xml version=\"1.0\" encoding=\"US-ASCII\"?> <RGW>"];
    //management
    [requestXML appendString:@"<management>"];
    [requestXML appendString:@"<router_username></router_username>"];
    [requestXML appendString:@"<router_password></router_password>"];
    //account_management
    [requestXML appendFormat:@"<account_management><account_action>1</account_action><account_username>%@</account_username><account_password>%@</account_password></account_management>",username,password];
    //router_user_list
    [requestXML appendString:@"<router_user_list>"];
    //item
    [requestXML appendFormat:@"<Item index='5'>"];
    [requestXML appendFormat:@"<username>%@</username>",username];
    [requestXML appendFormat:@"<password>%@</password>",password];
    [requestXML appendString:@"<authority>1</authority>"];
    [requestXML appendFormat:@"</Item>"];
    [requestXML appendFormat:@"</router_user_list>"];
    [requestXML appendString:@"</management></RGW>"];
    NSString *url = [NSString stringWithFormat:@"%@", MIFI_SET_ADMIN_PATH];
    
    [NIHttpUtil post:url params:nil xmlString:requestXML success:^(AFHTTPRequestOperation *operation, id responseObj) {
        [MBProgressHUD HUDForView:self.view];
        BOOL check = [self checkLoginWithOperationResponse:operation.responseString];
        if (check) {
            [self showNeedRelogin];
            return ;
        }
        [self mbShowToast:@"update success"];
        [NIUerInfoAndCommonSave saveValue:password key:ADMIN_PSW];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self mbShowToast:error.localizedDescription];
    }];
}

- (void)uploadCPERouterPassword:(NSString *)password{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
