//
//  ManulCellView.m
//  MifiManager
//
//  Created by notion on 2018/4/20.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "ManulCellView.h"
@interface ManulCellView()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UILabel *label;

@end
@implementation ManulCellView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image title:(NSString *)title{
    self = [super initWithFrame:frame];
    [self setImage:image];
    [self setTitle:title];
    [self loadMainView];
    return self;
}

- (void)loadMainView{
    CGFloat imgaeWidth = VIEW_HEIGHT(self)/3;
    CGFloat originX = (VIEW_WIDTH(self) - imgaeWidth)/2;
    CGFloat originY = (VIEW_HEIGHT(self)/2+10 - imgaeWidth);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, originY, imgaeWidth, imgaeWidth)];
    imageView.image = _image;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    _imageView = imageView;
    
    CGFloat originYLabel = VIEW_HEIGHT(self)*0.75 - HeightLabel/2;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, originYLabel, VIEW_WIDTH(self), HeightLabel)];
    label.text = _title;
    label.textColor = [UIColor colorWithHexString:ColorBlueLight];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = FontRegular;
    [self addSubview:label];
    _label = label;
    
    UIButton *button = [[UIButton alloc] initWithFrame:self.bounds];
    _button = button;
    [self addSubview:button];
}

/**
 重置标题

 @param title 标题
 */
- (void)resetTitle:(NSAttributedString *)title{
    _label.attributedText = title;
}

/**
 重置图片

 @param image 图片
 */
- (void)resetImage:(UIImage *)image{
    _imageView.image = image;
}
@end
