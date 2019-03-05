//
//  CPENetMode.h
//  MifiManager
//
//  Created by notion on 2018/6/28.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
@interface CPENetMode : NSObject
@property (nonatomic, strong) NSString *nwMode;
@property (nonatomic, strong) NSString *preferMode;
+(instancetype) initWithResponseXmlString:(NSString *)responseXmlString;
@end
