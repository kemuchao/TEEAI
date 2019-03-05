//
//  NIAuthModel.m
//  MifiApp
//
//  Created by yueguangkai on 15/11/4.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import "NIAuthModel.h"
static NIAuthModel *_authModel = nil;
@implementation NIAuthModel

+(NIAuthModel *) shareAuthModel
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _authModel = [self new];
    });
    return _authModel;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _authModel = [super allocWithZone:zone];
    });
    return _authModel;
}
@end
