//
//  CPEStatisticsStatSetting.h
//  MifiManager
//
//  Created by notion on 2018/6/28.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
#import "CPEBasicMon.h"
#import "CPEPeriod.h"
#import "CPEIdle.h"
#import "CPEGeneral.h"
@interface CPEStatisticsStatSetting : NSObject
@property (nonatomic, strong) CPEBasicMon *basicMon;
@property (nonatomic, strong) CPEPeriod *period;
@property (nonatomic, strong) CPEIdle *idle;
@property (nonatomic, strong) CPEGeneral *general;
+(instancetype) initWithResponseXmlString:(NSString *)responseXmlString;
@end
