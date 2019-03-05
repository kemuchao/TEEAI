//
//  NIStatus1Model.m
//  MifiApp
//
//  Created by yueguangkai on 15/11/6.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import "NIStatus1Model.h"
#import "NISysinfoModel.h"
#import "NIWanModel.h"
#import "NIWlanSettingsModel.h"
#import "NIWlanSecurityModel.h"
#import "NIStorageModel.h"
#import "NIFirewallModel.h"
#import "NIStatisticsModel.h"
#import "NILanModel.h"
#import "NIDeviceManagementModel.h"
#import "NIMessageModel.h"

@implementation NIStatus1Model

-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString
{
    if (self = [super init]) {
        GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:responseXmlString options:0 error:nil];
        GDataXMLElement *element = [document rootElement];
        [self initDatasWithXMLElement:element];
    }
    return self;
}

+(instancetype) status1WithResponseXmlString:(NSString *)responseXmlString
{
    return [[self alloc]initWithResponseXmlString:responseXmlString];
}

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement
{
    if (self = [super init]) {
        [self initDatasWithXMLElement:xmlElement];
    }
    return self;
}

+(instancetype) status1WithXMLElement:(GDataXMLElement *) xmlElement
{
    return [[self alloc]initWithXMLElement:xmlElement];
}

-(void) initDatasWithXMLElement:(GDataXMLElement *) xmlElement
{
    NSArray *childrenElements = [xmlElement children];
    for (int i = 0; i < [childrenElements count]; i++) {
        GDataXMLElement *ele = [childrenElements objectAtIndex:i];
        if ([[ele name] isEqualToString:@"sysinfo"]) {
            self.sysinfo = [NISysinfoModel sysinfoWithXMLElement:ele];
        } else if ([[ele name] isEqualToString:@"wan"]) {
            self.wan = [NIWanModel wanWithXMLElement:ele];
        } else if ([[ele name] isEqualToString:@"wlan_settings"]) {
            self.wlan_settings = [NIWlanSettingsModel wlanSettingsWithXMLElement:ele];
        } else if ([[ele name] isEqualToString:@"wlan_security"]) {
            self.wlan_security = [NIWlanSecurityModel wlanSecurityWithXMLElement:ele];
        } else if ([[ele name] isEqualToString:@"storage"]) {
            self.storage = [NIStorageModel storageWithXMLElement:ele];
        } else if ([[ele name] isEqualToString:@"firewall"]) {
            self.firewall = [NIFirewallModel firewallWithXMLElement:ele];
        } else if ([[ele name] isEqualToString:@"statistics"]) {
            self.statistics = [NIStatisticsModel statisticsWithXMLElement:ele];
        } else if ([[ele name] isEqualToString:@"lan"]) {
            self.lan = [NILanModel lanWithXMLElement:ele];
        } else if ([[ele name] isEqualToString:@"device_management"]) {
            self.device_management = [NIDeviceManagementModel deviceManagementWithXMLElement:ele];
        } else if ([[ele name] isEqualToString:@"message"]) {
            self.message = [NIMessageModel messageWithXMLElement:ele];
        }
    }
}
@end
