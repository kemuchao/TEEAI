//
//  FlowNumberSetting.m
//  MifiManager
//
//  Created by notion on 2018/4/2.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "FlowNumberSetting.h"
#import "NSString+Extension.h"
@interface FlowNumberSetting()<UITextFieldDelegate>
@property (nonatomic, strong) NSString *title;

@end
@implementation FlowNumberSetting

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title andFlowType:(FlowType)type{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    [self setTitle:title];
    [self setType:type];
    [self loadMainView];
    
    return self;
}

- (void)loadMainView{
    CGFloat btnWidth = HeightButton*2*Ratio;
    CGFloat padding = MarginX;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, MarginY*2, SCREEN_WIDTH, HeightLabel)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = _title;
    title.font = [UIFont systemFontOfSize:14];
    title.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0  blue:51/255.0  alpha:1];
    [self addSubview:title];
    
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(MarginX, MarginY+VIEW_BOTTOM(title), SCREEN_WIDTH - 2*MarginX - btnWidth - padding, HeightButton)];
//    [field setTextColor:ColorWhite];
    [field setLayerWithBorderWidth:BorderWidth BorderColor:[UIColor colorWithRed:88/255.0 green:129/255.0  blue:192/255.0  alpha:1] CornerRadius:BorderCircle];
    field.backgroundColor = [UIColor whiteColor];
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    field.placeholder = _title;
    field.delegate = self;
    CGFloat width = [@"" stringWidthWithFont:FontSyWithSize(18)]+MarginX;
    UILabel *leftView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, HeightTextField)];
    leftView.text = @"";
    leftView.textAlignment = NSTextAlignmentCenter;
//    leftView.textColor = [UIColor colorWithHexString:ColorGreenLight];
    leftView.backgroundColor = [UIColor clearColor];
    field.leftView = leftView;
    field.leftViewMode = UITextFieldViewModeAlways;
    field.keyboardType = UIKeyboardTypeDecimalPad;
    [field becomeFirstResponder];
    [self addSubview:field];
    _textValue = field;
    
    UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(field.frame) + padding, MarginY+VIEW_BOTTOM(title), btnWidth, HeightButton)];
    [selectBtn setLayerWithBorderWidth:BorderWidth BorderColor: [UIColor colorWithRed:88/255.0 green:129/255.0  blue:192/255.0  alpha:1] CornerRadius:BorderCircle];
    [selectBtn setTitleColor:ColorBlack forState:UIControlStateNormal];
    selectBtn.backgroundColor = [UIColor colorWithRed:88/255.0 green:129/255.0  blue:192/255.0  alpha:1];
    NSString *typeName = _type == FlowTypeGB?@"GB":@"MB";
    [selectBtn layoutWithModel:NIContentModelLeft padding:6 title:typeName image:[UIImage imageNamed:@"arrowDown"]];
    WeakSelf;
    [selectBtn addEvent:^(UIButton *btn){
        [UIView animateWithDuration:0.3 animations:^{
            btn.transform = CGAffineTransformScale(btn.transform, -1.0, 1.0);
            btn.transform = CGAffineTransformScale(btn.transform, -1.0, 1.0);
        } completion:^(BOOL finished){
            NSString *title = [btn.titleLabel.text isEqualToString:@"GB"]?@"MB":@"GB";
            [btn setTitle:title forState:UIControlStateNormal];
            weakSelf.type = [title isEqualToString:@"GB"]?FlowTypeGB:FlowTypeMB;
        }];
        
    }];
    [self addSubview:selectBtn];
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"."] && [textField.text containsString:@"."]) {
        return NO;
    }else{
        return YES;
    }
}

- (NSString *)getValue{
    return _textValue.text;
}
- (FlowType)getType{
    return _type;
}
@end
