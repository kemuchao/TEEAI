//
//  CPEAllClients.m
//  MifiManager
//
//  Created by notion on 2018/6/25.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "CPEAllClients.h"
#import "GDataXMLNode.h"
#import "DeviceInfo.h"
@implementation CPEAllClients
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
        if ([ele.name isEqualToString:@"clients_info"]) {
            NSArray *oneClientsArray = [ele children];
            _clientsArray = [NSMutableArray array];
            for (GDataXMLElement *element in oneClientsArray) {
                
                if ([element.name isEqualToString:@"one_client"]) {
                    
                    DeviceInfo *deviceInfo = [DeviceInfo initWithXMLElement:element];
                    [_clientsArray addObject:deviceInfo];
                }
            }
        }
    }
}
@end
