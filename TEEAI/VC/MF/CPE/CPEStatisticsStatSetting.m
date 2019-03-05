//
//  CPEStatisticsStatSetting.m
//  MifiManager
//
//  Created by notion on 2018/6/28.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "CPEStatisticsStatSetting.h"

@implementation CPEStatisticsStatSetting
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
        if ([ele.name isEqualToString:@"statistics"]) {
            for (GDataXMLElement *model in ele.children) {
                if ([model.name isEqualToString:@"basic_mon"]) {
                    _basicMon = [CPEBasicMon intiWithXMLElement:model];
                }else if ([model.name isEqualToString:@"period"]){
                    _period = [CPEPeriod intiWithXMLElement:model];
                }else if ([model.name isEqualToString:@"idle"]){
                    _idle = [CPEIdle intiWithXMLElement:model];
                }else if ([model.name isEqualToString:@"general"]){
                    _general = [CPEGeneral intiWithXMLElement:model];
                }
            }
        }
    }
}
@end
