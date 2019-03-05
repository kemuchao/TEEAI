//
//  NIWlanMacFiltersModel.h
//  IOS_MIFI_APP
//
//  Created by yueguangkai on 15/12/14.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface NIWlanMacFiltersModel : NSObject
@property (nonatomic, copy) NSString *enable;
@property (nonatomic, copy) NSString *mode;
@property (nonatomic, strong) NSArray *allow_list;
@property (nonatomic, strong) NSArray *deny_list;
-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString isRGWStartXml:(BOOL) isRGWStartXml;
+(instancetype) macFiltersWithResponseXmlString:(NSString *)responseXmlString isRGWStartXml:(BOOL) isRGWStartXml;

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
+(instancetype) macFiltersWithXMLElement:(GDataXMLElement *) xmlElement;
@end
