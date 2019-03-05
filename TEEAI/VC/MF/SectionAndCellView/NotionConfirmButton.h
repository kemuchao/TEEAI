//
//  NotionConfirmButton.h
//  MifiManager
//
//  Created by notion on 2018/3/21.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotionConfirmButton : UIView
@property (nonatomic, assign) BOOL isEnabled;
@property (nonatomic, strong) UIButton *confirm;
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title isEnabled:(BOOL)isEnabled;

@end
