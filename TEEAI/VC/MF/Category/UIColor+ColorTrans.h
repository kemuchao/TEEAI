//
//  UIColor+ColorTrans.h
//  MifiManager
//
//  Created by notion on 2018/4/19.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorTrans)

/**
 色值转化
 #000000 -> RGB -> UIColor

 @param stringToConvert 色值描述字符串
 @return 色值
 */
+ (UIColor*)colorWithHexString:(NSString*)stringToConvert;
@end
