//
//  NotionEnterView.m
//  MifiManager
//
//  Created by notion on 2018/3/21.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "NotionEnterView.h"
#import "UIButton+Event.h"
#import "UITextField+Validate.h"
@interface NotionEnterView()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSString *placeHolder;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) UIKeyboardType boardType;
@property (nonatomic, strong) UIImage *imageNormal;
@property (nonatomic, strong) UIImage *imageSelected;
@property (nonatomic, assign) EnterUIType UIType;
@property (nonatomic, assign) EnterControlType controlType;
@property (nonatomic, strong) UIView *errorView;

@end
@implementation NotionEnterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title placeHolder:(NSString *)placeHolder text:(NSString *)text keyboadrType:(UIKeyboardType)keyboardType imageNormal:(UIImage *)imageNormal imageSelected:(UIImage *)imageSelected UIType:(EnterUIType)UIType controlType:(EnterControlType)controlType{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:title];
        [self setPlaceHolder:placeHolder];
        if(text) [self setText:text];
        if(imageNormal) [self setImageNormal:imageNormal];
        if(imageSelected) [self setImageSelected:imageSelected];
        [self setUIType:UIType];
        [self setControlType:controlType];
    }
    [self loadMainView];
    
    return self;
}


- (void)loadMainView{
    CGFloat labelWidth = _UIType == EnterUINormal || _UIType == EnterUITrailImage ?MarginX:WidthLabel;
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(MarginX, CGRectGetHeight(self.bounds)/2 - HeightLabel/2, labelWidth, HeightLabel)];
    labelTitle.text = self.title;
    [self addSubview:labelTitle];
    _label = labelTitle;
    
    
    //是否有尾图
    BOOL control = _UIType == EnterUITrailImage || _UIType == EnterUILeadTitleTrailImage ? YES:NO;
    //文字是否显示
    BOOL show = _controlType == EnterControlHide ? NO:YES;
    //控制尾宽度
    CGFloat buttonWidth = control ?WidthButton*Ratio+MarginX:MarginX;
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(MarginX+labelWidth, CGRectGetHeight(self.bounds)/2 - HeightTextField/2, CGRectGetWidth(self.bounds) - labelWidth - buttonWidth - 3*MarginX, HeightTextField)];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    textField.secureTextEntry = !self.isShow;
    textField.secureTextEntry = !show;
    textField.placeholder = _placeHolder;
    textField.text = _text;
    textField.keyboardType = _boardType;
    textField.delegate = self;
    [self addSubview:textField];
    _textField = textField;
    
    if (control){
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - WidthButton*Ratio - MarginX, CGRectGetHeight(self.bounds)/2 - HeightTextField*Ratio/2, WidthButton*Ratio, HeightTextField*Ratio)];
        [button setBackgroundImage:_imageNormal forState:UIControlStateNormal];
        [button setBackgroundImage:_imageSelected forState:UIControlStateSelected];
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        __weak typeof (self)weakSelf = self;
        [button addEvent:UIControlEventTouchUpInside withBlock:^(UIButton *btn){
            [weakSelf taggleBtn:btn];
            [weakSelf taggleTextField:textField withIsShow:btn.selected];
        }];
        [self addSubview:button];
    }
}

- (void)taggleBtn:(UIButton *)btn{
    btn.selected = !btn.selected;
}

- (void)taggleTextField:(UITextField *)textField withIsShow:(BOOL)isShow{
    NSString *text = textField.text;
    textField.text = @"";
    textField.secureTextEntry = !isShow;
    textField.text = text;
}

- (NSString *)getText{
    return _textField.text;
}

- (UITextField *)getTextField{
    return  _textField;
}
#pragma mark - 输入框代理
- (BOOL)becomeFirstResponder{
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if ([_textField validateWithMethod:ValidCommon]) {
        
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}
- (UIView *)errorView{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"*";
    label.textColor = ColorRed;
    label.textAlignment = NSTextAlignmentRight;
    label.frame = CGRectMake(MarginX, 0, SCREEN_WIDTH, VIEW_HEIGHT(_textField));
    return label;
}
@end
