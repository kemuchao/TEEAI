//
//  UIButton+Event.m
//  MifiManager
//
//  Created by notion on 2018/3/21.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "UIButton+Event.h"
#import <objc/runtime.h>
@implementation UIButton (Event)

static char ActionTag;
- (void)layoutWithModel:(NIContentModel)contentModel padding:(CGFloat)padding title:(NSString *)title image:(UIImage *)image{
    [self setTitle:title forState:UIControlStateNormal];
    [self setImage:image forState:UIControlStateNormal];
    [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    self.titleEdgeInsets = UIEdgeInsetsZero;
    self.imageEdgeInsets = UIEdgeInsetsZero;
    
    CGRect titleRect = self.titleLabel.frame;
//    titleRect.size.height = 21;
//    titleRect.size.width = 50;
    CGRect imageRect = self.imageView.frame;
    CGFloat totalHeight = titleRect.size.height + padding + imageRect.size.height;
//    imageRect.size.width = 36;
//    imageRect.size.height = 20;
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat selfHeight = self.bounds.size.height;
    switch (contentModel) {
        case NIContentModelNormal:
        case NIContentModelRight:
            self.titleEdgeInsets = UIEdgeInsetsMake(0, padding/2, 0, -padding/2);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -padding/2, 0, padding/2);
            break;
        case NIContentModelLeft:
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageRect.size.width+padding/2), 0, (imageRect.size.width + padding/2));
            self.imageEdgeInsets = UIEdgeInsetsMake(0, (titleRect.size.width + padding/2), 0, -(titleRect.size.width+padding/2));
            break;
        case NIContentModelTop:
            self.titleEdgeInsets =UIEdgeInsetsMake(((selfHeight - totalHeight)/2 + imageRect.size.height + padding - titleRect.origin.y),
                                              (selfWidth/2 - titleRect.origin.x - titleRect.size.width /2) - (selfWidth - titleRect.size.width) /2,
                                              -((selfHeight - totalHeight)/2 + imageRect.size.height + padding - titleRect.origin.y),
                                              -(selfWidth/2 - titleRect.origin.x - titleRect.size.width /2) - (selfWidth - titleRect.size.width) /2);
            
            self.imageEdgeInsets =UIEdgeInsetsMake(((selfHeight - totalHeight)/2 - imageRect.origin.y),
                                              (selfWidth /2 - imageRect.origin.x - imageRect.size.width /2),
                                              -((selfHeight - totalHeight)/2 - imageRect.origin.y),
                                              -(selfWidth /2 - imageRect.origin.x - imageRect.size.width /2));
            break;
        case NIContentModelBottom:
            self.titleEdgeInsets =UIEdgeInsetsMake(((selfHeight - totalHeight)/2 - titleRect.origin.y),
                                              (selfWidth/2 - titleRect.origin.x - titleRect.size.width /2) - (selfWidth - titleRect.size.width) /2,
                                              -((selfHeight - totalHeight)/2 - titleRect.origin.y),
                                              -(selfWidth/2 - titleRect.origin.x - titleRect.size.width /2) - (selfWidth - titleRect.size.width) /2);
            
            self.imageEdgeInsets =UIEdgeInsetsMake(((selfHeight - totalHeight)/2 + titleRect.size.height + padding - imageRect.origin.y),
                                              (selfWidth /2 - imageRect.origin.x - imageRect.size.width /2),
                                              -((selfHeight - totalHeight)/2 + titleRect.size.height + padding - imageRect.origin.y),
                                              -(selfWidth /2 - imageRect.origin.x - imageRect.size.width /2));
            break;
        default:
            break;
    }
}

- (void)addEvent:(ButtonBlock)block{
    objc_setAssociatedObject(self, &ActionTag, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addEvent:(UIControlEvents)controlEvents withBlock:(ButtonBlock)block{
    objc_setAssociatedObject(self, &ActionTag, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(action:) forControlEvents:controlEvents];
}

- (void)action:(id)sender
{
    ButtonBlock blockAction = (ButtonBlock)objc_getAssociatedObject(self, &ActionTag);
    if (blockAction)
    {
        blockAction(self);
    }
}

@end
