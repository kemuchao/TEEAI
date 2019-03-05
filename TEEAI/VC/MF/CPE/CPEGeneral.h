//
//  CPEGeneral.h
//  MifiManager
//
//  Created by notion on 2018/6/28.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
@interface CPEGeneral : NSObject
@property (nonatomic, strong) NSString *warnEnable;
@property (nonatomic, strong) NSString *warnPercent;
@property (nonatomic, strong) NSString *disEnable;
@property (nonatomic, strong) NSString *disPercent;
+(instancetype) intiWithXMLElement:(GDataXMLElement *)xmlElement;
@end
