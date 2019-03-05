//
//  WlanSecurityModel.m
//  MifiApp
//
//  Created by yueguangkai on 15/11/5.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import "NIWlanSecurityModel.h"
#import "NIWPA-PSKModel.h"
#import "NIWPA2-PSKModel.h"
#import "NIWPSModel.h"
#import "NIMixedModel.h"
#import "NIWEPModel.h"
#import "NIWAPI-PSKModel.h"

@implementation NIWlanSecurityModel
-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString isRGWStartXml:(BOOL) isRGWStartXml
{
    if (self = [super init]) {
        GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:responseXmlString options:0 error:nil];
        GDataXMLElement *element = [document rootElement];
        if (isRGWStartXml) {
            [self initDatasWithXMLElement:[element elementsForName:@"wlan_security"][0]];
        } else {
            [self initDatasWithXMLElement:element];
        }
    }
    return self;
}

+(instancetype) wlanSecurityWithResponseXmlString:(NSString *)responseXmlString isRGWStartXml:(BOOL) isRGWStartXml
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

+(instancetype) wlanSecurityWithXMLElement:(GDataXMLElement *) xmlElement
{
    return [[self alloc]initWithXMLElement:xmlElement];
}

-(void) initDatasWithXMLElement:(GDataXMLElement *) xmlElement
{
    NSArray *childrenElements = [xmlElement children];
    for (int i = 0; i < [childrenElements count]; i++) {
        GDataXMLElement *ele = [childrenElements objectAtIndex:i];
        if ([[ele name] isEqualToString:@"wapi_support"]) {
            self.wapi_support = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"lock_enable"]) {
            self.lock_enable = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"ssid"]) {
            self.ssid = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"ssid_bcast"]) {
            self.ssid_bcast = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"mode"]) {
            self.mode = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"client_mac"]) {
            self.client_mac = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"client_ip"]) {
            self.client_ip = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"WPA-PSK"]) {
            self.WPA_PSK = [NIWPA_PSKModel WPA_PSKWithXMLElement:ele];
        } else if ([[ele name] isEqualToString:@"WPA2-PSK"]) {
            self.WPA2_PSK = [NIWPA2_PSKModel WPA2_PSKWithXMLElement:ele];
        } else if ([[ele name] isEqualToString:@"Mixed"]) {
            self.Mixed = [NIMixedModel MixedWithXMLElement:ele];
        } else if ([[ele name] isEqualToString:@"WEP"]) {
            self.WEP = [NIWEPModel WEPWithXMLElement:ele];
        } else if ([[ele name] isEqualToString:@"WAPI-PSK"]) {
            self.WAPI_PSK = [NIWAPI_PSKModel WAPI_PSKWithXMLElement:ele];
        } else if ([[ele name] isEqualToString:@"WPS"]) {
            self.WPS = [NIWPSModel WPSWithXMLElement:ele];
        } else if ([[ele name] isEqualToString:@"default_key_type"]) {
            self.default_key_type = ele.stringValue;
        }
    }
}
@end
