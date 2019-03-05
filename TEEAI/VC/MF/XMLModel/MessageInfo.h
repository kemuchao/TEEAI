//
//  MessageInfo.h
//  MifiManager
//
//  Created by notion on 2018/3/29.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
@interface MessageInfo : NSObject
@property (nonatomic, copy) NSString *index;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *received;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *messageType;
@property (nonatomic, copy) NSString *classType;
+(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
@end
