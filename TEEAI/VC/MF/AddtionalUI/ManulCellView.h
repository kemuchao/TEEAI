//
//  ManulCellView.h
//  MifiManager
//
//  Created by notion on 2018/4/20.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManulCellView : UIView
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIButton *button;
- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image title:(NSString *)title;
- (void)resetTitle:(NSAttributedString *)title;
- (void)resetImage:(UIImage *)image;
@end
