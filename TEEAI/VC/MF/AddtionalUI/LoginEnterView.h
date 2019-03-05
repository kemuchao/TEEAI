//
//  LoginEnterView.h
//  MifiManager
//
//  Created by notion on 2018/4/19.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginEnterView : UIView
- (instancetype)initWithFrame:(CGRect)frame name:(NSString *)name psw:(NSString *)psw;
@property (nonatomic, strong) UITextField *textName;
@property (nonatomic, strong) UITextField *textPsw;
@end
