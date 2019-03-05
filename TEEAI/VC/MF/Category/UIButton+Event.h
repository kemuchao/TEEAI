//
//  UIButton+Event.h
//  MifiManager
//
//  Created by notion on 2018/3/21.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    NIContentModelNormal = 0,//普通样式
    NIContentModelLeft = 1,//标题居左
    NIContentModelRight = 2,//标题居右
    NIContentModelTop = 3,//标题居上
    NIContentModelBottom = 4,//标题居下
    
} NIContentModel;
typedef void(^ButtonBlock) (UIButton *button);

@interface UIButton (Event)

/**
 设置按钮的布局，标题和图片的尺寸

 @param contentModel 类型
 */
- (void)layoutWithModel:(NIContentModel)contentModel padding:(CGFloat)padding title:(NSString *)title image:(UIImage *)image;

- (void)addEvent:(ButtonBlock)block;
- (void)addEvent:(UIControlEvents)controlEvents withBlock:(ButtonBlock)block;
@end
