//
//  NICancelConfirmButton.h
//  MifiManager
//
//  Created by notion on 2018/4/3.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Event.h"
#import "UIButton+Round.h"
typedef enum :NSInteger{
    ButtonEnventCancel = 0,
    ButtonEnventConfirm = 1
}ButtonEnventType;

typedef void(^ButtonEnventBlock)(ButtonEnventType type,UIButton *btn);

@interface NICancelConfirmButton : UIView
- (instancetype)initWithFrame:(CGRect)frame withBlock:(ButtonEnventBlock)block;
@end
