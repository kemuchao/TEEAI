//
//  CPEWanConfig.h
//  MifiManager
//
//  Created by notion on 2018/7/3.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
#import "CPEWanAPNModel.h"
@interface CPEWanConfig : NSObject
@property (nonatomic, strong) NSString *activedProfile;
@property (nonatomic, strong) NSArray *profileNames;
@property (nonatomic, strong) NSMutableArray *apnArray;
@property (nonatomic, strong) CPEWanAPNModel *activeAPN;
+(instancetype) initWithResponseXmlString:(NSString *)responseXmlString;
@end
