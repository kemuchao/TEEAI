//
//  LoginStatus.h
//  MifiManager
//
//  Created by notion on 2018/4/26.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginStatus : NSObject
@property (nonatomic, copy) NSString *loginStatus;
+(instancetype) initWithResponseXmlString:(NSString *)responseXmlString;
@end
