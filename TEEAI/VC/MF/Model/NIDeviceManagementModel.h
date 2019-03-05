//
//  DeviceManagementModel.h
//  MifiApp
//
//  Created by yueguangkai on 15/11/5.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface NIDeviceManagementModel : NSObject
@property (nonatomic, copy) NSString *nr_connected_dev;
-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString;
+(instancetype) deviceManagementWithResponseXmlString:(NSString *)responseXmlString;

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
+(instancetype) deviceManagementWithXMLElement:(GDataXMLElement *) xmlElement;
@end
