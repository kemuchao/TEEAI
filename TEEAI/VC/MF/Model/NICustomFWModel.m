//
//  NICustomFWModel.m
//  IOS_MIFI_APP
//
//  Created by yueguangkai on 15/12/6.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import "NICustomFWModel.h"
#import "NICustomRulesListItemModel.h"

@implementation NICustomFWModel
-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString isRGWStartXml:(BOOL) isRGWStartXml
{
    if (self = [super init]) {
        GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:responseXmlString options:0 error:nil];
        GDataXMLElement *element = [document rootElement];
        if (isRGWStartXml) {
            [self initDatasWithXMLElement:[element elementsForName:@"custom_fw"][0]];
        } else {
            [self initDatasWithXMLElement:element];
        }
    }
    return self;
}

+(instancetype) customFWWithResponseXmlString:(NSString *)responseXmlString isRGWStartXml:(BOOL) isRGWStartXml
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

+(instancetype) customFWWithXMLElement:(GDataXMLElement *) xmlElement
{
    return [[self alloc]initWithXMLElement:xmlElement];
}

-(void) initDatasWithXMLElement:(GDataXMLElement *) xmlElement
{
    NSArray *childrenElements = [xmlElement children];
    for (int i = 0; i < [childrenElements count]; i++) {
        GDataXMLElement *ele = [childrenElements objectAtIndex:i];
        if ([[ele name] isEqualToString:@"custom_rules_mode_action"]) {
            self.custom_rules_mode_action = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"custom_rules_mode"]) {
            self.custom_rules_mode = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"custom_rules_list"]) {
            NSArray *elements = ele.children;
            NSMutableArray *list = [[NSMutableArray alloc]initWithCapacity:ele.children.count];
            for (int j = 0; j <ele.children.count; j++) {
                [list addObject:[NICustomRulesListItemModel customRulesItemWithXMLElement:[elements objectAtIndex:j]]];
            }
            self.custom_rules_list = [list mutableCopy];
        }
    }
}

@end
