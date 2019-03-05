//
//  NIWifiTool.h
//  MifiManager
//
//  Created by notion on 2018/3/29.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIWifiTool : NSObject
//获取WIFI name
+ (NSString *)getWifiName;
//获取WIFI IP
+ (NSString *)getIPAddress;
//获取MAC 地址
+ (NSString *)getWiFiMac;
//获取路由器IP
+ (NSString *)getRouterIp;

@end
