//
//  NIWlanMacFiltersModel.m
//  IOS_MIFI_APP
//
//  Created by yueguangkai on 15/12/14.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import "NIWlanMacFiltersModel.h"
#import "NIMacFiltersItemModel.h"

@implementation NIWlanMacFiltersModel
-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString isRGWStartXml:(BOOL) isRGWStartXml
{
    if (self = [super init]) {
        GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:responseXmlString options:0 error:nil];
        GDataXMLElement *element = [document rootElement];
        if (isRGWStartXml) {
            [self initDatasWithXMLElement:[element elementsForName:@"wlan_mac_filters"][0]];
        } else {
            [self initDatasWithXMLElement:element];
        }
    }
    return self;
}

+(instancetype) macFiltersWithResponseXmlString:(NSString *)responseXmlString isRGWStartXml:(BOOL) isRGWStartXml
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

+(instancetype) macFiltersWithXMLElement:(GDataXMLElement *) xmlElement
{
    return [[self alloc]initWithXMLElement:xmlElement];
}

-(void) initDatasWithXMLElement:(GDataXMLElement *) xmlElement
{
    NSArray *childrenElements = [xmlElement children];
    for (int i = 0; i < [childrenElements count]; i++) {
        GDataXMLElement *ele = [childrenElements objectAtIndex:i];
        if ([[ele name] isEqualToString:@"enable"]) {
            self.enable = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"mode"]) {
            self.mode = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"allow_list"]) {
            NSArray *elements = ele.children;
            NSMutableArray *list = [[NSMutableArray alloc]initWithCapacity:ele.children.count];
            for (int j = 0; j <ele.children.count; j++) {
                [list addObject:[NIMacFiltersItemModel macFiltersItemWithXMLElement:[elements objectAtIndex:j]]];
            }
            self.allow_list = [list mutableCopy];
        } else if ([[ele name] isEqualToString:@"deny_list"]) {
            NSArray *elements = ele.children;
            NSMutableArray *list = [[NSMutableArray alloc]initWithCapacity:ele.children.count];
            for (int j = 0; j <ele.children.count; j++) {
                [list addObject:[NIMacFiltersItemModel macFiltersItemWithXMLElement:[elements objectAtIndex:j]]];
            }
            self.deny_list = [list mutableCopy];
        }
    }
}

@end
