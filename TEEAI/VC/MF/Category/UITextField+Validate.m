//
//  UITextField+Validate.m
//  MifiManager
//
//  Created by notion on 2018/3/30.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "UITextField+Validate.h"

@implementation UITextField (Validate)
- (NSString *)validateWithMethod:(NSString *)method{
    NSString *error;
    if (self.text.length == 0) {
        return @"空";
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",method];
    BOOL isValid = [predicate evaluateWithObject:self.text];
    if(!isValid) error = ValidFailCommonError;
    return error;
}
- (void)setTitle:(NSString *)title imageArray:(NSArray<UIImage *> *)imageArray secureText:(BOOL)secureText selected:(BOOL)selected{
//    CGFloat widthLabel = title?VIEW_WIDTH(self)/3+20:15;
//    NSString *labelTitle = title?[NSString stringWithFormat:@"  %@",title]:@"";
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(MarginX, 0, widthLabel, VIEW_HEIGHT(self))];
//    label.textAlignment = NSTextAlignmentLeft;
//    label.textColor = [UIColor whiteColor];
//    label.font = FontLarge;
//    label.backgroundColor = [UIColor clearColor];
//    label.text = labelTitle;
//    self.leftView = label;
    self.leftViewMode = UITextFieldViewModeAlways;
    self.secureTextEntry = secureText;
    if (secureText) {
        self.secureTextEntry = !selected;
    }
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    if (imageArray) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, VIEW_HEIGHT(self), VIEW_HEIGHT(self))];
        [button setUserInteractionEnabled:false];
        if(imageArray.count >= 1){
            [button setImage:imageArray[0] forState:UIControlStateNormal];
        }
        if (imageArray.count >= 2) {
            [button setImage:imageArray[1] forState:UIControlStateSelected];
            [button setUserInteractionEnabled:YES];
        }
        [self setRightView:button];
        button.selected = selected;
        [self setRightViewMode:UITextFieldViewModeAlways];
        CGFloat top = VIEW_HEIGHT(self)/4;
        [button setImageEdgeInsets:UIEdgeInsetsMake(top, top, top, top)];
        [button addEvent:^(UIButton *btn){
            btn.selected = !btn.selected;
            self.secureTextEntry = !self.secureTextEntry;
        }];
    }
}

@end
