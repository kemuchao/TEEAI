//
//  CPEWiFiDetail.h
//  MifiManager
//
//  Created by notion on 2018/6/22.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPEWiFiDetail : NSObject
@property (nonatomic, strong) NSString *ssid;
@property (nonatomic, strong) NSString *key;
+(instancetype) initWithResponseXmlString:(NSString *) responseXmlString;
@end
