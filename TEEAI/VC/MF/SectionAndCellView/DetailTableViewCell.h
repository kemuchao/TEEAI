//
//  DetailTableViewCell.h
//  MifiManager
//
//  Created by notion on 2018/3/21.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelDetail;

@end
