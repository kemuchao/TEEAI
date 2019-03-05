//
//  UIButton+Round.m
//  MifiManager
//
//  Created by notion on 2018/3/23.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "UIButton+Round.h"

@implementation UIButton (Round)
- (void)roundSide:(BoundSide)side borderCornerRadius:(CGFloat)cornerRadius
{
    UIBezierPath *maskPath;
    
    if (side == BoundSideLeft)
        maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                         byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerBottomLeft)
                                               cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    else if (side == BoundSideRight)
        maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                         byRoundingCorners:(UIRectCornerTopRight|UIRectCornerBottomRight)
                                               cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    else if (side == BoundSideTop)
        maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                         byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
                                               cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    else if (side == BoundSideBottom)
        maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                         byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight)
                                               cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    maskLayer.fillColor = ColorWhite.CGColor;
    maskLayer.strokeColor = ColorWhite.CGColor;
    // Set the newly created shape layer as the mask for the image view's layer
//    UIView *testView = [[UIView alloc] initWithFrame:self.bounds];
//    [testView.layer insertSublayer:maskLayer atIndex:0];
//    testView.backgroundColor = UIColor.clearColor;
    [self.layer insertSublayer:maskLayer atIndex:0];
    
}  
@end
