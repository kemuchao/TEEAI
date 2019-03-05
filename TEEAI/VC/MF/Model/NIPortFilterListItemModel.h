//
//  NIPortFilterListItemModel.h
//  IOS_MIFI_APP
//
//  Created by yueguangkai on 15/12/7.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface NIPortFilterListItemModel : NSObject
@property (nonatomic, copy) NSString *index;
@property (nonatomic, copy) NSString *rule_name;
@property (nonatomic, copy) NSString *protocol;
@property (nonatomic, copy) NSString *trigger_port;
@property (nonatomic, copy) NSString *response_port;
-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString;
+(instancetype) portFilterItemWithResponseXmlString:(NSString *)responseXmlString;

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
+(instancetype) portFilterItemWithXMLElement:(GDataXMLElement *) xmlElement;
@end
