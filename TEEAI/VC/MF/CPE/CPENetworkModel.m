//
//  CPENetworkModel.m
//  MifiManager
//
//  Created by notion on 2018/7/3.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "CPENetworkModel.h"
                
@implementation CPENetworkModel
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
        if ([ele.name isEqualToString:@"wan"]) {
            _netArray = [NSMutableArray array];
            for (GDataXMLElement *list in ele.children) {
                if ([list.name isEqualToString:@"network_list"]) {
                    for (int i = 0; i<list.children.count; i++) {
                        GDataXMLElement *item = [list.children objectAtIndex:i];
                        CPENetListItem *netModel = [CPENetListItem intiWithXMLElement:item];
                        [_netArray addObject:netModel];
                    }
                }
            }
        }else if ([ele.name isEqualToString:@"response"]){
            for (GDataXMLElement *response in ele.children) {
                if ([response.name isEqualToString:@"setting_response"]) {
                    _response = response.stringValue;
                }
            }
        }
    }
}
@end
