//
//  UIView+Action.h
//  MifiManager
//
//  Created by notion on 2018/4/2.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Action)
- (void)setLayerWithBorderWidth:(CGFloat)width BorderColor:(UIColor *)color CornerRadius:(CGFloat)cornerRadius;
- (void)setBottomLineWithOrginX:(CGFloat)originX;
- (void)setTopLineWithOriginX:(CGFloat)originX;
- (void)setLinWithOriginX:(CGFloat)originX originY:(CGFloat)originY color:(UIColor *)color;
- (void)clear;
@end
