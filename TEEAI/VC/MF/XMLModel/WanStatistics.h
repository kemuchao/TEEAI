//
//  WanStatistics.h
//  MifiManager
//
//  Created by notion on 2018/4/4.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
@interface WanStatistics : NSObject
@property (nonatomic, strong) NSString *statMangMethod;
@property (nonatomic, strong) NSString *upperValueUnlimit;
@property (nonatomic, strong) NSString *upperValueMonth;

@property (nonatomic, strong) NSString *totalAvaliableUnlimit;
@property (nonatomic, strong) NSString *totalAvaliableMonth;

@property (nonatomic, strong) NSString *totalUsedUnlimit;
@property (nonatomic, strong) NSString *totalUsedMonth;

@property (nonatomic, strong) NSString *alarmNeeded;
+(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
@end
