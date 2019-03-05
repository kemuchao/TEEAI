//
//  NINodeModel.h
//  IOS_MIFI_APP
//
//  Created by yueguangkai on 15/11/16.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NINodeModel : NSObject
@property (nonatomic, copy) NSString *nodename;
@property (nonatomic, copy) NSString *value;

-(instancetype) initWithNodeName:(NSString *)nodename value:(NSString *)value;
+(instancetype) nodelModelWithNodeName:(NSString *)nodename value:(NSString *)value;
@end
