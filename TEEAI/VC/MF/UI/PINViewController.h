//
//  PINViewController.h
//  MifiManager
//
//  Created by notion on 2018/4/25.
//  Copyright © 2018年 notion. All rights reserved.
//
typedef void(^PINInput)(BOOL pinEnabled);
#import "BaseViewController.h"

@interface PINViewController : BaseViewController
@property (nonatomic, copy) PINInput block;
@end
