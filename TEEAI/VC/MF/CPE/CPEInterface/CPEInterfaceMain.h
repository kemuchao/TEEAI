//
//  CPEInterfaceMain.h
//  MifiManager
//
//  Created by notion on 2018/6/26.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPEConnectClients.h"
#import "CPERequestXML.h"
#import "LanguageModel.h"
#import "CPEAllClients.h"
#import "CPEWiFiDetail.h"
#import "CPEStatisticsStatSetting.h"
#import "CPENetMode.h"
#import "CPEWanSwitch.h"
#import "CPEStatisticsCommonData.h"
#import "CPESimStatus.h"
#import "CPEStatCurMon.h"
#import "CPEResultCommonData.h"
#import "CPEWanConfig.h"
#import "CPENetworkModel.h"
#import "CPEUnreadSMS.h"
#import "CPEUSSDModel.h"
@interface CPEInterfaceMain : NSObject

/**
 通用上传操作

 @param requestXML 请求参数
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)uploadCommonWithRequestXML:(NSString *)requestXML Success:(void (^)(CPEResultCommonData *status))success failure:(void (^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause;

/**
 通用上传操作
 
 @param requestXML 请求参数
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)uploadCommonModelWithRequestXML:(NSString *)requestXML Success:(void (^)(CPEResultCommonData *resultDB))success failure:(void (^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause;
+ (void)getWifiDetailSuccess:(void (^)(CPEWiFiDetail *wifiInfo))success failure:(void (^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause;

+ (void)getConnectDevicesSuccess:(void (^)(NSArray *clients))success failure:(void (^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause;
+ (void)getAllDevicesSuccess:(void (^)(NSArray *clients))success failure:(void (^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause;
+ (void)uploadBlockWithRequestXML:(NSString *)requestXML Success:(void (^)(NSString *status))success failure:(void (^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause;

/**
 获取当前SIM信息
 */
+ (void)getSimStatusSuccess:(void (^)(CPESimStatus *simStatus))success failure:(void (^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause;
/**
 获取流量套餐设置
 */
+ (void)getWanStatisticsSuccess:(void(^)(CPEStatisticsStatSetting *wanStat))success failure:(void(^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause;
/**
 获取eng
 */
+ (void)getCPEENGStartSuccess:(void(^)(CPEStatisticsStatSetting *wanStat))success failure:(void(^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause;
/**
 获取月套餐设置已用流量
 */
+ (void)getWanCurMonthSuccess:(void(^)(CPEStatCurMon *monStat))success failure:(void(^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause;
/**
 获取当前优选模式
 */
+ (void)getNetModeSuccess:(void(^)(CPENetMode *netMode))success failure:(void(^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause;

/**
 获取是否漫游
 */
+ (void)getWanSwitchSuccess:(void(^)(CPEWanSwitch *wanSwitch))success failure:(void(^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause;
/**
 获取当前流量
 */
+ (void)getCommonDataSuccess:(void(^)(CPEStatisticsCommonData *commonData))success failure:(void(^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause;
/**
 获取APN配置
 */
+ (void)getWanAPNConfigSuccess:(void(^)(CPEWanConfig *wanConfig))success failure:(void(^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause;
/**
 获取网络运营
 */
+ (void)getNetWorkListSuccess:(void(^)(CPENetworkModel *networkListModel))success failure:(void(^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause;
/**
 获取短信未读
 */
+ (void)getUnreadMessageSuccess:(void(^)(CPEUnreadSMS *unreadMessage))success failure:(void(^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause;
/**
 获取短信信息，即标注为已读
 */
+ (void)getMessageModelBy:(NSInteger)messageID Success:(void(^)(CPESMSModel *message))success failure:(void(^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause;
/**
 获取短信信息，即标注为已读
 */
+ (void)deleteMessageModelBy:(NSInteger)messageID Success:(void(^)(CPESMSModel *message))success failure:(void(^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause;
/**
 发送消息
 */
+ (void)uploadMessageWithXML:(NSString *)xmlString Success:(void(^)(CPESMSModel *message))success failure:(void(^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause;
/**
 发送USSD
 */
+ (void)uploadUSSDWithXML:(NSString *)xmlString Success:(void(^)(CPEUSSDModel *ussd))success failure:(void(^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause;

/**
 获取USSD
 */
+ (void)getUSSDSuccess:(void(^)(CPEUSSDModel *ussd))success failure:(void(^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause;

/**
 提交设备到云端
 */
+ (void)uploadDeviceSuccess:(void(^)(CPEWiFiDetail *wiFiDetail))success failure:(void(^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause;
@end
