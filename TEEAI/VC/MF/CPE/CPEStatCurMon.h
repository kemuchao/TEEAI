//
//  CPEStatCurMon.h
//  MifiManager
//
//  Created by notion on 2018/7/2.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
@interface CPEStatCurMon : NSObject
@property (nonatomic, strong) NSString *basicMonUsed;
@property (nonatomic, strong) NSString *idleUsed;
@property (nonatomic, strong) NSString *periodUsed;
@property (nonatomic, strong) NSString *totalMonUsed;
@property (nonatomic, strong) NSString *warning;
+(instancetype) initWithResponseXmlString:(NSString *)responseXmlString;
@end
