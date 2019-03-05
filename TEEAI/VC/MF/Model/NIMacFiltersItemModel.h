//
//  NIMacFiltersItemModel.h
//  IOS_MIFI_APP
//
//  Created by yueguangkai on 15/12/14.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface NIMacFiltersItemModel : NSObject
@property (nonatomic, copy) NSString *index;
@property (nonatomic, copy) NSString *mac;

-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString;
+(instancetype) macFiltersItemWithResponseXmlString:(NSString *)responseXmlString;

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
+(instancetype) macFiltersItemWithXMLElement:(GDataXMLElement *) xmlElement;
@end
