//
//  NICommonUtil.h
//  mifi
//
//  Created by yueguangkai on 15/10/22.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NICommonUtil : NSObject
//将本地时间转换成为服务器时间
+(NSString *) serverDateTimeStringWithDate:(NSDate *) date timeZone:(NSTimeZone *)timezone;

//将服务器时间转换为客户端显示
+(NSString *) clientDateTimeStringWithServerDateTimeString:(NSString *) serverDateTime;

+(NSString *) bytesToAvaiUnit:(int) bytes;

+(NSString *) currentTimeMillisString;
#pragma mark - 针对首页获取名称
/**
 CPE 获取SIM卡显示名称
 */
+ (NSString *)getCPENetNameWithSimStatus:(NSString *)simStatus PinStaus:(NSString *)pinStatus;
/**
 获取CPE显示图片
 */
+ (UIImage *)getCPENetShowImageWithSimStatus:(NSString *)simStatus PinStatus:(NSString *)pinStatus;
/**
 获取当前网络情况

 @param name 网络名称
 @param sysSubMode 信号名称
 @param SIMStatus SIM情况
 @return 网络+信号名称
 */
+ (NSString *) getNetName:(NSString *)name ModeName:(NSString *)sysSubMode SIMStatus:(NSString *)SIMStatus PINStatus:(NSString *)PINStatus;
/**
 获取当前网络情况
 
 @param name 网络名称
 @param sysSubMode 信号名称
 @param SIMStatus SIM情况
 @return 网络+信号名称
 */
+ (UIImage *) getNetShowImageWithNetName:(NSString *)name ModeName:(NSString *)sysSubMode SIMStatus:(NSString *)SIMStatus PINStatus:(NSString *)PINStatus;

//+ (NSString *) getConnetStatusFrom:(NSString *)wanLinkStatus;

@end
