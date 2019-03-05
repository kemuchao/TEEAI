//
//  ButtonContent.m
//  MifiManager
//
//  Created by notion on 2018/5/2.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "ButtonContent.h"

@implementation ButtonContent

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    return self;
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return self.bounds;
}
@end
