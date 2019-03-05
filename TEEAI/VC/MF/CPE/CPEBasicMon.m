//
//  CPEBasicMon.m
//  MifiManager
//
//  Created by notion on 2018/6/28.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "CPEBasicMon.h"

@implementation CPEBasicMon
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
    for (GDataXMLElement *element in childrenElements) {
        if ([element.name isEqualToString:@"enable"]) {
            _enable = element.stringValue;
        }else if ([element.name isEqualToString:@"avl_data"]){
            _avlData = element.stringValue;
        }else if ([element.name isEqualToString:@"payday"]){
            _payday = element.stringValue;
        }else if ([element.name isEqualToString:@""]){
            
        }
    }
}
@end
