//
//  UpdateButton.h
//  MifiManager
//
//  Created by notion on 2018/3/23.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateButton : UIView
@property (nonatomic, strong) UIButton *btn;
- (instancetype)initWithFrame:(CGRect)frame buttonFrame:(CGRect)buttonFrame Title:(NSString *)title isHighlight:(BOOL)highlight;

@end
