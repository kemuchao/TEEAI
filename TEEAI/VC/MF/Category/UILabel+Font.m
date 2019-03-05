//
//  UILabel+Font.m
//  MifiManager
//
//  Created by notion on 2018/4/23.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "UILabel+Font.h"

@implementation UILabel (Font)

/**
 设置标签的颜色和字体

 @param color 颜色
 @param font 字体
 */
- (void)setColor:(UIColor *)color font:(UIFont *)font{
    self.textColor = color;
    self.font = font;
}
@end
