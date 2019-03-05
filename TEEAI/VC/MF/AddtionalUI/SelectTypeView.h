//
//  SelectTypeView.h
//  MifiManager
//
//  Created by notion on 2018/4/26.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectTypeView : UIView
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UILabel *labelValue;
@property (nonatomic, strong) UIButton *button;
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title value:(NSString *)value;
- (void)resetValue:(NSString *)value;
@end
