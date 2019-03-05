//
//  NINodeModel.m
//  IOS_MIFI_APP
//
//  Created by yueguangkai on 15/11/16.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import "NINodeModel.h"

@implementation NINodeModel
-(instancetype) initWithNodeName:(NSString *)nodename value:(NSString *)value
{
    if (self = [super init]) {
        self.nodename = nodename;
        self.value = value;
    }
    return self;
}

+(instancetype) nodelModelWithNodeName:(NSString *)nodename value:(NSString *)value
{
    return [[NINodeModel alloc]initWithNodeName:nodename value:value];
}
@end
