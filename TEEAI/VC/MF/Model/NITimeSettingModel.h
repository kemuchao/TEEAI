//
//  NITimeSettingModel.h
//  IOS_MIFI_APP
//
//  Created by yueguangkai on 15/12/8.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface NITimeSettingModel : NSObject
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *month;
@property (nonatomic, copy) NSString *day;
@property (nonatomic, copy) NSString *hour;
@property (nonatomic, copy) NSString *minute;
@property (nonatomic, copy) NSString *second;
@property (nonatomic, copy) NSString *default_date;
@property (nonatomic, copy) NSString *ntp_action;
@property (nonatomic, copy) NSString *ntp_status;
@property (nonatomic, copy) NSString *reserve;

-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString isRGWStartXml:(BOOL) isRGWStartXml;
+(instancetype) timeSettingWithResponseXmlString:(NSString *)responseXmlString isRGWStartXml:(BOOL) isRGWStartXml;

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
+(instancetype) timeSettingWithXMLElement:(GDataXMLElement *) xmlElement;
@end
