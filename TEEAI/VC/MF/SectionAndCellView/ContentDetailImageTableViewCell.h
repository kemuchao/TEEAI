//
//  ContentDetailImageTableViewCell.h
//  MifiManager
//
//  Created by yanlei jin on 2018/3/22.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,DeviceType) {
    DeviceMain,
    DeviceWIFI,
    DeviceUSB,
};
@interface ContentDetailImageTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageMe;
@property (strong, nonatomic) IBOutlet UIImageView *iconImage;
@property (strong, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) IBOutlet UILabel *labelDetail;

@property (assign, nonatomic) BOOL isNormal;

@end
