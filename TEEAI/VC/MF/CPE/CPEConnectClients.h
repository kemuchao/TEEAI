//
//  CPEConnectClients.h
//  MifiManager
//
//  Created by notion on 2018/6/25.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPEClientModel.h"
#import "DeviceInfo.h"
@interface CPEConnectClients : NSObject
@property (nonatomic, strong) NSMutableArray *clientsArray;
+(instancetype) initWithResponseXmlString:(NSString *)responseXmlString;
@end
