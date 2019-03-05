//
//  MessageViewController.m
//  MifiManager
//
//  Created by yanlei jin on 2018/3/22.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageDetailViewController.h"
#import "MessageModel.h"
#import "MessageTableViewCell.h"
#import "SendMessage.h"
#import "NINodeModel.h"
#import "NICommonUtil.h"
#import "CPEInterfaceMain.h"
//#define HeightHeadView SCREEN_HEIGHT*0.4
@interface MessageViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *createMSMView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSIndexPath *nowIndexPath;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏背景颜色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:88/255.0 green:128/255.0 blue:192/255.0 alpha:1];

    self.view.backgroundColor = ColorWhite;
    _dataArray = [NSMutableArray array];
    [_tableView registerNib:[UINib nibWithNibName:@"MessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.navigationController.navigationBar setHidden:NO];

    [self loadData:@"GET_RCV_SMS_LOCAL"];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tabBarController.tabBar setHidden:YES];
}

- (IBAction)new:(id)sender {
    [self createNewMessage];
}

- (IBAction)cateAction:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"信息类型" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"收信箱" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        self.title = @"收信箱";
        [self loadData:@"GET_RCV_SMS_LOCAL"];
    }];
    
    [alert addAction:confirm];
    
    UIAlertAction *receiveconfirm = [UIAlertAction actionWithTitle:@"发信箱" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        self.title = @"发信箱";
        [self loadData:@"GET_SENT_SMS_LOCAL"];
    }];
    
    [alert addAction:receiveconfirm];
    
    UIAlertAction *simconfirm = [UIAlertAction actionWithTitle:@"SIM卡短信" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){self.title = @"SIM卡短信";
        [self loadData:@"GET_SIM_SMS"];
    }];
    
    [alert addAction:simconfirm];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)initButton:(UIButton*)btn{
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height ,-btn.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,20, -btn.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
}
#pragma mark - 发送短信
- (void)createNewMessage{
    SendMessage *message = [SendMessage initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT/2) placeholder:@"发送短信" delegate:self];
    WeakSelf;
    message.block = ^(NSString *phone,NSString *message){
        [weakSelf uploadPhone:phone message:message];
    };
    message.textTelL.text = @"";
    message.textMsgL.text = @"";
    [message show];
}
#pragma mark - 加载数据
- (void)loadCPEData{
    WeakSelf;
    [CPEInterfaceMain getUnreadMessageSuccess:^(CPEUnreadSMS *unreadMessage){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        weakSelf.dataArray = [NSMutableArray arrayWithArray:unreadMessage.messageArray];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [weakSelf mbShowToast:error.localizedDescription];
    } errorCause:^(NSString *errorCause){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([errorCause isEqualToString:CPEResultNeedLogin]) {
            [weakSelf showNeedRelogin];
        }
    }];
}
- (void)loadData:(NSString *)type{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    WeakSelf;
    if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
        [self showWIFIAlert];
        return;
    }
    if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
        [self loadCPEData];
        return;
    }
    NSInteger page = 1;
    NSMutableString *requestXML = [NSMutableString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"US-ASCII\"?> <RGW><message><flag><message_flag>%@</message_flag></flag>",type];
    [requestXML appendFormat:@"<get_message><page_number>%ld</page_number></get_message>",page];
    [requestXML appendFormat:@"</message></RGW>"];
    NILog(@"requesetXml = %@", requestXML);
    NSString *url = [NSString stringWithFormat:@"%@", MIFI_SET_MESSAGE_PATH];
    
    [NIHttpUtil post:url params:nil xmlString:requestXML success:^(AFHTTPRequestOperation *operation, id responseObj) {
        NILog(@"%@", operation.responseString);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        BOOL check = [weakSelf checkLoginWithOperationResponse:operation.responseString];
        if (check) {
            [self showNeedRelogin];
            return ;
        }
        MessageModel *messageList = [MessageModel initWithResponseXmlString:operation.responseString isRGWStartXml:YES];
        weakSelf.dataArray = [NSMutableArray arrayWithArray:messageList.deviceArray];
        
        [weakSelf.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error");
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [weakSelf mbShowToast:error.localizedDescription];
    }];
}
- (void)uploadCPEPhone:(NSString *)phone message:(NSString *)message{
    WeakSelf;
    NSMutableString *request = [[NSMutableString alloc] initWithString:@"<sms_info>"];
    [request appendString:@"<sms>"];
    [request appendFormat:@"<id>-1</id>"];
    [request appendFormat:@"<gsm7>1</gsm7>"];
    [request appendFormat:@"<address>%@,</address>",phone];
    [request appendFormat:@"<body>%@</body>",[message uniEncode]];
    NSString *sms_time = [NICommonUtil serverDateTimeStringWithDate:[NSDate date] timeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    [request appendFormat:@"<date>%@</date>",sms_time];
    [request appendFormat:@"<protocol>0</protocol>"];
    [request appendString:@"</sms>"];
    [request appendString:@"</sms_info>"];
    NSString *xmlString = [CPERequestXML getXMLWithPath:@"sms" method:@"sms.send" addXML:request];
    [CPEInterfaceMain uploadMessageWithXML:xmlString Success:^(CPESMSModel *message){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (![message.smsID isEqualToString:@"-1"] && [message.resp isEqualToString:@"0"]) {
            [weakSelf mbShowToast:@"发送成功"];
        }else{
            [weakSelf mbShowToast:@"发送失败"];
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
 发送短信

 @param phone 电话号码
 @param message 短信
 */
- (void)uploadPhone:(NSString *)phone message:(NSString *)message{
    if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
        [self showWIFIAlert];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
        [self uploadCPEPhone:phone message:message];
        return;
    }
    WeakSelf;
    NSMutableArray *array = [NSMutableArray array];
    NSString *flag = @"<message_flag>SEND_SMS</message_flag><sms_cmd>4</sms_cmd>";
    [array addObject:[NINodeModel nodelModelWithNodeName:@"flag" value:flag]];
    NSString *messageUnicode = [message uniEncode];
    NSString *sms_time = [NICommonUtil serverDateTimeStringWithDate:[NSDate date] timeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSString *send_save_message = [NSString stringWithFormat:@"<contacts>%@</contacts><content>%@</content><encode_type>UNICODE</encode_type><sms_time>%@</sms_time>",phone,messageUnicode,sms_time];
    [array addObject:[NINodeModel nodelModelWithNodeName:@"send_save_message" value:send_save_message]];
    NSString *requestXml = [NIRequestModelUtil XMLStringWithParentNodeName:@"message" subNodes:array];
    NSString *url = [NSString stringWithFormat:@"%@", MIFI_SET_MESSAGE_PATH];
    [NIHttpUtil post:url params:nil xmlString:requestXml success:^(AFHTTPRequestOperation *operation, id responseObj) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        BOOL check = [weakSelf checkLoginWithOperationResponse:operation.responseString];
        if (check) {
            [weakSelf showNeedRelogin];
            return ;
        }
        MessageModel *messageList = [MessageModel initWithResponseXmlString:operation.responseString isRGWStartXml:YES];
        NSString *sendResult = messageList.sendMessageResult;
        if ([sendResult isEqualToString:@"3"]) {
            [weakSelf mbShowToast:@"发送成功"];
        }else{
            [weakSelf mbShowToast:@"发送失败"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [weakSelf mbShowToast:@"发送失败"];
    }];

}

/**
 删除指定

 @param indexPath 指定下标
 */
- (void)deleteMessageAtIndex:(NSIndexPath *)indexPath{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (![[NIUerInfoAndCommonSave getValueFromKey:ConnectMIFI] isEqualToString:NetValueMIFINet]) {
        [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self showWIFIAlert];
        return;
    }
    WeakSelf;
    MessageInfo *message = _dataArray[indexPath.row];
    NSMutableString *requestXML = [NSMutableString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"US-ASCII\"?> <RGW><message><flag><message_flag>DELETE_SMS</message_flag><sms_cmd>6</sms_cmd></flag><get_message><tags>12</tags><mem_store>1</mem_store></get_message><set_message>"];
    [requestXML appendFormat:@"<delete_message_id>%@</delete_message_id>",message.index];
    [requestXML appendFormat:@"</set_message></message></RGW>"];
    NILog(@"requesetXml = %@", requestXML);
    NSString *url = [NSString stringWithFormat:@"%@", MIFI_SET_MESSAGE_PATH];
    [NIHttpUtil post:url params:nil xmlString:requestXML success:^(AFHTTPRequestOperation *operation, id responseObj) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        BOOL check = [weakSelf checkLoginWithOperationResponse:operation.responseString];
        if (check) {
            [weakSelf showNeedRelogin];
            return ;
        }
        MessageModel *message = [MessageModel initWithResponseXmlString:operation.responseString isRGWStartXml:YES];
        NSString *sendResult = message.sendMessageResult;
        if ([sendResult integerValue] == 3) {
            [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
            [weakSelf.tableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotifyRefreshName object:nil];
        }else{
            [self mbShowToast:@"删除失败"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self mbShowToast:error.localizedDescription];
    }];
}
#pragma mark - 列表
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
        CPESMSModel *cellInfo = _dataArray[indexPath.row];
        cell.labelDetail.text = [cellInfo.body uniDecode];
        if (![cellInfo.read boolValue]) {
            cell.labelDetail.textColor = [UIColor colorWithHexString:ColorBlueDeep];
        }else{
            cell.labelDetail.textColor = [UIColor colorWithHexString:ColorBlueLight];
        }
        
        cell.labelTitle.text = cellInfo.address;
        cell.labelTime.text = [cellInfo.date time];
    }else{
        MessageInfo *cellInfo = _dataArray[indexPath.row];
        cell.labelDetail.text = [cellInfo.subject uniDecode];
        if (![cellInfo.status boolValue]) {
            cell.labelDetail.textColor = [UIColor colorWithHexString:ColorBlueDeep];
        }else{
            cell.labelDetail.textColor = [UIColor colorWithHexString:ColorBlueLight];
        }
        
        cell.labelTitle.text = [[cellInfo.from uniDecode] substringFromIndex:1];
        cell.labelTime.text = [cellInfo.received time];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    _nowIndexPath = indexPath;
    
    [self performSegueWithIdentifier:@"toMessageDetailViewController" sender:self];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        NSLog(@"删除%ld行",(long)indexPath.row);
        [self deleteMessageAtIndex:indexPath];
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
#pragma mark - 设置已读

/**
 设置短信已读

 @param indexPath index
 */
- (void)dealSetReadAtIndex:(NSIndexPath *)indexPath{
    MessageInfo *cellInfo = _dataArray[indexPath.row];
    [cellInfo setStatus:@"1"];
    [_dataArray replaceObjectAtIndex:indexPath.row withObject:cellInfo];
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // segue.identifier：获取连线的ID
    if ([segue.identifier isEqualToString:@"toMessageDetailViewController"]) {
        MessageDetailViewController *messageDetial = segue.destinationViewController;
        if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
            CPESMSModel *message = _dataArray[_nowIndexPath.row];
            messageDetial.cpeMessageInfo = message;
        }else{
            MessageInfo *cellInfo = _dataArray[_nowIndexPath.row];
            messageDetial.messageInfo = cellInfo;
        }
        
        WeakSelf;
        messageDetial.block = ^(BOOL delete){
            if (delete) {
                [weakSelf.dataArray removeObjectAtIndex:self.nowIndexPath.row];
                [weakSelf.tableView deleteRowsAtIndexPaths:@[self.nowIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        };
        messageDetial.readBlock = ^(BOOL read){
            [self dealSetReadAtIndex:self.nowIndexPath];
        };
    }
}

@end
