//
//  SysinfoModel.m
//  MifiApp
//
//  Created by yueguangkai on 15/11/5.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import "NISysinfoModel.h"

@interface NISysinfoModel()

@end

@implementation NISysinfoModel

-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString
{
    if (self = [super init]) {
        GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:responseXmlString options:0 error:nil];
        GDataXMLElement *element = [document rootElement];
        [self initDatasWithXMLElement:element];
    }
    return self;
}

+(instancetype) sysinfoWithResponseXmlString:(NSString *)responseXmlString
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

+(instancetype) sysinfoWithXMLElement:(GDataXMLElement *) xmlElement
{
    return [[self alloc]initWithXMLElement:xmlElement];
}

-(void) initDatasWithXMLElement:(GDataXMLElement *) xmlElement
{
    NSArray *childrenElements = [xmlElement children];
    for (int i = 0; i < [childrenElements count]; i++) {
        GDataXMLElement *ele = [childrenElements objectAtIndex:i];
        if ([[ele name] isEqualToString:@"hardware_version"]) {
            self.hardware_version = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"device_name"]) {
            self.device_name = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"version_num"]) {
            self.version_num = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"version_date"]) {
            self.version_date = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"model_name"]) {
            self.model_name = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"main_chip_name"]) {
            self.main_chip_name = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"ssg_version"]) {
            self.ssg_version = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"ssg_compile_time"]) {
            self.ssg_compile_time = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"current_device_mac"]) {
            self.current_device_mac = ele.stringValue;
        }
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"{%@,%@,%@,%@,%@,%@,%@,%@,%@}",
            self.hardware_version,
            self.device_name,
            self.version_num,
            self.version_date,
            self.model_name,
            self.main_chip_name,
            self.ssg_version,
            self.ssg_compile_time,
            self.current_device_mac];
}

@end
