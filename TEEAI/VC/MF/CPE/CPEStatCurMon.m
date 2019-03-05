//
//  CPEStatCurMon.m
//  MifiManager
//
//  Created by notion on 2018/7/2.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "CPEStatCurMon.h"

@implementation CPEStatCurMon
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
            for (GDataXMLElement *element in ele.children) {
                if ([element.name isEqualToString:@"basic_mon_used"]) {
                    _basicMonUsed = element.stringValue;
                }else if ([element.name isEqualToString:@"idle_used"]) {
                    _idleUsed = element.stringValue;
                }else if ([element.name isEqualToString:@"period_used"]) {
                    _periodUsed = element.stringValue;
                }else if ([element.name isEqualToString:@"total_mon_used"]) {
                    _totalMonUsed = element.stringValue;
                }else if ([element.name isEqualToString:@"warning"]) {
                    _warning = element.stringValue;
                }
            }
        }
    }
}
@end
