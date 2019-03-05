//
//  CPEWanSwitch.h
//  MifiManager
//
//  Created by notion on 2018/6/28.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
@interface CPEWanSwitch : NSObject
@property (nonatomic, strong) NSString *wanSwitch;
+(instancetype) initWithResponseXmlString:(NSString *)responseXmlString;
@end
