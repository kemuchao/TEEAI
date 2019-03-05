//
//  CPEClientsNum.h
//  MifiManager
//
//  Created by notion on 2018/6/22.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPEClientsNum : NSObject
@property (nonatomic, strong) NSString *activeClientNum;
+(instancetype) initWithResponseXmlString:(NSString *)responseXmlString;
@end
