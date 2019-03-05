//
//  NIPinPukMEPModel.m
//  IOS_MIFI_APP
//
//  Created by yueguangkai on 15/12/1.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import "NIPinPukMEPModel.h"

@implementation NIPinPukMEPModel
-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString
{
    if (self = [super init]) {
        GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:responseXmlString options:0 error:nil];
        GDataXMLElement *element = [document rootElement];
        [self initDatasWithXMLElement:element];
    }
    return self;
}

+(instancetype) MEPWithResponseXmlString:(NSString *)responseXmlString
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

+(instancetype) MEPWithXMLElement:(GDataXMLElement *) xmlElement
{
    return [[self alloc]initWithXMLElement:xmlElement];
}

-(void) initDatasWithXMLElement:(GDataXMLElement *) xmlElement
{
    NSArray *childrenElements = [xmlElement children];
    for (int i = 0; i < [childrenElements count]; i++) {
        GDataXMLElement *ele = [childrenElements objectAtIndex:i];
        if ([[ele name] isEqualToString:@"CURRENT_STATUS"]) {
            self.CURRENT_STATUS = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"MEP_ACTION"]) {
            self.MEP_ACTION = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"PASSWD"]) {
            self.PASSWD = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"PUK_PASSWD"]) {
            self.PUK_PASSWD = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"ACTION_RESULT"]) {
            self.ACTION_RESULT = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"PN_STATUS"]) {
            self.PN_STATUS = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"PU_STATUS"]) {
            self.PU_STATUS = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"PP_STATUS"]) {
            self.PP_STATUS = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"PC_STATUS"]) {
            self.PC_STATUS = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"SIMLOCK_STATUS"]) {
            self.SIMLOCK_STATUS = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"SIM_LEFT_RETRY_NUM"]) {
            self.SIM_LEFT_RETRY_NUM = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"NW_LEFT_RETRY_NUM"]) {
            self.NW_LEFT_RETRY_NUM = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"NWSUB_LEFT_RETRY_NUM"]) {
            self.NWSUB_LEFT_RETRY_NUM = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"PS_LEFT_RETRY_NUM"]) {
            self.PS_LEFT_RETRY_NUM = ele.stringValue;
        }else if ([[ele name] isEqualToString:@"CORP_LEFT_RETRY_NUM"]) {
            self.CORP_LEFT_RETRY_NUM = ele.stringValue;
        }
    }
}
@end
