//
//  NIDhcpModel.m
//  MifiApp
//
//  Created by yueguangkai on 15/11/6.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import "NIDhcpModel.h"

@implementation NIDhcpModel

-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString
{
    if (self = [super init]) {
        GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:responseXmlString options:0 error:nil];
        GDataXMLElement *element = [document rootElement];
        [self initDatasWithXMLElement:element];
    }
    return self;
}

+(instancetype) dhcpWithResponseXmlString:(NSString *)responseXmlString
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

+(instancetype) dhcpWithXMLElement:(GDataXMLElement *) xmlElement
{
    return [[self alloc]initWithXMLElement:xmlElement];
}

-(void) initDatasWithXMLElement:(GDataXMLElement *) xmlElement
{
    NSArray *childrenElements = [xmlElement children];
    for (int i = 0; i < [childrenElements count]; i++) {
        GDataXMLElement *ele = [childrenElements objectAtIndex:i];
        if ([[ele name] isEqualToString:@"status"]) {
            self.status = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"start"]) {
            self.start = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"end"]) {
            self.end = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"lease_time"]) {
            self.lease_time = ele.stringValue;
        }
    }
}
@end
