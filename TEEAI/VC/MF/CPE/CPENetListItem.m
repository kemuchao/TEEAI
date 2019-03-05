//
//  CPENetListItem.m
//  MifiManager
//
//  Created by notion on 2018/7/3.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "CPENetListItem.h"

@implementation CPENetListItem
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
        GDataXMLElement *ele = [childrenElements objectAtIndex:i];
        if ([ele.name isEqualToString:@"result"]) {
            for (GDataXMLElement *element in ele.children) {
                if ([element.name isEqualToString:@"isp_name"]) {
                    _ispName = element.stringValue;
                }else if ([element.name isEqualToString:@"plmn"]){
                    _plmn = element.stringValue;
                }else if ([element.name isEqualToString:@"act"]){
                    _act = element.stringValue;
                }
            }
        }
    }
}
@end
