//
//  NISelectView.h
//  MifiManager
//
//  Created by notion on 2018/4/3.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NISelectModel.h"
typedef void(^SelectdBlock) (NISelectModel *model);
@interface NISelectView : UIView
- (instancetype)initWithData:(NSArray <NISelectModel *>*)modelArray preSelectIndex:(NSInteger)index andBlock:(SelectdBlock)block;
@end
