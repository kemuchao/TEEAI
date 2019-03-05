//
//  StatisticsModel.h
//  MifiApp
//
//  Created by yueguangkai on 15/11/5.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

#import "NIWanStatisticsModel.h"
@interface NIStatisticsModel : NSObject
@property (nonatomic, strong) NIWanStatisticsModel *WanStatistics;
-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString;
+(instancetype) statisticsWithResponseXmlString:(NSString *)responseXmlString;

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
+(instancetype) statisticsWithXMLElement:(GDataXMLElement *) xmlElement;


@end
