//
//  SysinfoModel.h
//  MifiApp
//
//  Created by yueguangkai on 15/11/5.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface NISysinfoModel : NSObject
@property (nonatomic, copy) NSString *hardware_version;
@property (nonatomic, copy) NSString *device_name;
@property (nonatomic, copy) NSString *version_num;
@property (nonatomic, copy) NSString *version_date;
@property (nonatomic, copy) NSString *model_name;
@property (nonatomic, copy) NSString *main_chip_name;
@property (nonatomic, copy) NSString *ssg_version;
@property (nonatomic, copy) NSString *ssg_compile_time;
@property (nonatomic, copy) NSString *current_device_mac;

-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString;
+(instancetype) sysinfoWithResponseXmlString:(NSString *)responseXmlString;

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
+(instancetype) sysinfoWithXMLElement:(GDataXMLElement *) xmlElement;

@end