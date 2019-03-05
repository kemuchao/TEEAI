//
//  CPEPeriod.m
//  MifiManager
//
//  Created by notion on 2018/6/28.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "CPEPeriod.h"

@implementation CPEPeriod
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
        }else if ([element.name isEqualToString:@"svl_data"]){
            _svlData = element.stringValue;
        }else if ([element.name isEqualToString:@"start_hour"]){
            _startHour = element.stringValue;
        }else if ([element.name isEqualToString:@"end_data"]){
            _endHour = element.stringValue;
        }
    }
}
@end
