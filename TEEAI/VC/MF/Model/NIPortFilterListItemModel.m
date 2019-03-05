//
//  NIPortFilterListItemModel.m
//  IOS_MIFI_APP
//
//  Created by yueguangkai on 15/12/7.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import "NIPortFilterListItemModel.h"

@implementation NIPortFilterListItemModel
-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString
{
    if (self = [super init]) {
        GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:responseXmlString options:0 error:nil];
        GDataXMLElement *element = [document rootElement];
        [self initDatasWithXMLElement:element];
    }
    return self;
}

+(instancetype) portFilterItemWithResponseXmlString:(NSString *)responseXmlString
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

+(instancetype) portFilterItemWithXMLElement:(GDataXMLElement *) xmlElement
{
    return [[self alloc]initWithXMLElement:xmlElement];
}

-(void) initDatasWithXMLElement:(GDataXMLElement *) xmlElement
{
    self.index = [[xmlElement attributeForName:@"index"] stringValue];
    NSArray *childrenElements = [xmlElement children];
    for (int i = 0; i < [childrenElements count]; i++) {
        GDataXMLElement *ele = [childrenElements objectAtIndex:i];
        if ([[ele name] isEqualToString:@"rule_name"]) {
            self.rule_name = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"protocol"]) {
            self.protocol = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"trigger_port"]) {
            self.trigger_port = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"response_port"]) {
            self.response_port = ele.stringValue;
        }
    }
}

@end
