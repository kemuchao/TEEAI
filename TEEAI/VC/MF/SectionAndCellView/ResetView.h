//
//  ResetView.h
//  MifiManager
//
//  Created by notion on 2018/4/9.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^FinishBlock) (void);
@interface ResetView : UIView
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIProgressView *progress;
@property (nonatomic, copy) FinishBlock block;
- (void)start;
@end
