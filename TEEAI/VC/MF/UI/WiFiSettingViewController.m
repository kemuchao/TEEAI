//
//  WiFiSettingViewController.m
//  MifiManager
//
//  Created by notion on 2018/3/20.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "WiFiSettingViewController.h"
#import "NotionEnterGroup.h"
#import "NotionConfirmButton.h"
#import "NIWlanSecurityModel.h"
#import "NIMixedModel.h"
#import "NIWPA2-PSKModel.h"
#import "NSString+Extension.h"
#import "UITextField+Validate.h"
#import "NINodeModel.h"
#import "NIRequestModelUtil.h"
#import <CoreImage/CoreImage.h>
#import "NIQRImageTool.h"
#import "CPEInterfaceMain.h"

#define NUM @"0123456789"
#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define SPECIAL @"#:''&;~|<>$"
@interface WiFiSettingViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) NIWlanSecurityModel *wlanSecurity;
@property (nonatomic, strong) NotionEnterGroup *enterGroup;

@property (weak, nonatomic) IBOutlet UITextField *wifiTextField;
@property (weak, nonatomic) IBOutlet UITextField *wifiPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *wifiPasswordBtn;

@end

@implementation WiFiSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //设置导航栏背景颜色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:88/255.0 green:128/255.0 blue:192/255.0 alpha:1];
    
    [self loadData];
    
    [self.wifiPasswordBtn addTarget:self action:@selector(wifiPasswordTouchDown)forControlEvents: UIControlEventTouchDown];
    [self.wifiPasswordBtn addTarget:self action:@selector(wifiPasswordTouchUp)forControlEvents:  UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    
}

-(void)wifiPasswordTouchDown {
    NSLog(@"按下");
    _wifiPasswordTextField.secureTextEntry = NO;
   
}

-(void)wifiPasswordTouchUp {
    NSLog(@"松开");
    _wifiPasswordTextField.secureTextEntry = YES;

}

- (void)loadData{
    WeakSelf;
    if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
        [self showWIFIAlert];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@", MIFI_WLAN_SECURITY_PATH];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
        [self loadDataCPE];
        return;
    }
    
    [NIHttpUtil get:url params:nil success:^(AFHTTPRequestOperation *operation, id responseObj) {
        NILog(@"%@", operation.responseString);
        [self mbDismiss];
        BOOL check = [self checkLoginWithOperationResponse:operation.responseString];
        if (check) {
            [self showNeedRelogin];
            return ;
        }
        NIWlanSecurityModel *wlanSecurity = [NIWlanSecurityModel wlanSecurityWithResponseXmlString:operation.responseString isRGWStartXml:YES];
        weakSelf.wlanSecurity = wlanSecurity;
        
        NSString *ssid = [wlanSecurity.ssid uniDecode];
        NSString *mode = wlanSecurity.mode;
        NSString *key;
        if ([mode isEqualToString:@"None"]) {
            
        } else if ([mode isEqualToString:@"Mixed"]) {
            key = wlanSecurity.Mixed.key;
        } else if ([mode isEqualToString:@"WPA2-PSK"]) {
            key = wlanSecurity.WPA2_PSK.key;
        }
        [weakSelf loadViewWithName:ssid key:key];
        [weakSelf mbDismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self mbDismiss];
        [self mbShowToast:error.localizedDescription];
    }];
}

- (void)loadDataCPE{
    [CPEInterfaceMain getWifiDetailSuccess:^(CPEWiFiDetail *wifiDetail){
        [self mbDismiss];
        [self loadViewWithName:wifiDetail.ssid key:wifiDetail.key];
    } failure:^(NSError *error){
        [self mbDismiss];
        [self mbShowToast:error.localizedDescription];
    }errorCause:^(NSString *errorCause){
        [self mbDismiss];
        if ([errorCause isEqualToString:CPEResultNeedLogin]) {
            [self showNeedRelogin];
        }
    }];
}

