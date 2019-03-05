//
//  ActionView.h
//  MifiManager
//
//  Created by notion on 2018/4/2.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlowNumberSetting.h"
@class ActionView;
@protocol ActionViewEnterDelegate<NSObject>

/**
 代理处理接受的输入数值

 @param enterValue 返回的输入数值
 */
- (void)actionView:(ActionView *)actionView atIndexPath:(NSIndexPath *)indexPath ReceiveEnterValue:(NSString *)enterValue flowType:(FlowType)type;
@end
typedef void(^CancelBlock) (void);


@interface ActionView : UIView
@property (nonatomic, weak) CancelBlock block;
@property (nonatomic, assign) CGFloat borderMarginY;
@property (nonatomic, weak) id<ActionViewEnterDelegate>delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
- (instancetype)initWithSubView:(UIView *)subView;
- (void)resetSubView:(UIView *)subView;
- (void)addIndexPath:(NSIndexPath*)indexPath;
- (void)show;
- (void)hide;
@end


