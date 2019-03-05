//
//  CPEWanAPNModel.h
//  MifiManager
//
//  Created by notion on 2018/7/3.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
@interface CPEWanAPNModel : NSObject
@property (nonatomic, strong) NSString *apnFileName;
@property (nonatomic, strong) NSString *connetionNum;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *autoAPN;
@property (nonatomic, strong) NSString *connectMode;
@property (nonatomic, strong) NSString *lteDefault;
@property (nonatomic, strong) NSString *dataOnRoaming;
@property (nonatomic, strong) NSString *pdpName;
@property (nonatomic, strong) NSString *enable;
@property (nonatomic, strong) NSString *ipType;
@property (nonatomic, strong) NSString *apn;
@property (nonatomic, strong) NSString *lteApn;
@property (nonatomic, strong) NSString *usr2g3g;
@property (nonatomic, strong) NSString *pswd2g3g;
@property (nonatomic, strong) NSString *authtype2g3g;
@property (nonatomic, strong) NSString *usr4g;
@property (nonatomic, strong) NSString *pswd4g;
@property (nonatomic, strong) NSString *authtype4g;
@property (nonatomic, strong) NSString *mtu;
@property (nonatomic, strong) NSString *modifiable;

+(instancetype) intiWithXMLElement:(GDataXMLElement *)xmlElement;
@end
