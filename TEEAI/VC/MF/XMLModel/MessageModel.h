//
//  MessageModel.h
//  MifiManager
//
//  Created by notion on 2018/3/29.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageInfo.h"
#import "GDataXMLNode.h"
@interface MessageModel : NSObject
@property (nonatomic, strong) NSMutableArray <MessageInfo*>*deviceArray;
@property (nonatomic, strong) NSString *sendMessageResult;
+(instancetype) initWithResponseXmlString:(NSString *)responseXmlString isRGWStartXml:(BOOL) isRGWStartXml;
@end
