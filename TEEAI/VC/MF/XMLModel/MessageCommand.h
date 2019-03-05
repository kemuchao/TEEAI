//
//  MessageCommand.h
//  MifiManager
//
//  Created by notion on 2018/4/27.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
@interface MessageCommand : NSObject
@property (nonatomic, copy) NSString *messageFlag;
@property (nonatomic, copy) NSString *smsCmd;
@property (nonatomic, copy) NSString *smsCmdStatusResult;
+(instancetype) initWithResponseXmlString:(NSString *)responseXmlString;
@end
