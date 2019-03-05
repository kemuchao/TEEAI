//
//  NICustomRulesListIItemModel.m
//  IOS_MIFI_APP
//
//  Created by yueguangkai on 15/12/6.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import "NICustomRulesListItemModel.h"

@implementation NICustomRulesListItemModel
-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString
{
    if (self = [super init]) {
        GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:responseXmlString options:0 error:nil];
        GDataXMLElement *element = [document rootElement];
         [self initDatasWithXMLElement:element];
    }
    return self;
}

+(instancetype) customRulesItemWithResponseXmlString:(NSString *)responseXmlString
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

+(instancetype) customRulesItemWithXMLElement:(GDataXMLElement *) xmlElement
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
        } else if ([[ele name] isEqualToString:@"proto"]) {
            self.proto = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"enabled"]) {
            self.enabled = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"src_ip"]) {
            self.src_ip = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"src_port"]) {
            self.src_port = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"dst_ip"]) {
            self.dst_ip = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"dst_port"]) {
            self.dst_port = ele.stringValue;
        }
    }
}

@end
