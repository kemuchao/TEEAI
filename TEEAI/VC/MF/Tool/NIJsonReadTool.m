//
//  NIJsonReadTool.m
//  MifiManager
//
//  Created by notion on 2018/3/28.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "NIJsonReadTool.h"

@implementation NIJsonReadTool
+ (NSString *)getTextWithDic:(NSDictionary *)infoDic{
    return [infoDic objectForKey:@"text"];
}
@end
