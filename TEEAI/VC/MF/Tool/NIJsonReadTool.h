//
//  NIJsonReadTool.h
//  MifiManager
//
//  Created by notion on 2018/3/28.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIJsonReadTool : NSObject
@property (nonatomic, strong) NSString *text;
+ (NSString *)getTextWithDic:(NSDictionary *)infoDic;
@end
