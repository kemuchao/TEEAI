//
//  DeviceManagement.h
//  MifiManager
//
//  Created by notion on 2018/3/28.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceInfo.h"
#import "GDataXMLNode.h"
@interface DeviceManagement : NSObject
@property (nonatomic, strong) NSMutableArray <DeviceInfo*>*deviceArray;

+(instancetype) initWithResponseXmlString:(NSString *)responseXmlString isRGWStartXml:(BOOL) isRGWStartXml;
+(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
@end
