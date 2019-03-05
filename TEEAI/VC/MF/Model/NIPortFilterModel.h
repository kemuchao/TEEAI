//
//  NIPortFilterModel.h
//  IOS_MIFI_APP
//
//  Created by yueguangkai on 15/12/7.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface NIPortFilterModel : NSObject
@property (nonatomic, copy) NSString *port_filter_mode;
@property (nonatomic, strong) NSArray *port_filter_list;

-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString isRGWStartXml:(BOOL) isRGWStartXml;
+(instancetype) portFilterWithResponseXmlString:(NSString *)responseXmlString isRGWStartXml:(BOOL) isRGWStartXml;

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
+(instancetype) portFilterWithXMLElement:(GDataXMLElement *) xmlElement;
@end
