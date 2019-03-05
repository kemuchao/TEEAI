//
//  DeviceInfo.m
//  MifiManager
//
//  Created by notion on 2018/3/28.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "DeviceInfo.h"
#import "NSString+Extension.h"

@implementation DeviceInfo
+ (instancetype)initWithXMLElement:(GDataXMLElement *)xmlElement{
    return [[self alloc] initWithXMLElement:xmlElement];
}
- (instancetype)initWithXMLElement:(GDataXMLElement *)xmlElement{
    self = [super init];
    [self dealXMLElement:xmlElement];
    return self;
}
- (void)dealXMLElement:(GDataXMLElement *)element{
    NSLog(@"device_%@",element);
    NSArray *eleArray = [element children];
    for (int i = 0; i<eleArray.count; i++) {
        GDataXMLElement *ele = eleArray[i];
        NSString *eleName = [ele name];
        if ([eleName isEqualToString:@"mac"]) {
            self.mac = ele.stringValue;
        }else if ([eleName isEqualToString:@"name"]){
            NSString *name = [ele.stringValue stringByReplacingOccurrencesOfString:@" " withString:@"0"];
            self.name = [name uniDecode];
            if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
                self.name = ele.stringValue;
            }
        }else if ([eleName isEqualToString:@"name_type"]){
            self.nameType = ele.stringValue;
        }else if ([eleName isEqualToString:@"conn_type"] || [eleName isEqualToString:@"type"]){
            self.connType = ele.stringValue;
        }else if ([eleName isEqualToString:@"ip_address"] || [eleName isEqualToString:@"ip"]){
            self.ipAddress = ele.stringValue;
        }else if ([eleName isEqualToString:@"conn_time"]){
            self.connTime = ele.stringValue;
        }else if ([eleName isEqualToString:@"conn_time_at"] || [eleName isEqualToString:@"cur_conn_time"]){
            self.connectTimeAt = ele.stringValue;
        }else if ([eleName isEqualToString:@"conn_time_for"]){
            self.connectTimeFor = ele.stringValue;
        }else if ([eleName isEqualToString:@"status"]){
            self.status = ele.stringValue;
            if ([ele.stringValue isEqualToString:@"conn"]) {
                self.status = @"1";
            }else if([ele.stringValue isEqualToString:@"dis_conn"]){
                self.status = @"0";
            }else if ([ele.stringValue isEqualToString:@"block"]){
                self.status = @"2";
            }
        }else if ([eleName isEqualToString:@"blocked"]){
            
        }
    }
}
@end

