//
//  ResetRouterViewController.m
//  MifiManager
//
//  Created by notion on 2018/4/9.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "ResetRouterViewController.h"
#import "LoginViewController.h"
//#import "AppDelegate.h"
#import "ActionView.h"
#import "ResetView.h"
#import "ImageLabel.h"
#import "CPEInterfaceMain.h"
@interface ResetRouterViewController ()

@end

// 重启路由器

@implementation ResetRouterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     
}

- (void)loadData{
    if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
        [self showWIFIAlert];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@", MIFI_RESET_ROUTER_PATH];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
        [self uploadCPE];
        return;
    }
    [NIHttpUtil get:url params:nil success:^(AFHTTPRequestOperation *operation, id responseObj) {
        [self mbDismiss];
        NILog(@"%@", operation.responseString);
        BOOL check = [self checkLoginWithOperationResponse:operation.responseString];
        if (check) {
            [self showNeedRelogin];
            return ;
        }
        //重启路由器之后的操作？返回根视图
        [self dealGotoRoot];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self mbDismiss];
        [self mbShowToast:error.localizedDescription];
    }];
}
/**
 CPE网络操作
 */
- (void)uploadCPE{
    NSMutableString *requestXML = [CPERequestXML getXMLWithPath:@"router" method:@"router_call_reboot" addXML:nil];
    [CPEInterfaceMain uploadCommonWithRequestXML:requestXML Success:^(CPEResultCommonData *status){
        [self mbDismiss];
        if ([status.status isEqualToString:CPEResultOK]) {
            [self dealGotoRoot];
        }
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

- (IBAction)resetAction:(id)sender {
    [self showAlert];
}

- (void)showAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@" 重启后将会中断当前所有连接，需要约1分钟才能恢复" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *cancel){
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:cancel];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *confirm){
        [self loadData];
    }];
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];
    
}


- (NSMutableAttributedString *)dealAddImage:(UIImage *)image text:(NSString *)text{
    NSTextAttachment *attchImage = [[NSTextAttachment alloc] init];
    attchImage.image = image;
    attchImage.bounds = [self dealGetFrameWithX:0 Y:-5 Width:HeightLabel Height:HeightLabel];
    NSAttributedString *imageAtt = [NSAttributedString attributedStringWithAttachment:attchImage];
    NSMutableAttributedString *space = [[NSMutableAttributedString alloc] initWithString:text];
    [space insertAttributedString:imageAtt atIndex:0];
    return space;
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
