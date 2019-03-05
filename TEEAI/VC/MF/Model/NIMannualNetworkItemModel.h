//
//  NIMannualNetworkItemModel.h
//  IOS_MIFI_APP
//
//  Created by yueguangkai on 15/11/17.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface NIMannualNetworkItemModel : NSObject
@property (nonatomic, copy) NSString *index;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *act;
@property (nonatomic, copy) NSString *plmm_name;
-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString;
+(instancetype) mannualNetworkItemWithResponseXmlString:(NSString *)responseXmlString;

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
+(instancetype) mannualNetworkItemWithXMLElement:(GDataXMLElement *) xmlElement;
@end
