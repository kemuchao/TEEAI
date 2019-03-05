//
//  NIWEPModel.m
//  IOS_MIFI_APP
//
//  Created by yueguangkai on 15/11/18.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import "NIWEPModel.h"

@implementation NIWEPModel
-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString
{
    if (self = [super init]) {
        GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:responseXmlString options:0 error:nil];
        GDataXMLElement *element = [document rootElement];
        [self initDatasWithXMLElement:element];
    }
    return self;
}

+(instancetype) WEPWithResponseXmlString:(NSString *)responseXmlString
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

+(instancetype) WEPWithXMLElement:(GDataXMLElement *) xmlElement
{
    return [[self alloc]initWithXMLElement:xmlElement];
}

-(void) initDatasWithXMLElement:(GDataXMLElement *) xmlElement
{
    NSArray *childrenElements = [xmlElement children];
    for (int i = 0; i < [childrenElements count]; i++) {
        GDataXMLElement *ele = [childrenElements objectAtIndex:i];
        if ([[ele name] isEqualToString:@"key1"]) {
            self.key1 = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"key2"]) {
            self.key2 = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"key3"]) {
            self.key3 = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"key4"]) {
            self.key4 = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"auth"]) {
            self.auth = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"encrypt"]) {
            self.encrypt = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"default_key"]) {
            self.default_key = ele.stringValue;
        } 
    }
}
@end
