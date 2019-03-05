//
//  NISelectModel.m
//  MifiManager
//
//  Created by notion on 2018/4/3.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "NISelectModel.h"

@implementation NISelectModel
+ (instancetype)setTitle:(NSString *)title value:(id)value{
    return [[self alloc] initWithTitle:title V:value];
}
- (instancetype)initWithTitle:(NSString *)title V:(id)value{
    self = [super init];
    self.title = title;
    self.value = value;
    return self;
}
@end
