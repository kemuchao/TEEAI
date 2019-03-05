//
//  CPEGeneral.m
//  MifiManager
//
//  Created by notion on 2018/6/28.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "CPEGeneral.h"

@implementation CPEGeneral
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
        if ([element.name isEqualToString:@"warn_enable"]) {
            _warnEnable = element.stringValue;
        }else if ([element.name isEqualToString:@"warn_percent"]){
            _warnPercent = element.stringValue;
        }else if ([element.name isEqualToString:@"dis_enable"]){
            _disEnable = element.stringValue;
        }else if ([element.name isEqualToString:@"dis_percent"]){
            _disPercent = element.stringValue;
        }
    }
}
@end
