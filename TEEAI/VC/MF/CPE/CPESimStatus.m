//
//  CPESimStatus.m
//  MifiManager
//
//  Created by notion on 2018/6/22.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "CPESimStatus.h"
#import "GDataXMLNode.h"
@implementation CPESimStatus
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
        if ([ele.name isEqualToString:@"pin_puk"]) {
            for (GDataXMLElement *element in [ele children]) {
                if ([element.name isEqualToString:@"sim_status"]) {
                    _simStatus = element.stringValue;
                }else if ([element.name isEqualToString:@"pin_status"]){
                    _pinStatus = element.stringValue;
                }else if ([element.name isEqualToString:@"pin_attempts"]){
                    _pinAttempts = element.stringValue;
                }else if ([element.name isEqualToString:@"puk_attempts"]){
                    _pukAttempts = element.stringValue;
                }else if ([element.name isEqualToString:@"mep_sim_attempts"]){
                    _mepSimAttempts = element.stringValue;
                }else if ([element.name isEqualToString:@"mep_nw_attempts"]){
                    _mepNwAttempts = element.stringValue;
                }else if ([element.name isEqualToString:@"mep_subnw_attempts"]){
                    _mepSubNwAttempts = element.stringValue;
                }else if ([element.name isEqualToString:@"mep_sp_attempts"]){
                    _mepSpAttempts = element.stringValue;
                }else if ([element.name isEqualToString:@"mep_corp_attempts"]){
                    _mepCorpAttempts = element.stringValue;
                }else if ([element.name isEqualToString:@"pin_enabled"]){
                    _pinEnabled = element.stringValue;
                }else if ([element.name isEqualToString:@"pn_status"]){
                    _pnStatus = element.stringValue;
                }else if ([element.name isEqualToString:@"pu_status"]){
                    _puStatus = element.stringValue;
                }else if ([element.name isEqualToString:@"pp_status"]){
                    _ppStatus = element.stringValue;
                }else if ([element.name isEqualToString:@"pc_status"]){
                    _pcStatus = element.stringValue;
                }else if ([element.name isEqualToString:@"ps_status"]){
                    _psStatus = element.stringValue;
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
