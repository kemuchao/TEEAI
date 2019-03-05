//
//  NIWifiModel.h
//  MifiApp
//
//  Created by yueguangkai on 15/11/6.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface NIWifiModel : NSObject
@property (nonatomic, copy) NSString *ssid;
@property (nonatomic, copy) NSString *enc;
@property (nonatomic, copy) NSString *cipher;
@property (nonatomic, copy) NSString *signal;

-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString;
+(instancetype) wifiWithResponseXmlString:(NSString *)responseXmlString;

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
+(instancetype) wifiWithXMLElement:(GDataXMLElement *) xmlElement;

@end
