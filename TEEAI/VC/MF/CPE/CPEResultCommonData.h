//
//  CPEResultCommonData.h
//  MifiManager
//
//  Created by notion on 2018/6/26.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPEResultCommonData : NSObject
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *pinAttempts;
+(instancetype) initWithResponseXmlString:(NSString *)responseXmlString;
@end
