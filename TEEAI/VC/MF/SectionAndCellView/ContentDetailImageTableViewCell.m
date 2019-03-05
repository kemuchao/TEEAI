//
//  ContentDetailImageTableViewCell.m
//  MifiManager
//
//  Created by yanlei jin on 2018/3/22.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "ContentDetailImageTableViewCell.h"

@implementation ContentDetailImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _labelDetail.text = @"详情";
}
- (void)setIsNormal:(BOOL)isNormal{
    _isNormal = isNormal;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
