//
//  NIPinPukModel.m
//  IOS_MIFI_APP
//
//  Created by yueguangkai on 15/12/1.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import "NIPinPukModel.h"
#import "NIPinPukMEPModel.h"

@implementation NIPinPukModel
-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString isRGWStartXml:(BOOL) isRGWStartXml
{
    if (self = [super init]) {
        GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:responseXmlString options:0 error:nil];
        GDataXMLElement *element = [document rootElement];
        if (isRGWStartXml) {
            [self initDatasWithXMLElement:[element elementsForName:@"pin_puk"][0]];
        } else {
            [self initDatasWithXMLElement:element];
        }
    }
    return self;
}

+(instancetype) pinPukWithResponseXmlString:(NSString *)responseXmlString isRGWStartXml:(BOOL) isRGWStartXml
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

+(instancetype) pinPukWithXMLElement:(GDataXMLElement *) xmlElement
{
    return [[self alloc]initWithXMLElement:xmlElement];
}

-(void) initDatasWithXMLElement:(GDataXMLElement *) xmlElement
{
    NSArray *childrenElements = [xmlElement children];
    for (int i = 0; i < [childrenElements count]; i++) {
        GDataXMLElement *ele = [childrenElements objectAtIndex:i];
        if ([[ele name] isEqualToString:@"pin_attempts"]) {
            self.pin_attempts = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"puk_attempts"]) {
            self.puk_attempts = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"pin_enabled"]) {
            self.pin_enabled = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"cmd_status"]) {
            self.cmd_status = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"MEP"]) {
            self.MEP = [NIPinPukMEPModel MEPWithXMLElement:ele];
        }
    }
}
@end
