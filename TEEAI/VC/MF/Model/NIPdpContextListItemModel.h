//
//  NIPdpContextListItemModel.h
//  IOS_MIFI_APP
//
//  Created by yueguangkai on 15/11/15.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface NIPdpContextListItemModel : NSObject
@property (nonatomic, copy) NSString *index;
@property (nonatomic, copy) NSString *rulename;
@property (nonatomic, copy) NSString *connnum;
@property (nonatomic, copy) NSString *pconnnum;
@property (nonatomic, copy) NSString *success;
@property (nonatomic, copy) NSString *pdefault;
@property (nonatomic, copy) NSString *secondary;
@property (nonatomic, copy) NSString *ipv4;
@property (nonatomic, copy) NSString *v4dns1;
@property (nonatomic, copy) NSString *v4dns2;
@property (nonatomic, copy) NSString *v4gateway;
@property (nonatomic, copy) NSString *v4netmask;
@property (nonatomic, copy) NSString *ipv6;
@property (nonatomic, copy) NSString *g_ipv6;
@property (nonatomic, copy) NSString *v6dns1;
@property (nonatomic, copy) NSString *v6dns2;
@property (nonatomic, copy) NSString *v6gateway;
@property (nonatomic, copy) NSString *v6netmask;
@property (nonatomic, copy) NSString *curconntime;
@property (nonatomic, copy) NSString *totalconntime;

-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString;
+(instancetype) pdpContextListItemWithResponseXmlString:(NSString *)responseXmlString;

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
+(instancetype) pdpContextListItemWithXMLElement:(GDataXMLElement *) xmlElement;

@end
