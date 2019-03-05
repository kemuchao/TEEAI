//
//  SendMessage.m
//  MifiManager
//
//  Created by notion on 2018/3/23.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "SendMessage.h"
#import "UIButton+Round.h"
#define BGViewTag 100
@interface SendMessage()
@property (nonatomic, strong) UIViewController *delegate;
@property (nonatomic, strong) UIView *bgView;
@end
static SendMessage *_messageView;
@implementation SendMessage

// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    
//}
+ (instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder delegate:(UIViewController *)delegate{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(){
        if (_messageView == nil){
            _messageView = [[SendMessage alloc] initWithFrame:frame placeholder:placeholder delegate:delegate];
        }
    });
    return _messageView;
}

- (instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder delegate:(UIViewController *)delegate{
    self = [super initWithFrame:frame];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT(self)-SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    image.image = [UIImage imageNamed:@"home_bg"];
    [self addSubview:image];
    self.layer.cornerRadius = 0;
    self.layer.borderColor = ColorClear.CGColor;
    self.layer.borderWidth = 1;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    if (self) {
        _delegate = delegate;
        
    }
    [self loadMainView];
    return self;
}

- (void)loadMainView{
    WeakSelf;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(MarginX, MarginY, SCREEN_WIDTH - 2*MarginX, HeightLabel)];
    label.text = @"接收信息";
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = FontRegular;
    [self addSubview:label];
    
    CGFloat iconWidth = 0*Ratio;
    
    UIView *textView = [[UIView alloc] initWithFrame:CGRectMake(MarginX, CGRectGetMaxY(label.frame)+MarginY,  SCREEN_WIDTH - MarginX*2 - iconWidth, HeightButton*Ratio)];
    [textView setLayerWithBorderWidth:BorderWidth BorderColor:BorderColorGreen CornerRadius:BorderCircle];
    textView.backgroundColor = [UIColor whiteColor];
    [self addSubview:textView];
    
    UITextField *textTel = [[UITextField alloc] initWithFrame:CGRectMake(MarginX, (HeightButton - HeightTextField)*Ratio/2, CGRectGetWidth(textView.bounds) - MarginX*2, HeightTextField*Ratio)];
    textTel.keyboardType = UIKeyboardTypePhonePad;
    textTel.placeholder = @"输入信息内容";
    [textView addSubview:textTel];
    _textTelL = textTel;
    
//    UIButton *buttonIcon = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(textView.frame), CGRectGetMinY(textView.frame), iconWidth, HeightButton*Ratio)];
//    [buttonIcon setImage:[UIImage imageNamed:@"iconConnect"] forState:UIControlStateNormal];
//    [buttonIcon setContentMode:UIViewContentModeCenter];
//    [buttonIcon addEvent:^(UIButton *btn){
//
//    }];
//    [self addSubview:buttonIcon];
    
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(MarginX, CGRectGetHeight(self.bounds) - MarginY*2 - HeightButton*Ratio, SCREEN_WIDTH-2*MarginX, MarginY + HeightButton*Ratio)];
    [bottom setBackgroundColor:ColorClear];
    [self addSubview:bottom];
    
    CGFloat Y = CGRectGetMaxY(textView.frame) + MarginY;
    CGFloat H = CGRectGetMinY(bottom.frame) - Y;
    UITextView *textMsg = [[UITextView alloc] initWithFrame:CGRectMake(MarginX, Y, SCREEN_WIDTH - 2*MarginX, H)];
    _textMsgL = textMsg;
    [textMsg setLayerWithBorderWidth:BorderWidth BorderColor:BorderColorGreen CornerRadius:BorderCircle];
    textMsg.backgroundColor = [UIColor whiteColor];
    
    textMsg.font = FontRegular;
    [self addSubview:textMsg];
    
    UIButton *buttonCancel = [[UIButton alloc] initWithFrame:CGRectMake(0, MarginY, VIEW_WIDTH(bottom)/2, HeightButton*Ratio)];
    [buttonCancel setTitle:@"取消" forState:UIControlStateNormal];
    [buttonCancel setTitleColor:[UIColor colorWithHexString:ColorBlueDeep] forState:UIControlStateNormal];
    [buttonCancel addEvent:^(UIButton *btn){
        [weakSelf cancel];
    }];
    [buttonCancel roundSide:BoundSideLeft borderCornerRadius:BorderCircle];
    [bottom addSubview:buttonCancel];
    
    UIButton *buttonSend = [[UIButton alloc] initWithFrame:CGRectMake(VIEW_WIDTH(bottom)/2, MarginY, SCREEN_WIDTH/2 - MarginY, HeightButton*Ratio)];
    [buttonSend setTitle:@"发送" forState:UIControlStateNormal];
    [buttonSend setTitleColor:[UIColor colorWithHexString:ColorBlueNormal] forState:UIControlStateNormal];
    [buttonSend setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [buttonSend addEvent:^(UIButton *btn){
        [weakSelf close];
        if (weakSelf.block) {
            weakSelf.block(textTel.text,textMsg.text);
        }
        
    }];
    [buttonSend roundSide:BoundSideRight borderCornerRadius:BorderCircle];
    [bottom addSubview:buttonSend];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-0.5, VIEW_Y(buttonSend), 1, VIEW_HEIGHT(buttonSend))];
    line.backgroundColor = [UIColor colorWithHexString:ColorBlueLight];
    [bottom addSubview:line];
}

- (void)show{
    UIView *bgView = [[UIView alloc] initWithFrame:_delegate.view.bounds];
    bgView.tag = BGViewTag;
    bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [_delegate.view addSubview:bgView];
    _bgView = bgView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    [bgView addGestureRecognizer:tap];
    [bgView addGestureRecognizer:swipe];
    [self addGestureRecognizer:swipe];
    
    [_bgView addSubview:self];
    CGRect frame = self.frame;
    frame.origin.y = frame.size.height;
    self.frame = frame;
    [self showAction];
    
}
- (void)close{
    [self closeAction];
    [_bgView removeFromSuperview];
}

- (void)cancel{
    [self close];
}

- (void)send{
    NSLog(@"send");
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

@end
