//
//  CPEResultCommonData.m
//  MifiManager
//
//  Created by notion on 2018/6/26.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "CPEResultCommonData.h"
#import "GDataXMLNode.h"
@implementation CPEResultCommonData
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
        if ([ele.name isEqualToString:@"clients_info"] || [ele.name isEqualToString:@"response"] || [ele.name isEqualToString:@"statistics"]) {
            NSArray *elements = [ele children];
            for (GDataXMLElement *statusModel in elements) {
                if ([statusModel.name isEqualToString:@"setting_response"] || [statusModel.name isEqualToString:@"response_status"]) {
                    _status = statusModel.stringValue;
                }
            }
        }else if ([ele.name isEqualToString:@"pin_puk"]){
            for (GDataXMLElement *pin in ele.children) {
                if ([pin.name isEqualToString:@"pin_attempts"]) {
                    _pinAttempts = pin.stringValue;
                }
            }
        }
    }
}
@end
