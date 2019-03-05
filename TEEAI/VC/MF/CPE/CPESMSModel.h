//
//  CPESMSModel.h
//  MifiManager
//
//  Created by notion on 2018/7/3.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
@interface CPESMSModel : NSObject
@property (nonatomic, strong) NSString *identify;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *contactId;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *protocol;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *read;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *body;

@property (nonatomic, strong) NSString *resp;
@property (nonatomic, strong) NSString *smsID;
+(instancetype) initWithResponseXmlString:(NSString *)responseXmlString;
+(instancetype) intiWithXMLElement:(GDataXMLElement *)xmlElement;
@end
