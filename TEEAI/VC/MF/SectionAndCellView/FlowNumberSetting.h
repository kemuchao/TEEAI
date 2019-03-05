//
//  FlowNumberSetting.h
//  MifiManager
//
//  Created by notion on 2018/4/2.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum:NSInteger{
    FlowTypeGB = 0,
    FlowTypeMB = 1,
} FlowType;
@interface FlowNumberSetting : UIView

/**
 流量单位
 */
@property (nonatomic, assign) FlowType type;
/**
 输入框
 */
@property (nonatomic, strong) UITextField *textValue;
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title andFlowType:(FlowType)type;

/**
 获取当前输入值

 @return 当前输入值
 */
- (NSString *)getValue;
@end
