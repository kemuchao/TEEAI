//
//  NIWEPModel.h
//  IOS_MIFI_APP
//
//  Created by yueguangkai on 15/11/18.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface NIWEPModel : NSObject
@property (nonatomic, copy) NSString *key1;
@property (nonatomic, copy) NSString *key2;
@property (nonatomic, copy) NSString *key3;
@property (nonatomic, copy) NSString *key4;
@property (nonatomic, copy) NSString *auth;
@property (nonatomic, copy) NSString *encrypt;
@property (nonatomic, copy) NSString *default_key;

-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString;
+(instancetype) WEPWithResponseXmlString:(NSString *)responseXmlString;

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
+(instancetype) WEPWithXMLElement:(GDataXMLElement *) xmlElement;
@end
