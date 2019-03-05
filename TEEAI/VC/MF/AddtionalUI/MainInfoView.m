//
//  MainInfoView.m
//  MifiManager
//
//  Created by notion on 2018/4/19.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "MainInfoView.h"
#import "ZZCircleProgress.h"
@implementation MainInfoView{
    UIView *_precessView;
    UIView *_powerPrecessView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self setBackgroundColor:ColorClear];
    return self;
}

-(void)setProgress:(float)progress {
    _progress = progress;
}
@end
