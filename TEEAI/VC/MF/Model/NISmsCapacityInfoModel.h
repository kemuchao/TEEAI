//
//  NISmsCapacityInfoModel.h
//  MifiApp
//
//  Created by yueguangkai on 15/11/6.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface NISmsCapacityInfoModel : NSObject
@property (nonatomic, copy) NSString *sms_unread_long_num;
-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString;
+(instancetype) smsCapacityInfoWithResponseXmlString:(NSString *)responseXmlString;

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
+(instancetype) smsCapacityInfoWithXMLElement:(GDataXMLElement *) xmlElement;
@end
