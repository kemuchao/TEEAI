//
//  CPEClientModel.h
//  MifiManager
//
//  Created by notion on 2018/6/25.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
@interface CPEClientModel : NSObject
@property (nonatomic, strong) NSString *mac;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *ip;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *curConnTime;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *totalConnTime;
@property (nonatomic, strong) NSString *lastConnTime;
@property (nonatomic, strong) NSString *monRxBytes;
@property (nonatomic, strong) NSString *monTxBytes;
@property (nonatomic, strong) NSString *monTotalBytes;
@property (nonatomic, strong) NSString *last3DaysRxBytes;
@property (nonatomic, strong) NSString *last3DaysTxBytes;
@property (nonatomic, strong) NSString *last3DaysTotalBytes;
@property (nonatomic, strong) NSString *totalRxBytes;
@property (nonatomic, strong) NSString *totalTxBytes;
@property (nonatomic, strong) NSString *totalBytes;

+(instancetype) intiWithXMLElement:(GDataXMLElement *)xmlElement;

@end
