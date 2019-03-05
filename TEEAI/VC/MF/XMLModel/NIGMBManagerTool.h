//
//  NIGMBManagerTool.h
//  MifiManager
//
//  Created by notion on 2018/4/8.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIGMBManagerTool : NSObject
+ (NSString *)getTimeLimitedWithTimeMode:(NSString *)timeMode;
+ (int)getTimeModeWithTimeLimited:(NSString *)timeLimited;

+(NSString *)getNetNumberWithDBString:(NSString *)dbString;
+ (float)getNetNumberWithString:(NSString *)netNumber type:(NSString *)type;

+ (NSString *)getTotalRangeNameWithTimeMode:(NSString *)timeMode;
+ (NSString *)getUpperRangeNameWithTimeMode:(NSString *)timeMode;
@end
