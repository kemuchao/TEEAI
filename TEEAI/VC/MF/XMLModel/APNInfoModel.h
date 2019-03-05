//
//  APNInfoModel.h
//  MifiManager
//
//  Created by notion on 2018/4/26.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
@interface APNInfoModel : NSObject
@property (nonatomic, strong) NSString *ruleName;
@property (nonatomic, strong) NSString *connnum;
@property (nonatomic, strong) NSString *pconnum;
@property (nonatomic, strong) NSString *enable;
@property (nonatomic, strong) NSString *conntype;
@property (nonatomic, strong) NSString *defaultObject;
@property (nonatomic, strong) NSString *secondary;
@property (nonatomic, strong) NSString *spn;
@property (nonatomic, strong) NSString *lteSpn;
@property (nonatomic, strong) NSString *ipType;
@property (nonatomic, strong) NSString *qci;
@property (nonatomic, strong) NSString *authType2g3;
@property (nonatomic, strong) NSString *usr2g3;
@property (nonatomic, strong) NSString *paswd2g3;
@property (nonatomic, strong) NSString *authType4g;
@property (nonatomic, strong) NSString *usr4g;
@property (nonatomic, strong) NSString *paswd4g;
@property (nonatomic, strong) NSString *hastft;
+(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
@end
