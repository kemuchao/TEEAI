//
//  LoginEnterView.m
//  MifiManager
//
//  Created by notion on 2018/4/19.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "LoginEnterView.h"
@interface LoginEnterView()
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *psw;
@end
@implementation LoginEnterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame name:(NSString *)name psw:(NSString *)psw{
    self = [super initWithFrame:frame];
    self.backgroundColor = ColorClear;
    [self setName:name];
    [self setPsw:psw];
    [self loadMainView];
    return self;
}

- (void)loadMainView{
    CGFloat marginX = 113/3*Ratio;
    CGFloat marginY = 0;
    CGFloat heightText = 45;
    
    UITextField *nameText = [[UITextField alloc] initWithFrame:CGRectMake(marginX, MarginY, SCREEN_WIDTH-2*marginX, heightText)];
    nameText.text = _name;
    nameText.textColor = ColorWhite;
    nameText.font = FontLarge;
    nameText.placeholder = @"输入用户名";
//    [nameText setTitle:nil imageArray:@[] secureText:false selected:false];
    [nameText setLayerWithBorderWidth:0 BorderColor:ColorClear CornerRadius:BorderCircle];
//    [nameText setBackground:[UIImage imageNamed:@"login_textField_bg"]];
    
    UIImageView *lineview = [[UIImageView alloc]initWithFrame:CGRectMake(marginX, VIEW_BOTTOM(nameText), SCREEN_WIDTH-2*marginX, 1)];
    lineview.image = [UIImage imageNamed:@"line_buttom"];
    
    UITextField *pswText = [[UITextField alloc] initWithFrame:CGRectMake(marginX, VIEW_BOTTOM(nameText)+marginY, VIEW_WIDTH(nameText), VIEW_HEIGHT(nameText))];
    pswText.text = _psw;
    pswText.textColor = ColorWhite;
    pswText.font = FontLarge;
    pswText.placeholder =  @"输入用户名";
    
    [pswText setTitle:nil imageArray:@[IMAGE(@"psw_default"),IMAGE(@"psw_height")] secureText:YES selected:false];
    [pswText setLayerWithBorderWidth:0 BorderColor:ColorClear CornerRadius:BorderCircle];
    [pswText setReturnKeyType:UIReturnKeyDone];
    
    UIImageView *lineview2 = [[UIImageView alloc]initWithFrame:CGRectMake(marginX, VIEW_BOTTOM(pswText), SCREEN_WIDTH-2*marginX, 1)];
    lineview2.image = [UIImage imageNamed:@"line_buttom"];
    
    [self addSubview:nameText];
    [self addSubview:lineview];
    [self addSubview:pswText];
    [self addSubview:lineview2];
    _textName = nameText;
    _textPsw = pswText;
    
}

@end
