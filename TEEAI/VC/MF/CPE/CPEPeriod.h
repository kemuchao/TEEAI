//
//  CPEPeriod.h
//  MifiManager
//
//  Created by notion on 2018/6/28.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
@interface CPEPeriod : NSObject
@property (nonatomic, strong) NSString *enable;
@property (nonatomic, strong) NSString *svlData;
@property (nonatomic, strong) NSString *startHour;
@property (nonatomic, strong) NSString *endHour;
+(instancetype) intiWithXMLElement:(GDataXMLElement *)xmlElement;
@end
