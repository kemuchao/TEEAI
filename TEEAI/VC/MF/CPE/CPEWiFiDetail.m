//
//  CPEWiFiDetail.m
//  MifiManager
//
//  Created by notion on 2018/6/22.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "CPEWiFiDetail.h"
#import "GDataXMLNode.h"
@implementation CPEWiFiDetail
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
        if ([ele.name isEqualToString:@"wireless"]) {
            for (GDataXMLElement *apModel in [ele children]) {
                if ([apModel.name isEqualToString:@"AP0"]) {
                    for (GDataXMLElement *wifiModel in [apModel children]) {
                        if ([wifiModel.name isEqualToString:@"wifi_if_24G"]) {
                            for (GDataXMLElement *wifiInfoModel in wifiModel.children) {
                                if ([wifiInfoModel.name isEqualToString:@"ssid0"]) {
                                    for (GDataXMLElement *wifiDetailModel in [wifiInfoModel children]) {
                                        if ([wifiDetailModel.name isEqualToString:@"ssid"]) {
                                            _ssid = wifiDetailModel.stringValue;
                                        }else if ([wifiDetailModel.name isEqualToString:@"key"]){
                                            _key = wifiDetailModel.stringValue;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
@end
