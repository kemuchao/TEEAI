//
//  CPEVersionModel.h
//  MifiManager
//
//  Created by notion on 2018/6/22.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
@interface CPEVersionModel : NSObject
@property (nonatomic, strong) NSString *hardwareVersion;
@property (nonatomic, strong) NSString *hardwareVersionNum;
@property (nonatomic, strong) NSString *swVersion;
@property (nonatomic, strong) NSString *versionNum;
@property (nonatomic, strong) NSString *fotaApVersion;
@property (nonatomic, strong) NSString *buildTime;
@property (nonatomic, strong) NSString *macAddress;
@property (nonatomic, strong) NSString *basebandVersion;
@property (nonatomic, strong) NSString *basebandBuildTime;
@property (nonatomic, strong) NSString *pcbasn;
@property (nonatomic, strong) NSString *settingResponse;
@end
