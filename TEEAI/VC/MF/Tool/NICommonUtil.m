//
//  NICommonUtil.m
//  mifi
//
//  Created by yueguangkai on 15/10/22.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import "NICommonUtil.h"

@implementation NICommonUtil

+(NSString *) serverDateTimeStringWithDate:(NSDate *) date timeZone:(NSTimeZone *)timezone
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSString *showtimeNew = [formatter stringFromDate:date];
    if (showtimeNew) {
        NSMutableString *result = [[NSMutableString alloc] init];
        NSArray *ss = [showtimeNew componentsSeparatedByString:@"-"];
        int flag = 1;
        for (NSString *s in ss) {
            NSLog(@"%@",s);
            if (flag == 1) {
                [result appendString:[s substringWithRange:NSMakeRange(s.length - 2, 2)]];
                [result appendString:@","];
            } else if(flag > 3) {
                if ([s hasPrefix:@"0"]) {
                    [result appendString:[s substringFromIndex:1]];
                } else {
                    [result appendString:s];
                }
                [result appendString:@","];
            } else {
                [result appendString:s];
                [result appendString:@","];
            }
            flag++;
        }
        NSInteger offsetSeconds = [timezone secondsFromGMT];
        int offSet = (int)offsetSeconds / 3600;
        if (offSet > 0) {
            [result appendString:@"%2B"];
            [result appendFormat:@"%d", offSet];
        } else {
            [result appendFormat:@"%d", offSet];
        }
        return result;
    }
    return nil;
}

+(NSString *) clientDateTimeStringWithServerDateTimeString:(NSString *) serverDateTime
{
    if (!serverDateTime) {
        NSMutableString *temp = [[NSMutableString alloc]init];
        NSArray *array = [serverDateTime componentsSeparatedByString:@","];
        int flag = 1;
        for (NSString *str in array) {
            if ([str hasPrefix:@"+"]) {
                break;
            }
            
            if (flag > 1 && flag < 3) {
                [temp appendString:str];
                [temp appendString:@"/"];
            } else if (flag == 3) {
                [temp appendString:str];
                [temp appendString:@" "];
            } else if (flag == 4) {
                if(serverDateTime.length == 1){
                    [temp appendFormat:@"0%@", str];
                    [temp appendString:@":"];
                } else {
                    [temp appendFormat:@"%@", str];
                    [temp appendString:@":"];
                }
            } else if (flag == 5) {
                if(str.length == 1) {
                    [temp appendFormat:@"0%@", str];
                } else {
                    [temp appendString:str];
                }
            }
            flag++;
        }
        return temp;
    }
    return nil;
}

+(NSString *) bytesToAvaiUnit:(int) bytes
{
    if (bytes < 1024) {//B
        return [NSString stringWithFormat:@"%dB", bytes];
    } else if(bytes >= 1024 && bytes < 1024 * 1024) {//KB
        return [NSString stringWithFormat:@"%.1fKB", (double)bytes / 1024];
    } else if(bytes >= 1024 * 1024 && bytes < 1024 * 1024 * 1024) {//MB
        return  [NSString stringWithFormat:@"%.2fMB", (double)bytes / (1024 * 1024)];
    } else {//GB
        return [NSString stringWithFormat:@"%.2fGB", (double)bytes / ( 1024 * 1024 * 1024)];
    }
}

+(NSString *) currentTimeMillisString {
    NSDate *date = [NSDate date];
    return [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970] * 1000];
}

#pragma mark - 首页网络处理

/**
 CPE 获取SIM卡显示名称
 */
+ (NSString *)getCPENetNameWithSimStatus:(NSString *)simStatus PinStaus:(NSString *)pinStatus{
    if ([simStatus isEqualToString:@"0"]) {
        return Localized(@"NetSIMAbsent");
    }else if ([simStatus isEqualToString:@"2"]){
        return Localized(@"NetSIMError");
    }else{
        if ([pinStatus isEqualToString:@"2"]) {
            return Localized(@"NetPINNeed");
        }else if ([pinStatus isEqualToString:@"3"]){
            return Localized(@"NetPUKNeed");
        }else if ([pinStatus isEqualToString:@"5"]){
            return Localized(@"NetReady");
        }else{
            return Localized(@"NetUndefined");
        }
    }
}

/**
 获取CPE显示图片
 */
