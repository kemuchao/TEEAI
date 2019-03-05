//
//  NIPdpSupportedListItemModel.m
//  IOS_MIFI_APP
//
//  Created by yueguangkai on 15/11/15.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import "NIPdpSupportedListItemModel.h"

@implementation NIPdpSupportedListItemModel
-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString
{
    if (self = [super init]) {
        GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:responseXmlString options:0 error:nil];
        GDataXMLElement *element = [document rootElement];
        [self initDatasWithXMLElement:element];
    }
    return self;
}

+(instancetype) pdpSupportedListItemWithResponseXmlString:(NSString *)responseXmlString
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

+(instancetype) pdpSupportedListItemWithXMLElement:(GDataXMLElement *) xmlElement
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
        }else if ([[ele name] isEqualToString:@"enable"]) {
            self.enable = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"conntype"]) {
            self.conntype = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"default"]) {
            self.pdefault = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"secondary"]) {
            self.secondary = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"apn"]) {
            self.apn = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"lte_apn"]) {
            self.lte_apn = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"iptype"]) {
            self.iptype = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"qci"]) {
            self.qci = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"authtype2g3"]) {
            self.authtype2g3 = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"usr2g3"]) {
            self.usr2g3 = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"paswd2g3"]) {
            self.paswd2g3 = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"authtype4g"]) {
            self.authtype4g = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"usr4g"]) {
            self.usr4g = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"paswd4g"]) {
            self.paswd4g = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"hastft"]) {
            self.hastft = ele.stringValue;
        }
    }
}
@end
