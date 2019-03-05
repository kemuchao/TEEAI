//
//  NSString+NI.h
//  mifi
//
//  Created by yueguangkai on 15/10/22.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

-(NSString *) uniEncode;

-(NSString *) uniDecode;
-(NSString *)uniDecodeUSSD;

-(NSString *) md5;

- (NSString *)transforFromASCII;

- (NSString *)time;

-(BOOL) isGSM7Code;

-(BOOL) isChinese;

- (CGFloat)stringWidthWithFont:(UIFont *)font;
- (BOOL)isInvalidUSSD;
@end
