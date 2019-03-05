//
//  CPEStatisticsCommonData.h
//  MifiManager
//
//  Created by notion on 2018/6/22.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPEStatisticsCommonData : NSObject
@property (nonatomic, strong) NSString *rxBytes;
@property (nonatomic, strong) NSString *txBytes;
@property (nonatomic, strong) NSString *rxTxBytes;
@property (nonatomic, strong) NSString *errorBytes;
@property (nonatomic, strong) NSString *totalRxBytes;
@property (nonatomic, strong) NSString *totalTxBytes;
@property (nonatomic, strong) NSString *totalRxTxBytes;
@property (nonatomic, strong) NSString *totalErrorBytes;
+(instancetype) initWithResponseXmlString:(NSString *)responseXmlString;
@end
