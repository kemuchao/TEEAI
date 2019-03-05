//
//  NIDhcpModel.h
//  MifiApp
//
//  Created by yueguangkai on 15/11/6.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface NIDhcpModel : NSObject
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *start;
@property (nonatomic, copy) NSString *end;
@property (nonatomic, copy) NSString *lease_time;
-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString;
+(instancetype) dhcpWithResponseXmlString:(NSString *)responseXmlString;

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
+(instancetype) dhcpWithXMLElement:(GDataXMLElement *) xmlElement;
@end
