//
//  UITextView+Enter.m
//  MifiManager
//
//  Created by notion on 2018/3/23.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "UITextView+Enter.h"


@implementation UITextView (Enter)


- (instancetype)initWithFrame:(CGRect)frame textPlaceholder:(NSString *)placeholder textColor:(UIColor *)textColor placeholderColor:(UIColor *)placeholderColor{
    self = [super initWithFrame:frame];
    
    return self;
}
- (void)setPlaceholder:(NSString *)placeholder{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}
@end
