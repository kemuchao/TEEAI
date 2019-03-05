//
//  NICancelConfirmButton.m
//  MifiManager
//
//  Created by notion on 2018/4/3.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "NICancelConfirmButton.h"
#import <objc/runtime.h>
static char *eventTag;
@implementation NICancelConfirmButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame withBlock:(ButtonEnventBlock)block{
    self = [super initWithFrame:frame];
    self.backgroundColor= [UIColor whiteColor];
     objc_setAssociatedObject(self, &eventTag, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self loadMainView];
    return self;
}

- (void)loadMainView{
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MarginY*2 + HeightButton*Ratio)];
    [self addSubview:bottom];
    
    UIButton *buttonCancel = [[UIButton alloc] initWithFrame:CGRectMake(MarginX, MarginY, SCREEN_WIDTH/2 - MarginY + 1, 40)];
    [buttonCancel setTitle:@"取消" forState:UIControlStateNormal];
    [buttonCancel setTitleColor:[UIColor colorWithHexString:ColorBlueDeep] forState:UIControlStateNormal];
    [buttonCancel addEvent:UIControlEventTouchUpInside withBlock:^(UIButton *btn){
        ButtonEnventBlock block = (ButtonEnventBlock)objc_getAssociatedObject(self, &eventTag);
        if (block) {
            block(ButtonEnventCancel,btn);
        }
    }];
    buttonCancel.tag = 100;
    
    [buttonCancel roundSide:BoundSideLeft borderCornerRadius:BorderCircle];
    [bottom addSubview:buttonCancel];
    
    UIButton *buttonSend = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 -1, MarginY, SCREEN_WIDTH/2 - MarginY + 1, 40)];
    [buttonSend setTitle:@"提交" forState:UIControlStateNormal];
    [buttonSend setTitleColor:[UIColor colorWithHexString:ColorBlueNormal] forState:UIControlStateNormal];
    [buttonSend setTitleColor:BorderColorGreen forState:UIControlStateSelected];
    [buttonSend addEvent:UIControlEventTouchUpInside withBlock:^(UIButton *btn){
        ButtonEnventBlock block = (ButtonEnventBlock)objc_getAssociatedObject(self, &eventTag);
        if (block) {
            block(ButtonEnventConfirm,btn);
        }
    }];
    buttonSend.tag = 101;
    [buttonSend roundSide:BoundSideRight borderCornerRadius:BorderCircle];
    [bottom addSubview:buttonSend];
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(VIEW_WIDTH(bottom)/2-0.5, MarginY, 1, HeightButton)];
    line.backgroundColor = [UIColor colorWithHexString:ColorBlueLight];
    [bottom addSubview:line];
}
@end
