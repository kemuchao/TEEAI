//
//  SwitchTypeTwoTableViewCell.m
//  MifiManager
//
//  Created by notion on 2018/3/21.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "SwitchTypeTwoTableViewCell.h"

@implementation SwitchTypeTwoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _labelDetail.text = @"详情";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
