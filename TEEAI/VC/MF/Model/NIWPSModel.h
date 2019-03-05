//
//  NIWPSModel.h
//  IOS_MIFI_APP
//
//  Created by yueguangkai on 15/11/18.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface NIWPSModel : NSObject
@property (nonatomic, copy) NSString *connect_method;
@property (nonatomic, copy) NSString *wps_pin;
@property (nonatomic, copy) NSString *wps_status;

-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString;
+(instancetype) WPSWithResponseXmlString:(NSString *)responseXmlString;

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
+(instancetype) WPSWithXMLElement:(GDataXMLElement *) xmlElement;
@end
