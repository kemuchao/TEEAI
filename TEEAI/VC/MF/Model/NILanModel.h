//
//  LanModel.h
//  MifiApp
//
//  Created by yueguangkai on 15/11/5.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
@class NIDhcpModel;
@interface NILanModel : NSObject
@property (nonatomic, strong) NIDhcpModel *dhcp;
@property (nonatomic, copy) NSString *ip;
@property (nonatomic, copy) NSString *mac;
@property (nonatomic, copy) NSString *mask;
@property (nonatomic, copy) NSString *run_days;
@property (nonatomic, copy) NSString *run_hours;
@property (nonatomic, copy) NSString *run_minutes;
@property (nonatomic, copy) NSString *run_seconds;
@property (nonatomic, copy) NSString *redirect_enable;
@property (nonatomic, copy) NSString *redirect_url;
@property (nonatomic, copy) NSString *dhcpv6server;
@property (nonatomic, copy) NSString *dns_name;
@property (nonatomic, copy) NSString *dns_enable;
@property (nonatomic, copy) NSString *dns1;
@property (nonatomic, copy) NSString *dns2;
@property (nonatomic, strong) NSArray *Fixed_IP_list;

-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString isRGWStartXml:(BOOL) isRGWStartXml;
+(instancetype) lanWithResponseXmlString:(NSString *)responseXmlString isRGWStartXml:(BOOL) isRGWStartXml;

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
+(instancetype) lanWithXMLElement:(GDataXMLElement *) xmlElement;
@end
