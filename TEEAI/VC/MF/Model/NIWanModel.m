//
//  WanModel.m
//  MifiApp
//
//  Created by yueguangkai on 15/11/5.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import "NIWanModel.h"
#import "NICellularModel.h"
#import "NIWifiModel.h"

@implementation NIWanModel

-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString isRGWStartXml:(BOOL) isRGWStartXml
{
    if (self = [super init]) {
        GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:responseXmlString options:0 error:nil];
        GDataXMLElement *element = [document rootElement];
        if (isRGWStartXml) {
            [self initDatasWithXMLElement:[element elementsForName:@"wan"][0]];
        } else {
            [self initDatasWithXMLElement:element];
        }
    }
    return self;
}

+(instancetype) wanWithResponseXmlString:(NSString *)responseXmlString isRGWStartXml:(BOOL) isRGWStartXml
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

+(instancetype) wanWithXMLElement:(GDataXMLElement *) xmlElement
{
    return [[self alloc]initWithXMLElement:xmlElement];
}

-(void) initDatasWithXMLElement:(GDataXMLElement *) xmlElement
{
    NSArray *childrenElements = [xmlElement children];
    for (int i = 0; i < [childrenElements count]; i++) {
        GDataXMLElement *ele = [childrenElements objectAtIndex:i];
        if ([[ele name] isEqualToString:@"ip"]) {
            self.ip = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"ConnType"]) {
            self.ConnType = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"proto"]) {
            self.proto = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"connect_disconnect"]) {
            self.connect_disconnect = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"gateway"]) {
            self.gateway = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"dns1"]) {
            self.dns1 = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"dns2"]) {
            self.dns2 = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"mask"]) {
            self.mask = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"wan_link_status"]) {
            self.wan_link_status = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"wan_conn_status"]) {
            self.wan_conn_status = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"sys_mode"]) {
            self.sys_mode = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"sys_submode"]) {
            self.sys_submode = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"data_conn_mode"]) {
            self.data_conn_mode = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"tx_rate"]) {
            self.tx_rate = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"rx_rate"]) {
            self.rx_rate = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"ISP"]) {
            self.ISP = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"IMEI"]) {
            self.IMEI = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"ISP_name"]) {
            self.ISP_name = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"Battery_charging"]) {
            self.Battery_charging = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"Battery_charge"]) {
            self.Battery_charge = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"Battery_voltage"]) {
            self.Battery_voltage = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"Battery_connect"]) {
            self.Battery_connect = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"connect_mode"]) {
            self.connect_mode = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"ICCID"]) {
            self.ICCID = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"IMEI_SV"]) {
            self.IMEI_SV = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"MSISDN"]) {
            self.MSISDN = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"network_name"]) {
            self.network_name = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"auto_apn"]) {
            self.auto_apn = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"roaming_network_name"]) {
            self.roaming_network_name = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"cellular"]) {
            self.cellular = [NICellularModel cellularWithXMLElement:ele];
        } else if ([[ele name] isEqualToString:@"wifi"]) {
            self.wifi = [NIWifiModel wifiWithXMLElement:ele];
        } else if ([[ele name] isEqualToString:@"LWG_flag"]) {
            self.LWG_flag = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"advanced_setting"]) {
            self.advanced_setting = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"Roaming_disable_auto_dial"]) {
            self.Roaming_disable_auto_dial = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"Roaming_disable_auto_dial_action"]) {
            self.Roaming_disable_auto_dial_action = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"additional_APN"]) {
            self.additional_APN = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"mtu"]) {
            self.mtu = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"mtu_action"]) {
            self.mtu_action = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"auto_apn_action"]) {
            self.auto_apn_action = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"Engineering_mode"]) {
            self.Engineering_mode = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"query_time_interval"]) {
            self.query_time_interval = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"Roaming_disable_dial"]) {
            self.Roaming_disable_dial = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"Roaming_disable_dial_action"]) {
            self.Roaming_disable_dial_action = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"IMSI"]) {
            self.IMSI = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"cdns_enable"]) {
            self.cdns_enable = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"cdns1"]) {
            self.cdns1 = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"cdns2"]) {
            self.cdns2 = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"mac_enable"]) {
            self.mac_enable = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"mac"]) {
            self.mac = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"rsrp"]) {
            self.rsrp = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"cellid"]) {
            self.cellid = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"sinr"]) {
            self.sinr = ele.stringValue;
        }
    }
}
@end
