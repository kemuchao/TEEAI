//
//  WlanStatistics.m
//  MifiManager
//
//  Created by notion on 2018/5/10.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "WlanStatistics.h"

@implementation WlanStatistics
+ (instancetype)initWithXMLElement:(GDataXMLElement *)xmlElement{
    return [[self alloc] initWithXMLElement:xmlElement];
}
- (instancetype)initWithXMLElement:(GDataXMLElement *)xmlElement{
    self = [super init];
    [self dealXMLElement:xmlElement];
    return self;
}

- (void)dealXMLElement:(GDataXMLElement *)element{
    NSArray *eleArray = [element children];
    for (GDataXMLElement *ele in eleArray) {
        NSString *eleName = [ele name];
        if ([eleName isEqualToString:@"rx"]) {
            self.rx = ele.stringValue;
        }else if ([eleName isEqualToString:@"tx"]){
            self.tx = [ele stringValue];
        }
    }
}
@end
