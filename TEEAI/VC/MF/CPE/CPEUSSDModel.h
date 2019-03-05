//
//  CPEUSSDModel.h
//  MifiManager
//
//  Created by notion on 2018/7/19.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
@interface CPEUSSDModel : NSObject
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *ussdStr;
@property (nonatomic, strong) NSString *response;
+(instancetype) initWithResponseXmlString:(NSString *)responseXmlString;
@end
