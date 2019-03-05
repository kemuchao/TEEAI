//
//  NotionEnterView.h
//  MifiManager
//
//  Created by notion on 2018/3/21.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    EnterUINormal= 0,//普通,即既没有前标，也没有尾图
    EnterUILeadTitle = 1,//有前标题
    EnterUITrailImage = 2,//有尾图
    EnterUILeadTitleTrailImage = 3,//前有尾图后有图片
} EnterUIType;

typedef enum : NSInteger{
    EnterControlNormal = 0,//普通样式,不需要点击控制,显示
    EnterControlHide = 1,//密码输入且隐藏
    EnterControlShow = 2,//密码输入且显示
} EnterControlType;
@interface NotionEnterView : UIView<UITextFieldDelegate>

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title placeHolder:(NSString *)placeHolder text:(NSString *)text keyboadrType:(UIKeyboardType)keyboardType imageNormal:(UIImage *)imageNormal imageSelected:(UIImage *)imageSelected UIType:(EnterUIType)UIType controlType:(EnterControlType)controlType;
- (NSString *)getText;
- (UITextField *)getTextField;
@end
