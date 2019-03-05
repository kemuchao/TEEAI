//
//  UIButton+Round.h
//  MifiManager
//
//  Created by notion on 2018/3/23.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    BoundSideTop = 0,
    BoundSideLeft = 1,
    BoundSideRight = 2,
    BoundSideBottom = 3,
    BoundSideLeftTop = 4,
    BoundSideLeftBottom = 5,
    BoundSideRightTop = 6,
    BoundSideRightBottom = 7,
    
} BoundSide;
@interface UIButton (Round)
- (void)roundSide:(BoundSide)side borderCornerRadius:(CGFloat)cornerRadius;
@end
