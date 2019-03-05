//
//  SendMessage.h
//  MifiManager
//
//  Created by notion on 2018/3/23.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Round.h"
typedef void (^MessageSendBlock)(NSString *phone,NSString *message);
@interface SendMessage : UIView
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) UIButton *send;
@property (nonatomic, strong) UITextField *textTelL;
@property (nonatomic, strong) UITextView *textMsgL;
@property (nonatomic, copy) MessageSendBlock block;
+ (instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder delegate:(UIViewController *)delegate;
- (void)show;
- (void)close;

@end
