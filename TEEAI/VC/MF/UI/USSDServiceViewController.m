//
//  USSDServiceViewController.m
//  MifiManager
//
//  Created by notion on 2018/4/25.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "USSDServiceViewController.h"
#import "USSDModel.h"
#import "USSDTableViewCell.h"
#import "CPEInterfaceMain.h"
@interface USSDServiceViewController ()

@property (weak, nonatomic) IBOutlet UITextField *ussdTextField;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation USSDServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _dataArray = [NSMutableArray array];
   
}

- (IBAction)sendAction:(id)sender {
    if (![self.ussdTextField.text isEqualToString:@""]){
        [self postUSSD:self.ussdTextField.text];
    }else {
        [self mbShowToast:@"USSD命令不能为空"];
    }
}

- (void)uploadCPEUSSD:(NSString *)ussd{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableString *request = [[NSMutableString alloc] initWithString:@"<ussd>"];
    [request appendString:@"<action>1</action>"];
    [request appendFormat:@"<param>%@</param>",ussd];
    [request appendString:@"</ussd>"];
    NSMutableString *requestXML = [CPERequestXML getXMLWithPath:@"ussd" method:@"send_ussd" addXML:request];
    [CPEInterfaceMain uploadUSSDWithXML:requestXML Success:^(CPEUSSDModel *ussd){
        [self mbDismiss];
        [self getCPEUSSD];
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

- (void)getCPEUSSD{
    WeakSelf;
    [CPEInterfaceMain getUSSDSuccess:^(CPEUSSDModel *ussd){
        [self mbDismiss];
        if ([ussd.type isEqualToString:@"0"] || [ussd.type isEqualToString:@"1"]) {
            [weakSelf.dataArray addObject:ussd.ussdStr];
        }else if ([ussd.type isEqualToString:@"2"]){
            [self mbShowToast:@"session terminated by network"];
        }else if ([ussd.type isEqualToString:@"3"]){
            [self mbShowToast:@"other local client had responded"];
        }else if ([ussd.type isEqualToString:@"4"]){
            [self mbShowToast:@"operation not supported"];
        }else if ([ussd.type isEqualToString:@"5"]){
            [self mbShowToast:@"network timeout"];
        }else if ([ussd.type isEqualToString:@""]){
            [self mbShowToast:@"network timeout"];
        }else{
            [self mbShowToast:@"Unkown Error"];
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

- (void)postUSSD:(NSString *)ussd{

    if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
        [self uploadCPEUSSD:ussd];
        return;
    }
    NSMutableString *requestStr = [NSMutableString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"US-ASCII\"?> <RGW><ussd><action>1</action>"];
    [requestStr appendFormat:@"<ussd_param>%@</ussd_param></ussd></RGW>",ussd];
    NILog(@"requesetXml = %@", requestStr);
    NSString *url = [NSString stringWithFormat:@"%@", MIFI_SET_USSD_PATH];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NIHttpUtil post:url params:nil xmlString:requestStr success:^(AFHTTPRequestOperation *operation, id responseObj) {
        [self mbDismiss];
        BOOL check = [self checkLoginWithOperationResponse:operation.responseString];
        if (check) {
            [self showNeedRelogin];
            return ;
        }
        [self getUSSD];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self mbDismiss];
        [self mbShowToast:error.localizedDescription];
    }];

}
- (void)getUSSD{
    WeakSelf;
    NSString *url = [NSString stringWithFormat:@"%@", MIFI_SET_USSD_PATH];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NIHttpUtil get:url params:nil success:^(AFHTTPRequestOperation *operation, id responseObj) {
        [self mbDismiss];
        BOOL check = [self checkLoginWithOperationResponse:operation.responseString];
        if (check) {
            [self showNeedRelogin];
            return ;
        }
        USSDModel *ussd = [USSDModel initWithResponseXmlString:operation.responseString];
        if ([ussd.type isEqualToString:@"0"] || [ussd.type isEqualToString:@"1"]) {
            [weakSelf.dataArray addObject:ussd.str];
           
        }else if ([ussd.type isEqualToString:@"2"]){
            [weakSelf mbShowToast:@"session terminated by network"];
        }else if ([ussd.type isEqualToString:@"3"]){
            [weakSelf mbShowToast:@"other local client had responded"];
        }else if ([ussd.type isEqualToString:@"4"]){
            [weakSelf mbShowToast:@"operation not supported"];
        }else if ([ussd.type isEqualToString:@"5"]){
            [weakSelf mbShowToast:@"network timeout"];
        }else if ([ussd.type isEqualToString:@""]){
            [weakSelf mbShowToast:@"network timeout"];
        }else{
            [weakSelf mbShowToast:@"Unkown Error"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf mbDismiss];
        [weakSelf mbShowToast:error.localizedDescription];
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
