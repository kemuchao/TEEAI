//
//  USSDModel.h
//  MifiManager
//
//  Created by notion on 2018/5/3.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
@interface USSDModel : NSObject
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *str;
+(instancetype) initWithResponseXmlString:(NSString *)responseXmlString;
@end
