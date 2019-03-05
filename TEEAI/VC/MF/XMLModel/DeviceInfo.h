//
//  DeviceInfo.h
//  MifiManager
//
//  Created by notion on 2018/3/28.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
@interface DeviceInfo : NSObject
@property (nonatomic, copy) NSString *mac;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *nameType;
@property (nonatomic, copy) NSString *blocked;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *connType;
@property (nonatomic, copy) NSString *ipAddress;
@property (nonatomic, copy) NSString *connTime;
@property (nonatomic, copy) NSString *noteName;
@property (nonatomic, copy) NSString *connectTimeAt;
@property (nonatomic, copy) NSString *connectTimeFor;
+(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
@end

