//
//  WanStatistics.m
//  MifiManager
//
//  Created by notion on 2018/4/4.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "WanStatistics.h"

@implementation WanStatistics
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
        if ([eleName isEqualToString:@"stat_mang_method"]) {
            self.statMangMethod = ele.stringValue;
        }else if ([eleName isEqualToString:@"upper_value_unlimit"]){
            self.upperValueUnlimit = [ele stringValue];
        }else if ([eleName isEqualToString:@"upper_value_month"]){
            self.upperValueMonth = [ele stringValue];
        }else if ([eleName isEqualToString:@"total_avaliable_unlimit"]){
            self.totalAvaliableUnlimit = [ele stringValue];
        }else if ([eleName isEqualToString:@"total_available_month"]){
            self.totalAvaliableMonth = [ele stringValue];
        }else if ([eleName isEqualToString:@"total_used_unlimit"]){
            self.totalUsedUnlimit = [ele stringValue];
        }else if ([eleName isEqualToString:@"total_used_month"]){
            self.totalUsedMonth = [ele stringValue];
        }else if ([eleName isEqualToString:@"alarm_needed"]){
            self.alarmNeeded = [ele stringValue];
        }else{
            
        }
    }
}
@end
