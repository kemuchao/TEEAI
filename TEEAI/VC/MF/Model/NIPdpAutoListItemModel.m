//
//  NIPdpAutoListItemModel.m
//  MifiApp
//
//  Created by yueguangkai on 15/11/8.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import "NIPdpAutoListItemModel.h"

@implementation NIPdpAutoListItemModel

-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString
{
    if (self = [super init]) {
        GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:responseXmlString options:0 error:nil];
        GDataXMLElement *element = [document rootElement];
        [self initDatasWithXMLElement:element];
    }
    return self;
}

+(instancetype) pdpAutoListItemWithResponseXmlString:(NSString *)responseXmlString
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

+(instancetype) pdpAutoListItemWithXMLElement:(GDataXMLElement *) xmlElement
{
    return [[self alloc]initWithXMLElement:xmlElement];
}

-(void) initDatasWithXMLElement:(GDataXMLElement *) xmlElement
{
    self.index = [[xmlElement attributeForName:@"index"] stringValue];
    NSArray *childrenElements = [xmlElement children];
    for (int i = 0; i < [childrenElements count]; i++) {
        GDataXMLElement *ele = [childrenElements objectAtIndex:i];
        if ([[ele name] isEqualToString:@"mmc"]) {
            self.mmc = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"mnc"]) {
            self.mnc = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"operator_name"]) {
            self.operator_name = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"apn"]) {
            self.apn = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"lte_apn"]) {
            self.lte_apn = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"network_type"]) {
            self.network_type = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"authtype2g3g"]) {
            self.authtype2g3g = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"username2g3g"]) {
            self.username2g3g = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"password2g3g"]) {
            self.password2g3g = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"authtype4g"]) {
            self.authtype4g = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"username4g"]) {
            self.username4g = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"password4g"]) {
            self.password4g = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"iptype"]) {
            self.iptype = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"default"]){
            self.defaultObject = ele.stringValue;
        }
    }
}

@end
