//
//  NIWanStatisticsModel.m
//  MifiApp
//
//  Created by yueguangkai on 15/11/6.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import "NIWanStatisticsModel.h"

@implementation NIWanStatisticsModel

-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString
{
    if (self = [super init]) {
        GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:responseXmlString options:0 error:nil];
        GDataXMLElement *element = [document rootElement];
        [self initDatasWithXMLElement:element];
    }
    return self;
}

+(instancetype) WanStatisticsWithResponseXmlString:(NSString *)responseXmlString
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

+(instancetype) WanStatisticsWithXMLElement:(GDataXMLElement *) xmlElement
{
    return [[self alloc]initWithXMLElement:xmlElement];
}

-(void) initDatasWithXMLElement:(GDataXMLElement *) xmlElement
{
    NSArray *childrenElements = [xmlElement children];
    for (int i = 0; i < [childrenElements count]; i++) {
        GDataXMLElement *ele = [childrenElements objectAtIndex:i];
        if ([[ele name] isEqualToString:@"rx"]) {
            self.rx = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"tx"]) {
            self.tx = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"errors"]) {
            self.errors = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"rx_byte"]) {
            self.rx_byte = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"tx_byte"]) {
            self.tx_byte = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"rx_byte_all"]) {
            self.rx_byte_all = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"tx_byte_all"]) {
            self.tx_byte_all = ele.stringValue;
        }
    }
}
@end
