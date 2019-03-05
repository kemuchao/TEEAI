//
//  NIGMBManagerTool.m
//  MifiManager
//
//  Created by notion on 2018/4/8.
//  Copyright © 2018年 notion. All rights reserved.
//
#define NetUnit 1024
#import "NIGMBManagerTool.h"

@implementation NIGMBManagerTool

/**
 返回套餐类型

 @param timeMode 套餐类型1、2、3
 @return 套餐类型
 */
+ (NSString *)getTimeLimitedWithTimeMode:(NSString *)timeMode{
    if ([timeMode intValue] == NWStatisticsTimeForbidInt) {
        return NWStatisticsTimeForbid;
    }else if ([timeMode intValue] == NWStatisticsTimeMonthInt){
        return NWStatisticsTimeMonth;
    }else if ([timeMode intValue] == NWStatisticsTimeUnlimitedInt){
        return NWStatisticsTimeUnlimited;
    }else{
        return @"";
    }
}

/**
 设置最高流量前获取对应字段名称

 @param timeMode 套餐名称
 @return 字段名称
 */
+ (NSString *)getTotalRangeNameWithTimeMode:(NSString *)timeMode{
    if ([timeMode isEqualToString:NWStatisticsTimeForbid ]) {
        return @"";
    }else if ([timeMode isEqualToString:NWStatisticsTimeMonth ]){
        return @"total_available_month";
    }else if ([timeMode isEqualToString:NWStatisticsTimeUnlimited ]){
        return @"total_avaliable_unlimit";
    }else{
        return @"";
    }
}

/**
 返回设置最大值对应字段名称

 @param timeMode 套餐类型
 @return 字段名称
 */
+ (NSString *)getUpperRangeNameWithTimeMode:(NSString *)timeMode{
    if ([timeMode isEqualToString:NWStatisticsTimeForbid ]) {
        return @"";
    }else if ([timeMode isEqualToString:NWStatisticsTimeMonth ]){
        return @"upper_value_month";
    }else if ([timeMode isEqualToString:NWStatisticsTimeUnlimited ]){
        return @"upper_value_unlimit";
    }else{
        return @"";
    }
}
/**
 根本描述返回套餐类型 1、2、3
 0为未知

 @param timeLimited 套餐描述
 @return 套餐类型
 */
+ (int)getTimeModeWithTimeLimited:(NSString *)timeLimited{
    if ([timeLimited isEqualToString:NWStatisticsTimeForbid]) {
        return NWStatisticsTimeForbidInt;
    }else if ([timeLimited isEqualToString:NWStatisticsTimeForbid]){
        return NWStatisticsTimeMonthInt;
    }else if ([timeLimited isEqualToString:NWStatisticsTimeForbid]){
        return NWStatisticsTimeUnlimitedInt;
    }else{
        return 0;
    }
}

/**
 将获取的DB单位数转化为实际单位

 @param dbString db 单位数
 @return 实际流量单位
 */
+(NSString *)getNetNumberWithDBString:(NSString *)dbString{
    if ([self getKBWithDBString:dbString] <=NetUnit) {
        return [NSString stringWithFormat:@"%.0fKB",[self getKBWithDBString:dbString]];
    }else if ([self getMBWithDBString:dbString]<=NetUnit){
        return [NSString stringWithFormat:@"%.0fMB",[self getMBWithDBString:dbString]];
    }else{
        return [NSString stringWithFormat:@"%.0fGB",[self getGBWithDBString:dbString]];
    }
}

/**
 将设置的流量转化为db 单位数值

 @param netNumber 流量单位数
 @param type 类型 MB、GB
 @return 上传数值
 */
+ (float)getNetNumberWithString:(NSString *)netNumber type:(NSString *)type{
    if ([type isEqualToString:@"MB"]) {
        return [netNumber floatValue]*1024*1024;
    } else {
        return [netNumber floatValue]*1024*1024*1024;
    }
}


/**
 获取KB
 */
+ (float)getKBWithDBString:(NSString *)dbString{
    return [dbString floatValue]/1024;
}
/**
 获取MB
 */
+ (float)getMBWithDBString:(NSString *)dbString{
    return [dbString floatValue]/1024/1024;
}
/**
 获取GB
 */
+ (float)getGBWithDBString:(NSString *)dbString{
    return [dbString floatValue]/1024/1024/1024;
}



@end
