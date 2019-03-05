//
//  UIView+Action.m
//  MifiManager
//
//  Created by notion on 2018/4/2.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "UIView+Action.h"

@implementation UIView (Action)
- (void)setLayerWithBorderWidth:(CGFloat)width BorderColor:(UIColor *)color CornerRadius:(CGFloat)cornerRadius{
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
    self.layer.cornerRadius = cornerRadius;
    self.clipsToBounds = YES;
}
- (void)setBottomLineWithOrginX:(CGFloat)originX{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(originX, VIEW_HEIGHT(self) - 1, SCREEN_WIDTH-2*originX, 1)];
    line.backgroundColor = ColorWhite;
    line.alpha = 0.5;
    [self addSubview:line];
}
- (void)setTopLineWithOriginX:(CGFloat)originX{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(originX, 0, SCREEN_WIDTH-2*originX, 1)];
    line.backgroundColor = ColorWhite;
    line.alpha = 0.5;
    [self addSubview:line];
}

- (void)setLinWithOriginX:(CGFloat)originX originY:(CGFloat)originY color:(UIColor *)color{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(originX, originY, SCREEN_WIDTH-2*originX, 1)];
    line.backgroundColor = color;
    [self addSubview:line];
}
- (void)clear{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^{
        for (UIView *subView in self.subviews) {
            [subView removeFromSuperview];
        }
    });
    
}
@end
