//
//  NotionConfirmButton.m
//  MifiManager
//
//  Created by notion on 2018/3/21.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "NotionConfirmButton.h"
@interface NotionConfirmButton()
@property (nonatomic, strong) NSString *title;
@end
@implementation NotionConfirmButton


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title isEnabled:(BOOL)isEnabled{
    self = [super initWithFrame:frame];
    _title = title;
    _isEnabled = isEnabled;
    [self loadMainView];
    return self;
}

- (void)loadMainView{
    UIButton *button = [[UIButton alloc] initWithFrame:self.bounds];
    [button setTitle:_title forState:UIControlStateNormal];
    button.layer.cornerRadius = CGRectGetHeight(button.frame)/2;
    button.layer.borderWidth = 1;
    button.clipsToBounds = YES;
    
    [self addSubview:button];
    _confirm = button;
    [self setIsEnabled:_isEnabled];
}

- (void)setIsEnabled:(BOOL)isEnabled{
//    _confirm.enabled = isEnabled;
    UIColor *bgColor = isEnabled?[UIColor blueColor]:[UIColor whiteColor];
    UIColor *tintColor = isEnabled?[UIColor whiteColor]:[UIColor grayColor];
    UIColor *borderColor = isEnabled?[UIColor whiteColor]:[UIColor grayColor];
    [_confirm setTitleColor:tintColor forState:UIControlStateNormal];
    [_confirm setBackgroundColor:bgColor];
    [_confirm.layer setBorderColor:borderColor.CGColor];
}

@end
