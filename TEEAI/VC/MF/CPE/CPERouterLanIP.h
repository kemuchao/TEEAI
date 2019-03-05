//
//  CPERouterLanIP.h
//  MifiManager
//
//  Created by notion on 2018/6/22.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPERouterLanIP : NSObject
@property (nonatomic, strong) NSString *lanIP;
@property (nonatomic, strong) NSString *lanNetMask;
+(instancetype) initWithResponseXmlString:(NSString *)responseXmlString;
@end
