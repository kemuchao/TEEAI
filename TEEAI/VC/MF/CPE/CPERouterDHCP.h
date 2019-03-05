//
//  CPERouterDHCP.h
//  MifiManager
//
//  Created by notion on 2018/6/22.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPERouterDHCP : NSObject
@property (nonatomic, strong) NSString *disabled;
@property (nonatomic, strong) NSString *start;
@property (nonatomic, strong) NSString *limit;
@property (nonatomic, strong) NSString *leasetime;
@end
