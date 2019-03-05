//
//  CPESMSModel.m
//  MifiManager
//
//  Created by notion on 2018/7/3.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "CPESMSModel.h"

@implementation CPESMSModel
-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString
{
    if (self = [super init]) {
        GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:responseXmlString options:0 error:nil];
        GDataXMLElement *element = [document rootElement];
        for (GDataXMLElement *sms in element.children) {
            if ([sms.name isEqualToString:@"sms"]) {
                [self initDatasWithXMLElement:sms];
            }
            
        }
        
    }
    return self;
}

+(instancetype) initWithResponseXmlString:(NSString *)responseXmlString
{
    return [[self alloc]initWithResponseXmlString:responseXmlString];
}
+(instancetype) intiWithXMLElement:(GDataXMLElement *)xmlElement{
    return [[self alloc] initWithXMLElement:xmlElement];
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
        GDataXMLElement *element = [childrenElements objectAtIndex:i];
        if ([element.name isEqualToString:@"id"]) {
            _identify = element.stringValue;
        }else if ([element.name isEqualToString:@"address"]){
            _address = element.stringValue;
        }else if ([element.name isEqualToString:@"contact_id"]){
            _contactId = element.stringValue;
        }else if ([element.name isEqualToString:@"date"]){
            _date = element.stringValue;
        }else if ([element.name isEqualToString:@"protocol"]){
            _protocol = element.stringValue;
        }else if ([element.name isEqualToString:@"type"]){
            _type = element.stringValue;
        }else if ([element.name isEqualToString:@"read"]){
            _read = element.stringValue;
        }else if ([element.name isEqualToString:@"status"]){
            _status = element.stringValue;
        }else if ([element.name isEqualToString:@"location"]){
            _location = element.stringValue;
        }else if ([element.name isEqualToString:@"body"]){
            _body = element.stringValue;
        }else if ([element.name isEqualToString:@"resp"]){
            _resp = element.stringValue;
        }else if ([element.name isEqualToString:@"smsid"]){
            _smsID = element.stringValue;
        }
    }
}
@end
