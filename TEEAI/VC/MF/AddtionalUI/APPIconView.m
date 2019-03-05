//
//  APPIconView.m
//  MifiManager
//
//  Created by notion on 2018/4/21.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "APPIconView.h"

@implementation APPIconView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH(self), VIEW_WIDTH(self))];
    image.image = [UIImage imageNamed:@"login_icon"];
    [self addSubview:image];
//    NSMutableArray *imageArray = [NSMutableArray array];
//    for (int i =0; i < 9; i++) {
//        NSString *imageString = [NSString stringWithFormat:@"APPICON%d",i];
//        [imageArray addObject:IMAGE(imageString)];
//    }
//    image.animationImages = imageArray;
//    image.animationDuration = 2.0;
//    image.animationRepeatCount = MAXFLOAT;
//    image.contentMode = UIViewContentModeScaleAspectFit;
//    [image startAnimating];
    return self;
}
@end
