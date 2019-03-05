//
//  NIPdpContextListItemModel.m
//  IOS_MIFI_APP
//
//  Created by yueguangkai on 15/11/15.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import "NIPdpContextListItemModel.h"

@implementation NIPdpContextListItemModel
-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString
{
    if (self = [super init]) {
        GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:responseXmlString options:0 error:nil];
        GDataXMLElement *element = [document rootElement];
        [self initDatasWithXMLElement:element];
    }
    return self;
}

+(instancetype) pdpContextListItemWithResponseXmlString:(NSString *)responseXmlString
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

+(instancetype) pdpContextListItemWithXMLElement:(GDataXMLElement *) xmlElement
{
    return [[self alloc]initWithXMLElement:xmlElement];
}

-(void) initDatasWithXMLElement:(GDataXMLElement *) xmlElement
{
    self.index = [[xmlElement attributeForName:@"index"] stringValue];
    NSArray *childrenElements = [xmlElement children];
    for (int i = 0; i < [childrenElements count]; i++) {
        GDataXMLElement *ele = [childrenElements objectAtIndex:i];
        if ([[ele name] isEqualToString:@"rulename"]) {
            self.rulename = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"connnum"]) {
            self.connnum = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"pconnnum"]) {
            self.pconnnum = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"success"]) {
            self.success = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"default"]) {
            self.pdefault = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"secondary"]) {
            self.secondary = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"ipv4"]) {
            self.ipv4 = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"v4dns1"]) {
            self.v4dns1 = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"v4dns2"]) {
            self.v4dns2 = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"v4gateway"]) {
            self.v4gateway = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"v4netmask"]) {
            self.v4netmask = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"ipv6"]) {
            self.ipv6 = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"g_ipv6"]) {
            self.g_ipv6 = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"v6dns1"]) {
            self.v6dns1 = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"v6dns2"]) {
            self.v6dns2 = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"v6gateway"]) {
            self.v6gateway = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"v6netmask"]) {
            self.v6netmask = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"curconntime"]) {
            self.curconntime = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"totalconntime"]) {
            self.totalconntime = ele.stringValue;
        }
    }
}
@end
