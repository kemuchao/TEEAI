//
//  NICustomRulesListIItemModel.h
//  IOS_MIFI_APP
//
//  Created by yueguangkai on 15/12/6.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface NICustomRulesListItemModel : NSObject
@property (nonatomic, copy) NSString *index;
@property (nonatomic, copy) NSString *rule_name;
@property (nonatomic, copy) NSString *proto;
@property (nonatomic, copy) NSString *enabled;
@property (nonatomic, copy) NSString *src_ip;
@property (nonatomic, copy) NSString *src_port;
@property (nonatomic, copy) NSString *dst_ip;
@property (nonatomic, copy) NSString *dst_port;
-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString;
+(instancetype) customRulesItemWithResponseXmlString:(NSString *)responseXmlString;

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
+(instancetype) customRulesItemWithXMLElement:(GDataXMLElement *) xmlElement;
@end
