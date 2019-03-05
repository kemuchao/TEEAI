//
//  NIMannualNetworkItemModel.m
//  IOS_MIFI_APP
//
//  Created by yueguangkai on 15/11/17.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import "NIMannualNetworkItemModel.h"

@implementation NIMannualNetworkItemModel
-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString
{
    if (self = [super init]) {
        GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:responseXmlString options:0 error:nil];
        GDataXMLElement *element = [document rootElement];
        [self initDatasWithXMLElement:element];
    }
    return self;
}

+(instancetype) mannualNetworkItemWithResponseXmlString:(NSString *)responseXmlString
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

+(instancetype) mannualNetworkItemWithXMLElement:(GDataXMLElement *) xmlElement
{
    return [[self alloc]initWithXMLElement:xmlElement];
}

-(void) initDatasWithXMLElement:(GDataXMLElement *) xmlElement
{
    self.index = [[xmlElement attributeForName:@"index"] stringValue];
    NSArray *childrenElements = [xmlElement children];
    for (int i = 0; i < [childrenElements count]; i++) {
        GDataXMLElement *ele = [childrenElements objectAtIndex:i];
        if ([[ele name] isEqualToString:@"name"]) {
            self.name = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"act"]) {
            self.act = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"plmm_name"]) {
            self.plmm_name = ele.stringValue;
        }
    }
}
@end
