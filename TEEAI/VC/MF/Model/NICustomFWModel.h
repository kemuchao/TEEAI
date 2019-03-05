//
//  NICustomFWModel.h
//  IOS_MIFI_APP
//
//  Created by yueguangkai on 15/12/6.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface NICustomFWModel : NSObject
@property (nonatomic, copy) NSString *custom_rules_mode_action;
@property (nonatomic, copy) NSString *custom_rules_mode;
@property (nonatomic, strong) NSArray *custom_rules_list;

-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString isRGWStartXml:(BOOL) isRGWStartXml;
+(instancetype) customFWWithResponseXmlString:(NSString *)responseXmlString isRGWStartXml:(BOOL) isRGWStartXml;

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
+(instancetype) customFWWithXMLElement:(GDataXMLElement *) xmlElement;
@end
