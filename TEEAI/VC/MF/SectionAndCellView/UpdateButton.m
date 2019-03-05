//
//  UpdateButton.m
//  MifiManager
//
//  Created by notion on 2018/3/23.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "UpdateButton.h"

@implementation UpdateButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame buttonFrame:(CGRect)buttonFrame Title:(NSString *)title isHighlight:(BOOL)highlight{
    self = [super initWithFrame:frame];
    UIColor *textColor = highlight?ColorWhite:NormalGray;
    UIColor *bgColor = highlight?NormalBlue:ColorWhite;
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:FontSyWithSize(20)];
    [self addSubview:button];
    [button setBackgroundColor:bgColor];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    button.enabled = highlight;
    _btn = button;
    return self;
}

@end
