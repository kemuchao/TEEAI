//
//  CPEUSSDModel.m
//  MifiManager
//
//  Created by notion on 2018/7/19.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "CPEUSSDModel.h"

@implementation CPEUSSDModel
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
        if ([ele.name isEqualToString:@"ussd"]) {
            for (GDataXMLElement *element in ele.children) {
                if ([element.name isEqualToString:@"ussd_type"]) {
                    _type = element.stringValue;
                }else if ([element.name isEqualToString:@"ussd_str"]){
                    _ussdStr = element.stringValue;
                }
            }
        }else if ([ele.name isEqualToString:@"response"]){
            for (GDataXMLElement *element in ele.children) {
                if ([element.name isEqualToString:@"setting_response"]) {
                    _response = element.stringValue;
                }
            }
        }
    }
}
@end