- (void)loadNewDataWithName:(NSString *)name psw:(NSString *)psw{
    if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
        [self showWIFIAlert];
        return;
    }
    if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
        [self uploadWifiInfoWithSsid:name key:psw];
        return;
    }
    NSMutableString *requestXML = [[NSMutableString alloc] initWithString:@"<?xml version=\"1.0\" encoding=\"US-ASCII\"?> <RGW><wlan_security>"];
    NSString *wifiName = [_wlanSecurity.ssid uniDecode];
    NSString *mode = _wlanSecurity.mode;
    NSString *key;
    if ([mode isEqualToString:@"None"]) {
        
    } else if ([mode isEqualToString:@"Mixed"]) {
        key = _wlanSecurity.Mixed.key;
    } else if ([mode isEqualToString:@"WPA2-PSK"]) {
        key = _wlanSecurity.WPA2_PSK.key;
    }
    if ([wifiName isEqualToString:name] && [key isEqualToString:psw]) {
        //当没有修改的时候不做处理
        return;
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    if (![wifiName isEqualToString:name]) {
        [requestXML appendFormat:@"<ssid>%@</ssid>",[name uniEncode]];
    }
    
    if (![key isEqualToString:psw]) {
        [requestXML appendFormat:@"<Mixed><key>%@</key></Mixed>",psw];
    }
    NILog(@"requesetXml = %@", requestXML);
    NSString *url = [NSString stringWithFormat:@"%@", MIFI_SET_WLAN_SECURITY_PATH];
    [NIHttpUtil post:url params:nil xmlString:requestXML success:^(AFHTTPRequestOperation *operation, id responseObj) {
        [self mbDismiss];
        [self mbShowToast:Localized(@"wifiChangeSuccess")];
        BOOL check = [self checkLoginWithOperationResponse:operation.responseString];
        if (check) {
            [self showNeedRelogin];
            return ;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self mbDismiss];
        [self mbShowToast:error.localizedDescription];
    }];
}

- (void)uploadWifiInfoWithSsid:(NSString *)ssid key:(NSString *)key{
    NSMutableString *request = [[NSMutableString alloc] initWithString:@"<wireless>"];
    [request appendString:@"<wifi_device>0</wifi_device>"];
    [request appendString:@"<wifi_if_24G>"];
    [request appendString:@"<switch>on</switch>"];
    [request appendString:@"<net_mode>11ng</net_mode>"];
    [request appendString:@"<country>US</country>"];
    [request appendString:@"<channel>0</channel>"];
    [request appendString:@"<bandwidth>HT20</bandwidth>"];
    [request appendString:@"<multi_ssid>1</multi_ssid>"];
    [request appendString:@"<isolate>0</isolate>"];
    [request appendFormat:@"<ssid>%@</ssid>",ssid];
    [request appendString:@"<wpa_group_rekey>10</wpa_group_rekey>"];
    [request appendString:@"<encryption>psk2+ccmp</encryption>"];
    [request appendString:@"<ssid_index>0</ssid_index>"];
    [request appendFormat:@"<key>%@</key>",key];
    [request appendFormat:@"</wifi_if_24G>"];
    [request appendString:@"</wireless>"];
    NSMutableString *requestXML = [CPERequestXML getXMLWithPath:@"wireless" method:@"wifi_set_2.4g" addXML:request];
    [CPEInterfaceMain uploadCommonWithRequestXML:requestXML Success:^(CPEResultCommonData *status){
        [self mbDismiss];
        [self mbShowToast:Localized(@"wifiChangeSuccess")];
    } failure:^(NSError *error){
        [self mbDismiss];
        [self mbShowToast:error.localizedDescription];
    }errorCause:^(NSString *errorCause){
        [self mbDismiss];
        if ([errorCause isEqualToString:CPEResultNeedLogin]) {
            [self showNeedRelogin];
        }
    }];
}

- (IBAction)sureAction:(id)sender {
    if ([_wifiTextField.text isEqualToString:@""] || _wifiTextField.text.length == 0) {
        [self mbShowToast:Localized(@"wifiNameEmpty")];
        return ;
    }
    if (_wifiPasswordTextField.text.length <8 || _wifiPasswordTextField.text.length > 10) {
        [self mbShowToast:Localized(@"wifiPswError")];
        return;
    }
    if ([_wifiTextField.text isChinese]) {
        [self mbShowToast:Localized(@"wifiNameSpecial")];
        return;
    }
    [self loadNewDataWithName:_wifiTextField.text psw:_wifiPasswordTextField.text];
}

- (void)loadViewWithName:(NSString *)name key:(NSString *)key{
    
    _wifiTextField.text = name;
    _wifiPasswordTextField.text = key;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL isSpecial = [self isChinese:string];
//    return [string isEqualToString:filtered];
    if ([string isEqualToString:@" "]) {
        isSpecial = YES;
    }
    return !isSpecial;
}

- (void)dealTextFieldChange:(UITextField *)textField{
    
}

- (BOOL)isChinese:(NSString *)string {
    NSString *regex = @"^[#:''&;~|<>$\u4E00-\u9FA5]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}
- (BOOL)isContainsSpecialCharacter:(NSString *)string{
    NSString *regex = @"^[\u4E00-\u9FA5]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
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

