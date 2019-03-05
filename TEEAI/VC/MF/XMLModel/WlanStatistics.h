//
//  WlanStatistics.h
//  MifiManager
//
//  Created by notion on 2018/5/10.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
@interface WlanStatistics : NSObject
@property (nonatomic, strong) NSString *rx;
@property (nonatomic, strong) NSString *tx;

+(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
@end
