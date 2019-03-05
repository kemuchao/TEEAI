//
//  NIDhcpFixedListItemModel.h
//  IOS_MIFI_APP
//
//  Created by yueguangkai on 15/12/9.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface NIDhcpFixedListItemModel : NSObject
@property (nonatomic, copy) NSString *index;
@property (nonatomic, copy) NSString *mac;
@property (nonatomic, copy) NSString *ip;

-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString;
+(instancetype) dhcpFixedListItemWithResponseXmlString:(NSString *)responseXmlString;

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
+(instancetype) dhcpFixedListItemWithXMLElement:(GDataXMLElement *) xmlElement;
@end
