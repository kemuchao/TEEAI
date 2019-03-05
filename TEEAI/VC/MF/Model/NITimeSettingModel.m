//
//  NITimeSettingModel.m
//  IOS_MIFI_APP
//
//  Created by yueguangkai on 15/12/8.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import "NITimeSettingModel.h"

@implementation NITimeSettingModel
-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString isRGWStartXml:(BOOL) isRGWStartXml
{
    if (self = [super init]) {
        GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:responseXmlString options:0 error:nil];
        GDataXMLElement *element = [document rootElement];
        if (isRGWStartXml) {
            [self initDatasWithXMLElement:[element elementsForName:@"time_setting"][0]];
        } else {
            [self initDatasWithXMLElement:element];
        }
    }
    return self;
}

+(instancetype) timeSettingWithResponseXmlString:(NSString *)responseXmlString isRGWStartXml:(BOOL) isRGWStartXml
{
    return [[self alloc]initWithResponseXmlString:responseXmlString isRGWStartXml:isRGWStartXml];
}

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement
{
    if (self = [super init]) {
        [self initDatasWithXMLElement:xmlElement];
    }
    return self;
}

+(instancetype) timeSettingWithXMLElement:(GDataXMLElement *) xmlElement
{
    return [[self alloc]initWithXMLElement:xmlElement];
}

-(void) initDatasWithXMLElement:(GDataXMLElement *) xmlElement
{
    NSArray *childrenElements = [xmlElement children];
    for (int i = 0; i < [childrenElements count]; i++) {
        GDataXMLElement *ele = [childrenElements objectAtIndex:i];
        if ([[ele name] isEqualToString:@"year"]) {
            self.year = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"month"]) {
            self.month = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"day"]) {
            self.day = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"hour"]) {
            self.hour = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"minute"]) {
            self.minute = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"second"]) {
            self.second = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"default_date"]) {
            self.default_date = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"ntp_action"]) {
            self.ntp_action = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"ntp_status"]) {
            self.ntp_status = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"reserve"]) {
            self.reserve = ele.stringValue;
        }
    }
}

@end
