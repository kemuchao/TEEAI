//
//  NIUerInfoAndCommonSave.h
//  MifiManager
//
//  Created by notion on 2018/3/29.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIUerInfoAndCommonSave : NSObject
+ (void)saveValue:(id)value key:(NSString *)key;
+ (void)removeFromKey:(NSString *)key;
+ (id)getValueFromKey:(NSString *)key;
+ (void)clear;
@end
