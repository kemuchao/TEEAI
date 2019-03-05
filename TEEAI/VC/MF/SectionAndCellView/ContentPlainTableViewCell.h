//
//  ContentPlainTableViewCell.h
//  MifiManager
//
//  Created by notion on 2018/3/22.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentPlainTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelDetail;
@property (weak, nonatomic) IBOutlet UIView *line;

@end
