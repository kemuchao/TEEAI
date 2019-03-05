//
//  NotionEnterGroup.h
//  MifiManager
//
//  Created by notion on 2018/3/21.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotionEnterView.h"
#import "UITextField+Validate.h"
typedef enum : NSUInteger {
    EnterEmpty=0,
    EnterEnEqual = 1,
    EnterUnFineType =2,
    EnterOK = 3,
} EnterError;
typedef void(^EnterVertify)(EnterError error);

@interface NotionEnterGroup : UIView
/**
 添加有多个输入框的视图

 @param frame frame
 @param titleArray 标题数组
 @param textArray 输入框当前数值
 @param placeholderArray 占位符数组
 @param boardtypeArray 键盘样式数组
 @param UITypeArray 样式数组
 @param imageNormalArray 默认图片数组
 @param imageSelectedArray 高亮图片数组
 @param controlArray 控制样式数组
 @param block 回掉
 @return 返回视图
 */
- (instancetype)initWithFrame:(CGRect)frame
                   GroupTitle:(NSArray *)titleArray
               textValueArray:(NSArray *)textArray
             placeholderArray:(NSArray  *)placeholderArray
            keyboardTypeArray:(NSArray*)boardtypeArray
                  UITypeArray:(NSArray *)UITypeArray
                  imageNormal:(NSArray *)imageNormalArray
            imageSelectdArray:(NSArray *)imageSelectedArray
             ControlTypeArray:(NSArray *)controlArray
                    withBlock:(EnterVertify)block;
- (NSArray *)getTitles;
- (NSArray *)getEnterTextField;
@end
