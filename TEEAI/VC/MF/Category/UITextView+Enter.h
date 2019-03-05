//
//  UITextView+Enter.h
//  MifiManager
//
//  Created by notion on 2018/3/23.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Enter)
<UITextViewDelegate>
- (instancetype)initWithFrame:(CGRect)frame textPlaceholder:(NSString *)placeholder textColor:(UIColor *)textColor placeholderColor:(UIColor *)placeholderColor;

@end
