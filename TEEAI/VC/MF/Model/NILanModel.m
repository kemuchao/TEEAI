//
//  LanModel.m
//  MifiApp
//
//  Created by yueguangkai on 15/11/5.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import "NILanModel.h"
#import "NIDhcpModel.h"
#import "NIDhcpFixedListItemModel.h"

@implementation NILanModel

-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString isRGWStartXml:(BOOL) isRGWStartXml
{
    if (self = [super init]) {
        GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:responseXmlString options:0 error:nil];
        GDataXMLElement *element = [document rootElement];
        if (isRGWStartXml) {
            [self initDatasWithXMLElement:[element elementsForName:@"lan"][0]];
        } else {
            [self initDatasWithXMLElement:element];
        }
    }
    return self;
}

+(instancetype) lanWithResponseXmlString:(NSString *)responseXmlString isRGWStartXml:(BOOL) isRGWStartXml
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

+(instancetype) lanWithXMLElement:(GDataXMLElement *) xmlElement
{
    return [[self alloc]initWithXMLElement:xmlElement];
}

-(void) initDatasWithXMLElement:(GDataXMLElement *) xmlElement
{
    NSArray *childrenElements = [xmlElement children];
    for (int i = 0; i < [childrenElements count]; i++) {
        GDataXMLElement *ele = [childrenElements objectAtIndex:i];
        if ([[ele name] isEqualToString:@"dhcp"]) {
            self.dhcp = [NIDhcpModel dhcpWithXMLElement:ele];
        } else if ([[ele name] isEqualToString:@"ip"]) {
            self.ip = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"mac"]) {
            self.mac = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"mask"]) {
            self.mask = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"run_days"]) {
            self.run_days = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"run_hours"]) {
            self.run_hours = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"run_minutes"]) {
            self.run_minutes = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"run_seconds"]) {
            self.run_seconds = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"redirect_enable"]) {
            self.redirect_enable = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"redirect_url"]) {
            self.redirect_url = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"dhcpv6server"]) {
            self.dhcpv6server = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"Fixed_IP_list"]) {
            NSArray *listElements = ele.children;
            NSMutableArray *list = [[NSMutableArray alloc]initWithCapacity:listElements.count];
            for (int j = 0; j <listElements.count; j++) {
                [list addObject:[NIDhcpFixedListItemModel dhcpFixedListItemWithXMLElement:[listElements objectAtIndex:j]]];
            }
            self.Fixed_IP_list = list;
        } else if ([[ele name] isEqualToString:@"dns_name"]) {
            self.dns_name = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"dns_enable"]) {
            self.dns_enable = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"dns1"]) {
            self.dns1 = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"dns2"]) {
            self.dns2 = ele.stringValue;
        }
    }
}
@end
