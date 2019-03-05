//
//  NSString+NI.m
//  mifi
//
//  Created by yueguangkai on 15/10/22.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Extension)

-(NSString *) uniEncode
{
    NSUInteger length = [self length];
    NSMutableString *s = [NSMutableString stringWithCapacity:0];
    for (int i = 0;i < length; i++) {
        [s appendFormat:@"%04x",[self characterAtIndex:i]];
    }
    return s;
}

-(NSString *) uniDecode
{
    unsigned long n = self.length / 4 ;
    NSMutableString *result = [[NSMutableString alloc] init];
    for (int i= 0; i < n; i++) {
        int start = i * 4;
        NSString *s = [self substringWithRange:NSMakeRange(start, 4)];
        NSString *tempStr1 = [@"\\U" stringByAppendingString:s];
        NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
        NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
        NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
        NSString *resultStr = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:nil error:nil];
        [result appendString:resultStr];
    }
    return result;
}

- (NSString *)uniDecodeUSSD{
    NSArray *subStrArray = [self componentsSeparatedByString:@" "];
    NSMutableString *result = [NSMutableString string];
    BOOL isEmpty = false;
    for (int i=0; i<subStrArray.count; i++) {
        NSString *subStr = subStrArray[i];
        if(subStr.length > 4){
            isEmpty = true;
            break;
        }
    }
    if(isEmpty){
        for (int i = 0; i<subStrArray.count; i++) {
            NSString *hexStr = subStrArray[i];
            NSNumber *intNumber = [self numberHexString:hexStr];
            NSString *intStr = [NSString stringWithFormat:@"%c",intNumber.intValue];
            [result appendString:intStr];
        }
    }else{
        NSString *newSelf = [NSString stringWithFormat:@"%@",self];
        int append = self.length%4;
        switch (append) {
            case 1:
            newSelf = [NSString stringWithFormat:@"%@0000",self];
            break;
            
            case 2:
            newSelf = [NSString stringWithFormat:@"%@00",self];
            break;
            
            case 3:
            newSelf = [NSString stringWithFormat:@"%@0",self];
            break;
            
            default:
            break;
        }
        for(int i =0;i<newSelf.length/4;i++){
            NSString *hexStr = subStrArray[i];
            NSNumber *intNumber = [self numberHexString:hexStr];
            NSString *intStr = [NSString stringWithFormat:@"%c",intNumber.intValue];
            [result appendString:intStr];
        }
    }
    return result;
}

- (void)dealStr{
    
    
}
// 16进制转10进制

- (NSNumber *) numberHexString:(NSString *)aHexString
{
    // 为空,直接返回.
    if (nil == aHexString)
    {
        return nil;
    }
    NSScanner * scanner = [NSScanner scannerWithString:aHexString];
    unsigned long long longlongValue;
    [scanner scanHexLongLong:&longlongValue];
    //将整数转换为NSNumber,存储到数组中,并返回.
    NSNumber * hexNumber = [NSNumber numberWithLongLong:longlongValue];
    return hexNumber;
}

-(NSString *) md5
{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)self.length, digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i =0 ; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return result;
}

- (NSString *)transforFromASCII{
    [self stringByReplacingOccurrencesOfString:@" " withString:@"0"];
    return [self uniDecode];
}

- (int)getIntFromASCIIStr:(NSString *)subStr2{
    int subInt2 = 0;
    if ([subStr2 isEqualToString:@"a"]) {
        subInt2 = 10;
    }else if ([subStr2 isEqualToString:@"b"]){
        subInt2 = 11;
    }else if ([subStr2 isEqualToString:@"c"]){
        subInt2 = 12;
    }else if ([subStr2 isEqualToString:@"d"]){
        subInt2 = 13;
    }else if ([subStr2 isEqualToString:@"e"]){
        subInt2 = 14;
    }else if ([subStr2 isEqualToString:@"f"]){
        subInt2 = 15;
    }else{
        subInt2 = subStr2.intValue;
    }
    
    return subInt2;
}


-(BOOL) isGSM7Code
{
    int len = 0;
    for (int i = 0; i < self.length; i++) {
        char chr = [self characterAtIndex:i];
        if (((chr >= 0x20 && chr <= 0x7f) || 0x0c == chr || 0x0a == chr || 0x0d == chr)
            && 0x60 != chr) {
            ++len;
        }
    }
    return len == self.length;
}

-(BOOL) isChinese
{
    for (int i = 0; i < self.length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [self substringWithRange:range];
        const char *cString = [subString UTF8String];
        if (strlen(cString) == 3) {
            return YES;
        }
    }
    return  NO;
}

- (NSString *)time{
    NSArray *timeArray = [self componentsSeparatedByString:@","];
    NSString *time = [NSString stringWithFormat:@"20%@-%@-%@ %@:%@",timeArray[0],timeArray[1],timeArray[2],timeArray[3],timeArray[4]];
    return time;
}


- (CGFloat)stringWidthWithFont:(UIFont *)font{
    CGSize size = [self sizeWithAttributes:@{NSFontAttributeName:font}];
    return size.width;
}

- (BOOL)isInvalidUSSD{
    NSString *regex = @"^[*]{1}[0-9*]{2,10}[#]{1}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

@end
