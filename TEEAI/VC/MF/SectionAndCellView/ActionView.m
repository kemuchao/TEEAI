//
//  ActionView.m
//  MifiManager
//
//  Created by notion on 2018/4/2.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "ActionView.h"
#import "IQKeyboardManager.h"
#import "FlowNumberSetting.h"
#import <objc/runtime.h>
@interface ActionView()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *subView;
@property (nonatomic, strong) IQKeyboardManager *manager;
@end
@implementation ActionView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithSubView:(UIView *)subView{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    UIScrollView *bgView = [[UIScrollView alloc] initWithFrame:self.bounds];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.2;
    [self addSubview:bgView];
    if(subView)[self addSubview:subView];_subView = subView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    tap.delegate = self;
     [bgView addGestureRecognizer:tap];
//    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
//    swipe.delegate = self;
//    swipe.direction = UISwipeGestureRecognizerDirectionDown;
   
//    [bgView addGestureRecognizer:swipe];
//    [self addGestureRecognizer:swipe];
    IQKeyboardManager *manager =  [IQKeyboardManager sharedManager];
//    manager.resignFirstResponderGesture.delegate = self;
    _manager = manager;
    return self;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    [self hide];
    UIView *touchView = touch.view.superview;
    
    if ([touchView isKindOfClass:[UIButton class]]) {
        if (touchView.tag == 100) {
            //取消
            
        }else if (touchView.tag == 101){
            //确定
            for (UIView *subView in self.subviews) {
                if ([subView isKindOfClass:[FlowNumberSetting class]]) {
                    FlowNumberSetting *enterView = (FlowNumberSetting *)subView;
                    NSString *title = [enterView getValue];
                    if (title) {
                        if (_delegate && [_delegate respondsToSelector:@selector(actionView:atIndexPath:ReceiveEnterValue:flowType:)]) {
                            [self.delegate actionView:self atIndexPath:_indexPath ReceiveEnterValue:[enterView getValue] flowType:enterView.type];
                        }
                    }
                }
            }
        }else{
            
        }
        
    }
    [self hide];
    return YES;
}

- (void)setBorderMarginY:(CGFloat)borderMarginY{
    _manager.keyboardDistanceFromTextField = borderMarginY;
}
- (void)show{
    [self showAction];
   _manager.enableAutoToolbar = NO;
}
- (void)hide{
    [self closeAction];
    [self removeFromSuperview];
    if (self.block) {
        self.block();
    }
    _manager.enableAutoToolbar = YES;
}
- (void)showAction{
    CATransition* transition = [CATransition animation];
    [transition setDuration:0.3];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    [transition setFillMode:kCAFillModeBoth];
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.layer addAnimation:transition forKey:kCATransition];
}
- (void)closeAction{
    CGRect frame = self.frame;
    frame.origin.y = SCREEN_HEIGHT;
    self.frame = frame;
    CATransition* transition = [CATransition animation];
    [transition setDuration:0.3];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromBottom;
    [transition setFillMode:kCAFillModeBoth];
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.layer addAnimation:transition forKey:kCATransition];
    
}

- (void)resetSubView:(UIView *)subView{
    if (_subView) {
        [_subView removeFromSuperview];
    }
//    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, VIEW_Y(subView), SCREEN_WIDTH, SCREEN_HEIGHT - VIEW_Y(subView))];
//    image.image = [UIImage imageNamed:@"viewBG"];
    
//    [self addSubview:image];
    [self addSubview:subView];
    [self setSubView:subView];
}
- (void)addIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
}
@end
