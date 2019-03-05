//
//  FirewallModel.h
//  MifiApp
//
//  Created by yueguangkai on 15/11/5.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface NIFirewallModel : NSObject
@property (nonatomic, copy) NSString *mode;
-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString;
+(instancetype) firewallWithResponseXmlString:(NSString *)responseXmlString;

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
+(instancetype) firewallWithXMLElement:(GDataXMLElement *) xmlElement;

@end
