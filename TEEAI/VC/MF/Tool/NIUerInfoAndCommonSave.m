//
//  NIUerInfoAndCommonSave.m
//  MifiManager
//
//  Created by notion on 2018/3/29.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "NIUerInfoAndCommonSave.h"

@implementation NIUerInfoAndCommonSave
+ (void)saveValue:(id)value key:(NSString *)key{
    NSLog(@"setValue：%@ for key == %@",value,key);
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
}
+ (void)removeFromKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (id)getValueFromKey:(NSString *)key{
    id value =  [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return value;
}

+ (void)clear{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *dic = [userDefaults dictionaryRepresentation];
    for (id  key in dic) {
        [userDefaults removeObjectForKey:key];
    }
    [userDefaults synchronize];

}
@end
