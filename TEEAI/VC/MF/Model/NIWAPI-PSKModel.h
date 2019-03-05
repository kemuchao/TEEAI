//
//  NIWAPI-PSKModel.h
//  IOS_MIFI_APP
//
//  Created by yueguangkai on 15/11/18.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface NIWAPI_PSKModel : NSObject
@property (nonatomic, copy) NSString *key_type;
@property (nonatomic, copy) NSString *key;

-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString;
+(instancetype) WAPI_PSKWithResponseXmlString:(NSString *)responseXmlString;

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
+(instancetype) WAPI_PSKWithXMLElement:(GDataXMLElement *) xmlElement;
@end
