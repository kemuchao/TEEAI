//
//  APNDefaultViewController.h
//  MifiManager
//
//  Created by notion on 2018/4/25.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "BaseViewController.h"
#import "NIWanModel.h"
#import "CPEWanAPNModel.h"
@interface APNDefaultViewController : BaseViewController
@property (nonatomic, strong) CPEWanAPNModel *apnModel;
@end
