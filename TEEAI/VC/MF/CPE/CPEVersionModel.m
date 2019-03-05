//
//  CPEVersionModel.m
//  MifiManager
//
//  Created by notion on 2018/6/22.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "CPEVersionModel.h"
#import "GDataXMLNode.h"
@implementation CPEVersionModel
-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString
{
    if (self = [super init]) {
        GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:responseXmlString options:0 error:nil];
        GDataXMLElement *element = [document rootElement];
        [self initDatasWithXMLElement:element];
    }
    return self;
}

+(instancetype) initWithResponseXmlString:(NSString *)responseXmlString
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

-(void) initDatasWithXMLElement:(GDataXMLElement *) xmlElement
{
    NSArray *childrenElements = [xmlElement children];
    for (int i = 0; i < [childrenElements count]; i++) {
        GDataXMLElement *ele = [childrenElements objectAtIndex:i];
        if ([ele.name isEqualToString:@"version_info"]) {
            for (GDataXMLElement *element in [ele children]) {
                if ([element.name isEqualToString:@"hdware_ver"]) {
                    _hardwareVersion = element.stringValue;
                }else if ([element.name isEqualToString:@"hdware_ver_num"]){
                    _hardwareVersionNum = element.stringValue;
                }else if ([element.name isEqualToString:@"sw_version"]){
                    _swVersion = element.stringValue;
                }else if ([element.name isEqualToString:@"version_num"]){
                    _versionNum = element.stringValue;
                }else if ([element.name isEqualToString:@"fota_ap_version"]){
                    _fotaApVersion = element.stringValue;
                }else if ([element.name isEqualToString:@"build_addr"]){
                    _buildTime = element.stringValue;
                }else if ([element.name isEqualToString:@"mac_addr"]){
                    _macAddress = element.stringValue;
                }else if ([element.name isEqualToString:@"baseband_version"]){
                    _basebandVersion = element.stringValue;
                }else if ([element.name isEqualToString:@"baseband_build_time"]){
                    _basebandBuildTime = element.stringValue;
                }
            }
        }else if ([ele.name isEqualToString:@"response"]){
            for (GDataXMLElement *element in [ele children]) {
                if ([element.name isEqualToString:@"setting_response"]) {
                    _settingResponse = element.stringValue;
                }
            }
        }
    }
}
@end
