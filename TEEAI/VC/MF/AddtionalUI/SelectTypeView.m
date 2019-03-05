//
//  SelectTypeView.m
//  MifiManager
//
//  Created by notion on 2018/4/26.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "SelectTypeView.h"

@implementation SelectTypeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title value:(NSString *)value{
    self = [super initWithFrame:frame];
    CGFloat originRightX = 20;
    
    CGFloat imageHeight = HeightLabel;
    CGFloat imageWidth = imageHeight/36*20;
    UIImageView *arrowRight = [[UIImageView alloc] initWithFrame:CGRectMake(VIEW_WIDTH(self) - originRightX - imageWidth, (VIEW_HEIGHT(self) - imageHeight)/2, imageWidth, imageHeight)];
    arrowRight.image = IMAGE(@"ArrowRightWhite");
    arrowRight.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:arrowRight];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, VIEW_Y(arrowRight), VIEW_WIDTH(self) -originRightX/2-originRightX - VIEW_WIDTH(arrowRight), HeightLabel)];
    label.textAlignment = NSTextAlignmentRight;
    label.text = value;
    label.font = FontNormal;
    label.textColor = ColorWhite;
    [self addSubview:label];
    _labelValue = label;
    
    UIButton *button = [[UIButton alloc] initWithFrame:self.bounds];
//    [button setBackgroundColor:ColorRed];
    [self addSubview:button];
    _button = button;
    return self;
}

- (void)resetValue:(NSString *)value{
    _labelValue.text = value;
}
@end
