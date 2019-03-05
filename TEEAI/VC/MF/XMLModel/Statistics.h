//
//  Statistics.h
//  MifiManager
//
//  Created by notion on 2018/4/4.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
#import "WanStatistics.h"
#import "WlanStatistics.h"
@interface Statistics : NSObject
@property (nonatomic, strong) WanStatistics *wanStatistics;
@property (nonatomic, strong) WlanStatistics *wlanStatistics;
+(instancetype) initWithResponseXmlString:(NSString *)responseXmlString isRGWStartXml:(BOOL) isRGWStartXml;
@end
