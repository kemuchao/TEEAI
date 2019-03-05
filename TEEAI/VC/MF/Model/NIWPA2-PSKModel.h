//
//  NIWPA2-PSKModel.h
//  IOS_MIFI_APP
//
//  Created by yueguangkai on 15/11/18.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface NIWPA2_PSKModel : NSObject
@property (nonatomic, copy) NSString *mode;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *rekey;
-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString;
+(instancetype) WPA2_PSKWithResponseXmlString:(NSString *)responseXmlString;

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
+(instancetype) WPA2_PSKWithXMLElement:(GDataXMLElement *) xmlElement;
@end
