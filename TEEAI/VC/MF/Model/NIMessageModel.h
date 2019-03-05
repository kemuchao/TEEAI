//
//  MessageModel.h
//  MifiApp
//
//  Created by yueguangkai on 15/11/5.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
#import "NISmsCapacityInfoModel.h"
//@class NISmsCapacityInfoModel;
@interface NIMessageModel : NSObject
@property (nonatomic, strong) NISmsCapacityInfoModel *sms_capacity_info;
@property (nonatomic, copy) NSString *ni_new_sms_num;
-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString;
+(instancetype) messageWithResponseXmlString:(NSString *)responseXmlString;

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
+(instancetype) messageWithXMLElement:(GDataXMLElement *) xmlElement;

@end
