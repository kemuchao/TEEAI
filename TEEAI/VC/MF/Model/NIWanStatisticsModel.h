//
//  NIWanStatisticsModel.h
//  MifiApp
//
//  Created by yueguangkai on 15/11/6.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface NIWanStatisticsModel : NSObject
@property (nonatomic, copy) NSString *rx;
@property (nonatomic, copy) NSString *tx;
@property (nonatomic, copy) NSString *errors;
@property (nonatomic, copy) NSString *rx_byte;
@property (nonatomic, copy) NSString *tx_byte;
@property (nonatomic, copy) NSString *rx_byte_all;
@property (nonatomic, copy) NSString *tx_byte_all;
-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString;
+(instancetype) WanStatisticsWithResponseXmlString:(NSString *)responseXmlString;

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
+(instancetype) WanStatisticsWithXMLElement:(GDataXMLElement *) xmlElement;
@end
