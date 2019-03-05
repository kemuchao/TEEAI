//
//  NIWifiMixedModel.h
//  IOS_MIFI_APP
//
//  Created by yueguangkai on 15/11/18.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface NIMixedModel : NSObject
@property (nonatomic, copy) NSString *mode;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *rekey;
-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString;
+(instancetype) MixedWithResponseXmlString:(NSString *)responseXmlString;

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
+(instancetype) MixedWithXMLElement:(GDataXMLElement *) xmlElement;
@end
