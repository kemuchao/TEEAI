//
//  MessageDetailViewController.m
//  MifiManager
//
//  Created by notion on 2018/4/27.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "MessageModel.h"
#import "MessageCommand.h"

@interface MessageDetailViewController ()
@property (nonatomic, strong) UITextView *detailText;
@end

@implementation MessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self loadMainView];
    [self loadData];
    
//    [self setRightBarWithTitle:Localized(@"delete")];
    // Do any additional setup after loading the view.
}
- (void)loadMainView{
    CGFloat originX = 20;
    NSString *from;
    NSString *time;
    NSString *detail;
    if (_cpeMessageInfo) {
        from = _cpeMessageInfo.address;
        time = [_cpeMessageInfo.date time];
        detail = [_cpeMessageInfo.body uniDecode];
    }else{
        from =[[_messageInfo.from uniDecode] substringFromIndex:1];
        time = [_messageInfo.received time];
        detail = [_messageInfo.subject uniDecode];
    }
    UILabel *labelFrom = [self dealSetLabelWithTitle:from color:[UIColor colorWithHexString:ColorBlueDeep] bgColor:ColorClear font:FontRegular textAlign:NSTextAlignmentLeft frame:[self dealGetFrameWithX:originX Y:HeightNanvi+MarginY Width:SCREEN_WIDTH - 2*originX Height:HeightLabel]];
    [self.view addSubview:labelFrom];
    
    UILabel *labelTime = [self dealSetLabelWithTitle:time color:[UIColor colorWithHexString:ColorBlueDeep] bgColor:ColorClear font:FontRegular textAlign:NSTextAlignmentRight frame:[self dealGetFrameWithX:originX Y:HeightNanvi+MarginY Width:SCREEN_WIDTH - 2*originX Height:HeightLabel]];
    [self.view addSubview:labelTime];
    CGFloat originY = VIEW_BOTTOM(labelTime)+MarginY;
    CGRect frame = [self dealGetFrameWithX:originX Y:originY Width:VIEW_WIDTH(labelFrom) Height:SCREEN_HEIGHT - MarginY - originY];
    UITextView *text = [[UITextView alloc] initWithFrame:frame];
    text.text = detail;
    text.font = FontRegular;
    text.userInteractionEnabled = NO;
    text.textColor = [UIColor colorWithHexString:ColorBlueDeep];
    [text setLayerWithBorderWidth:BorderWidth BorderColor:BorderColorGreen CornerRadius:BorderCircle];
    [self.view addSubview:text];
    _detailText = text;
}
#pragma mark - load
- (void)loadCPEMessage{
    WeakSelf;
    [CPEInterfaceMain getMessageModelBy:_cpeMessageInfo.identify.integerValue Success:^(CPESMSModel *message){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([message.read isEqualToString:@"1"]) {
            if (weakSelf.readBlock) {
                weakSelf.readBlock(YES);
            }
        }
        weakSelf.detailText.text = [message.body uniDecode];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotifyRefreshName object:nil];
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

- (void)uploadCPEDelete{
    WeakSelf;
    [CPEInterfaceMain deleteMessageModelBy:_cpeMessageInfo.identify.integerValue Success:^(CPESMSModel *message){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([message.resp isEqualToString:@"0"]) {
            [self mbShowToast:Localized(@"deleteSuccess")];
            if (weakSelf.block) {
                weakSelf.block(YES);
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:NotifyRefreshName object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self mbShowToast:Localized(@"deleteFail")];
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
/**
 获取详情
 */
- (void)loadData{
    WeakSelf;
    if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
        [self showWIFIAlert];
        return;
    }
    if (_cpeMessageInfo) {
        [self loadCPEMessage];
        return;
    }
    NSMutableString *requestXML = [NSMutableString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"US-ASCII\"?> <RGW><message>"];
    [requestXML appendFormat:@"<flag><message_flag>SET_MSG_READ</message_flag><sms_cmd>7</sms_cmd></flag>"];
    [requestXML appendFormat:@"<get_message><tags>12</tags><mem_store>1</mem_store></get_message>"];
    [requestXML appendFormat:@"<set_message><read_message_id>%@</read_message_id></set_message>",_messageInfo.index];
    [requestXML appendFormat:@"</message></RGW>"];
    NILog(@"requesetXml = %@", requestXML);
    NSString *url = [NSString stringWithFormat:@"%@", MIFI_SET_MESSAGE_PATH];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NIHttpUtil post:url params:nil xmlString:requestXML success:^(AFHTTPRequestOperation *operation, id responseObj) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        BOOL check = [self checkLoginWithOperationResponse:operation.responseString];
        if (check) {
            [self showNeedRelogin];
            return ;
        }
        MessageModel *messageList = [MessageModel initWithResponseXmlString:operation.responseString isRGWStartXml:YES];
        if ([messageList.sendMessageResult isEqualToString:@"3"]) {
            if (weakSelf.readBlock) {
                weakSelf.readBlock(YES);
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NotifyRefreshName object:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self mbShowToast:error.localizedDescription];
    }];
}
    
- (IBAction)deleteClick:(id)sender {
     [self deleteMessage];
}

/**
 删除短信
 */
- (void)deleteMessage{
    WeakSelf;
    if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
        [self showWIFIAlert];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (_cpeMessageInfo) {
        [self uploadCPEDelete];
        return;
    }
    NSMutableString *requestXML = [NSMutableString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"US-ASCII\"?> <RGW><message><flag><message_flag>DELETE_SMS</message_flag><sms_cmd>6</sms_cmd></flag><get_message><tags>12</tags><mem_store>1</mem_store></get_message><set_message>"];
    [requestXML appendFormat:@"<delete_message_id>%@</delete_message_id>",_messageInfo.index];
    [requestXML appendFormat:@"</set_message></message></RGW>"];
    NILog(@"requesetXml = %@", requestXML);
    NSString *url = [NSString stringWithFormat:@"%@", MIFI_SET_MESSAGE_PATH];
    [NIHttpUtil post:url params:nil xmlString:requestXML success:^(AFHTTPRequestOperation *operation, id responseObj) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        BOOL check = [self checkLoginWithOperationResponse:operation.responseString];
        if (check) {
            [self showNeedRelogin];
            return ;
        }
        MessageModel *messageList = [MessageModel initWithResponseXmlString:operation.responseString isRGWStartXml:YES];
        NSString *sendResult = messageList.sendMessageResult;
        if ([sendResult integerValue] == 3) {
            [self mbShowToast:@"删除成功"];
            if (weakSelf.block) {
                weakSelf.block(YES);
            }
        
            [[NSNotificationCenter defaultCenter] postNotificationName:NotifyRefreshName object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self mbShowToast:@"删除失败"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self mbShowToast:error.localizedDescription];
    }];
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
