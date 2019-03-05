//
//  NIStatus1Model.h
//  MifiApp
//
//  Created by yueguangkai on 15/11/6.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
#import "NIWanModel.h"
#import "NISysinfoModel.h"
#import "NIWlanSettingsModel.h"
#import "NIWlanSecurityModel.h"
#import "NIStorageModel.h"
#import "NIFirewallModel.h"
#import "NIStatisticsModel.h"
#import "NILanModel.h"
#import "NIDeviceManagementModel.h"
#import "NIMessageModel.h"


@interface NIStatus1Model : NSObject
@property (nonatomic, strong) NISysinfoModel *sysinfo;
@property (nonatomic, strong) NIWanModel *wan;
@property (nonatomic, strong) NIWlanSettingsModel *wlan_settings;
@property (nonatomic, strong) NIWlanSecurityModel *wlan_security;
@property (nonatomic, strong) NIStorageModel *storage;
@property (nonatomic, strong) NIFirewallModel *firewall;
@property (nonatomic, strong) NIStatisticsModel *statistics;
@property (nonatomic, strong) NILanModel *lan;
@property (nonatomic, strong) NIDeviceManagementModel *device_management;
@property (nonatomic, strong) NIMessageModel *message;

-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString;
+(instancetype) status1WithResponseXmlString:(NSString *)responseXmlString;

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
+(instancetype) status1WithXMLElement:(GDataXMLElement *) xmlElement;
@end
