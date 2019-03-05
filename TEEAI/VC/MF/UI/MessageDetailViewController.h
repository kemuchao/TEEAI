//
//  MessageDetailViewController.h
//  MifiManager
//
//  Created by notion on 2018/4/27.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "BaseViewController.h"
#import "MessageInfo.h"
typedef void (^MessageDeleteBlock)(BOOL isDeleted);
typedef void (^MessageReadBlock)(BOOL isRead);
#import "CPESMSModel.h"
#import "CPEInterfaceMain.h"
@interface MessageDetailViewController : BaseViewController
@property (nonatomic, strong) MessageInfo *messageInfo;
@property (nonatomic, strong) CPESMSModel *cpeMessageInfo;
@property (nonatomic, copy) MessageDeleteBlock block;
@property (nonatomic, copy) MessageReadBlock readBlock;
@end
