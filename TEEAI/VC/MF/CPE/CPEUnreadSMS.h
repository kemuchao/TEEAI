//
//  CPEUnreadSMS.h
//  MifiManager
//
//  Created by notion on 2018/7/3.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
#import "CPESMSModel.h"
@interface CPEUnreadSMS : NSObject
@property (nonatomic, strong) NSString *total;
@property (nonatomic, strong) NSMutableArray *messageArray;
@property (nonatomic, assign) NSInteger unreadNum;
+(instancetype) initWithResponseXmlString:(NSString *)responseXmlString;
@end
