//
//  BlackListViewController.h
//  MifiManager
//
//  Created by notion on 2018/4/23.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^RefreshList) (void);
@interface BlackListViewController : BaseViewController
@property (nonatomic, weak) RefreshList block;
@end
