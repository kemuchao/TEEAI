//
//  WlanSettingsModel.m
//  MifiApp
//
//  Created by yueguangkai on 15/11/5.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import "NIWlanSettingsModel.h"

@implementation NIWlanSettingsModel

-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString isRGWStartXml:(BOOL) isRGWStartXml
{
    if (self = [super init]) {
        GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:responseXmlString options:0 error:nil];
        GDataXMLElement *element = [document rootElement];
        if (isRGWStartXml) {
            [self initDatasWithXMLElement:[element elementsForName:@"wlan_settings"][0]];
        } else {
            [self initDatasWithXMLElement:element];
        }
    }
    return self;
}

+(instancetype) wlanSettingsWithResponseXmlString:(NSString *)responseXmlString isRGWStartXml:(BOOL) isRGWStartXml
{
    return [[self alloc]initWithResponseXmlString:responseXmlString isRGWStartXml:isRGWStartXml];
}

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement
{
    if (self = [super init]) {
        [self initDatasWithXMLElement:xmlElement];
    }
    return self;
}

+(instancetype) wlanSettingsWithXMLElement:(GDataXMLElement *) xmlElement
{
    return [[self alloc]initWithXMLElement:xmlElement];
}

-(void) initDatasWithXMLElement:(GDataXMLElement *) xmlElement
{
    NSArray *childrenElements = [xmlElement children];
    for (int i = 0; i < [childrenElements count]; i++) {
        GDataXMLElement *ele = [childrenElements objectAtIndex:i];
        if ([[ele name] isEqualToString:@"wlan_enable"]) {
            self.wlan_enable = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"mac"]) {
            self.mac = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"dual_band_support"]) {
            self.dual_band_support = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"rf_band"]) {
            self.rf_band = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"net_mode"]) {
            self.net_mode = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"channel"]) {
            self.channel = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"current_channel"]) {
            self.current_channel = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"first_channel"]) {
            self.first_channel = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"last_channel"]) {
            self.last_channel = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"bandwidth"]) {
            self.bandwidth = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"max_clients"]) {
            self.max_clients = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"wifi_sleep_time"]) {
            self.wifi_sleep_time = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"wifi_sleep_action"]) {
            self.wifi_sleep_action = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"band40_acs_enable"]) {
            self.band40_acs_enable = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"beacon_period"]) {
            self.beacon_period = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"dtim_interval"]) {
            self.dtim_interval = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"sec_channel"]) {
            self.sec_channel = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"ap_isolate"]) {
            self.ap_isolate = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"only_20m"]) {
            self.only_20m = ele.stringValue;
        }
    }
}
@end
