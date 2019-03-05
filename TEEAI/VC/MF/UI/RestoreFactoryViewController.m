//
//  RestoreFactoryViewController.m
//  MifiManager
//
//  Created by notion on 2018/4/18.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "RestoreFactoryViewController.h"

#import "LoginViewController.h"
//#import "AppDelegate.h"
#import "ActionView.h"
#import "ResetView.h"
#import "ImageLabel.h"
#import "CPEInterfaceMain.h"
@interface RestoreFactoryViewController ()

@end

@implementation RestoreFactoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:ColorWhite];
}

- (void)loadData{
    if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
        [self showWIFIAlert];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
        [self uploadCPE];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@", MIFI_RESET_PATH];
    [NIHttpUtil get:url params:nil success:^(AFHTTPRequestOperation *operation, id responseObj) {
        NILog(@"%@", operation.responseString);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        BOOL check = [self checkLoginWithOperationResponse:operation.responseString];
        if (check) {
            [self showNeedRelogin];
            return ;
        }
        [self dealGotoRoot];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self mbShowToast:error.localizedDescription];
    }];
}

/**
 CPE网络操作
 */
- (void)uploadCPE{
    NSMutableString *requestXML = [CPERequestXML getXMLWithPath:@"router" method:@"router_call_rst_factory" addXML:nil];
    [CPEInterfaceMain uploadCommonWithRequestXML:requestXML Success:^(CPEResultCommonData *status){
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([status.status isEqualToString:CPEResultOK]) {
            [self dealGotoRoot];
        }
    } failure:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self mbShowToast:error.localizedDescription];
    }errorCause:^(NSString *errorCause){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([errorCause isEqualToString:CPEResultNeedLogin]) {
            [self showNeedRelogin];
        }
    }];
}


- (IBAction)resert:(id)sender {
    [self showAlert];
}


- (void)showAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定恢复出厂设置?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *cancel){
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:cancel];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *confirm){
        [self loadData];
        [self.tabBarController.navigationController popViewControllerAnimated:YES];
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
