
//
//  NIPortFilterModel.m
//  IOS_MIFI_APP
//
//  Created by yueguangkai on 15/12/7.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import "NIPortFilterModel.h"
#import "NIPortFilterListItemModel.h"

@implementation NIPortFilterModel
-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString isRGWStartXml:(BOOL) isRGWStartXml
{
    if (self = [super init]) {
        GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:responseXmlString options:0 error:nil];
        GDataXMLElement *element = [document rootElement];
        if (isRGWStartXml) {
            [self initDatasWithXMLElement:[element elementsForName:@"port_filter"][0]];
        } else {
            [self initDatasWithXMLElement:element];
        }
    }
    return self;
}

+(instancetype) portFilterWithResponseXmlString:(NSString *)responseXmlString isRGWStartXml:(BOOL) isRGWStartXml
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

+(instancetype) portFilterWithXMLElement:(GDataXMLElement *) xmlElement
{
    return [[self alloc]initWithXMLElement:xmlElement];
}

-(void) initDatasWithXMLElement:(GDataXMLElement *) xmlElement
{
    NSArray *childrenElements = [xmlElement children];
    for (int i = 0; i < [childrenElements count]; i++) {
        GDataXMLElement *ele = [childrenElements objectAtIndex:i];
        if ([[ele name] isEqualToString:@"port_filter_mode"]) {
            self.port_filter_mode = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"port_filter_list"]) {
            NSArray *elements = ele.children;
            NSMutableArray *list = [[NSMutableArray alloc]initWithCapacity:ele.children.count];
            for (int j = 0; j <ele.children.count; j++) {
                [list addObject:[NIPortFilterListItemModel portFilterItemWithXMLElement:[elements objectAtIndex:j]]];
            }
            self.port_filter_list = [list mutableCopy];
        }
    }
}

@end
