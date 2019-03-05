//
//  ImageLabel.m
//  MifiManager
//
//  Created by notion on 2018/4/9.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "ImageLabel.h"

@implementation ImageLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame Image:(UIImage *)image title:(NSString *)title{
    CGFloat imageWidth = HeightLabel;
    CGFloat labelWidth = frame.size.width - imageWidth - MarginX;
    CGFloat titleHeight = [self getText:title HeightWithWidth:labelWidth andFont:FontSyWithSize(15)];
    CGFloat labelHeight = titleHeight>HeightLabel?titleHeight+10:HeightLabel;
    CGRect rect = frame;
    rect.size.height = labelHeight;
    frame = rect;
    self = [super initWithFrame:frame];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageWidth, imageWidth)];
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageWidth +MarginX, 0, labelWidth, labelHeight)];
    label.text = title;
    label.numberOfLines = 0;
    label.font = FontNormal;
    label.textColor = ColorWhite;
    [self addSubview:label];
    
    return self;
}

/**得到字符高度*/
- (CGFloat)getText:(NSString *)text HeightWithWidth:(CGFloat)width andFont:(UIFont *)font{
    NSDictionary * attr=@{NSFontAttributeName:font};
    CGRect size = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil];
    return size.size.height;
}
@end