+ (UIImage *)getCPENetShowImageWithSimStatus:(NSString *)simStatus PinStatus:(NSString *)pinStatus{
    if ([simStatus isEqualToString:@"0"]) {
        return IMAGE(@"MainOneNoCard");
    }else if ([simStatus isEqualToString:@"2"]){
        return IMAGE(@"MainOneCard");
    }else{
        if ([pinStatus isEqualToString:@"2"]) {
            return IMAGE(@"MainOneCard");
        }else if ([pinStatus isEqualToString:@"3"]){
            return IMAGE(@"MainOneCard");
        }else if ([pinStatus isEqualToString:@"5"]){
            return IMAGE(@"MainOne4");
        }else{
            return IMAGE(@"MainOneNoSignal");
        }
    }
}
/**
 获取当前网络情况

 */
+ (NSString *) getNetName:(NSString *)name ModeName:(NSString *)sysSubMode SIMStatus:(NSString *)SIMStatus PINStatus:(NSString *)PINStatus{
    //有网
    //SIM卡缺失
    if ([SIMStatus isEqualToString:@"1"]) {
        return Localized(@"NetSIMAbsent");
    }
//    else if ([PINStatus isEqualToString:@"0"]) {
//        return Localized(@"NetPINError");
//    }
    else if ([PINStatus isEqualToString:@"1"]){
        return Localized(@"NetPINNeed");
    }else if ([PINStatus isEqualToString:@"2"]){
        return Localized(@"NetPUKNeed");
    }else if ([PINStatus isEqualToString:@"3"]){
        return Localized(@"NetSIMLock");
    }else if ([PINStatus isEqualToString:@"4"]){
        return Localized(@"NetSIMError");
    }else{
        if (name && name.length > 0) {
            if([sysSubMode isEqualToString:@"2"]){
                return [NSString stringWithFormat:@"%@  2G",name];
            }else if ([sysSubMode isEqualToString:@"3"]){
                return [NSString stringWithFormat:@"%@ 2G",name];
            }else if ([sysSubMode isEqualToString:@"5"]){
                return [NSString stringWithFormat:@"%@ 3G",name];
            }else if ([sysSubMode isEqualToString:@"6"]){
                return [NSString stringWithFormat:@"%@ 3G",name];
            }else if ([sysSubMode isEqualToString:@"7"]){
                return [NSString stringWithFormat:@"%@ 3G",name];
            }else if ([sysSubMode isEqualToString:@"17"]){
                return [NSString stringWithFormat:@"%@ 4G",name];
            }else{
                return  [NSString stringWithFormat:@"%@ %@",name,@"未知网络"];
            }
        }else{
            return @"网络失败";
        }
    }
    
    
}
/**
 获取当前网络情况
 
 @param name 网络名称
 @param sysSubMode 信号名称
 @return 网络+信号名称
 */
+ (UIImage *) getNetShowImageWithNetName:(NSString *)name ModeName:(NSString *)sysSubMode SIMStatus:(NSString *)SIMStatus PINStatus:(NSString *)PINStatus{
    //有网
    //SIM卡缺失
    if ([SIMStatus isEqualToString:@"1"]) {
        return IMAGE(@"MainOneNoCard");
    }
//    else if ([PINStatus isEqualToString:@"0"]) {
//        return IMAGE(@"MainOneCard");
//    }
    else if ([PINStatus isEqualToString:@"1"]){
        return IMAGE(@"MainOneCard");
    }else if ([PINStatus isEqualToString:@"2"]){
        return IMAGE(@"MainOneCard");
    }else if ([PINStatus isEqualToString:@"3"]){
        return IMAGE(@"MainOneCard");
    }else if ([PINStatus isEqualToString:@"4"]){
        return IMAGE(@"MainOneCard");
    }else{
        if (name && name.length > 0) {
            if([sysSubMode isEqualToString:@"2"]){
                return IMAGE(@"MainOne1");
            }else if ([sysSubMode isEqualToString:@"3"]){
                return IMAGE(@"MainOne2");
            }else if ([sysSubMode isEqualToString:@"5"]){
                return IMAGE(@"MainOne3");;
            }else if ([sysSubMode isEqualToString:@"6"]){
                return IMAGE(@"MainOne3");;
            }else if ([sysSubMode isEqualToString:@"7"]){
                return IMAGE(@"MainOne3");;
            }else if ([sysSubMode isEqualToString:@"17"]){
                return IMAGE(@"MainOne4");;
            }else{
                return  IMAGE(@"MainOne4");
            }
        }else{
             return IMAGE(@"MainOneNoSignal");
        }
    }
}
@end
