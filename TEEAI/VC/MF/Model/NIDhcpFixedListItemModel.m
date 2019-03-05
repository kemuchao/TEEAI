//
//  NIDhcpFixedListItemModel.m
//  IOS_MIFI_APP
//
//  Created by yueguangkai on 15/12/9.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import "NIDhcpFixedListItemModel.h"

@implementation NIDhcpFixedListItemModel
-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString
{
    if (self = [super init]) {
        GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:responseXmlString options:0 error:nil];
        GDataXMLElement *element = [document rootElement];
        [self initDatasWithXMLElement:element];
    }
    return self;
}

+(instancetype) dhcpFixedListItemWithResponseXmlString:(NSString *)responseXmlString
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

+(instancetype) dhcpFixedListItemWithXMLElement:(GDataXMLElement *) xmlElement
{
    return [[self alloc]initWithXMLElement:xmlElement];
}

-(void) initDatasWithXMLElement:(GDataXMLElement *) xmlElement
{
    self.index = [[xmlElement attributeForName:@"index"] stringValue];
    NSArray *childrenElements = [xmlElement children];
    for (int i = 0; i < [childrenElements count]; i++) {
        GDataXMLElement *ele = [childrenElements objectAtIndex:i];
        if ([[ele name] isEqualToString:@"mac"]) {
            self.mac = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"ip"]) {
            self.ip = ele.stringValue;
        }
    }
}
@end
