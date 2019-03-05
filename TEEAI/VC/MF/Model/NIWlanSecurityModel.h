//
//  WlanSecurityModel.h
//  MifiApp
//
//  Created by yueguangkai on 15/11/5.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
@class NIWPA_PSKModel,NIWPA2_PSKModel,NIMixedModel,NIWEPModel,NIWAPI_PSKModel,NIWPSModel;

@interface NIWlanSecurityModel : NSObject
@property (nonatomic, copy) NSString *wapi_support;
@property (nonatomic, copy) NSString *lock_enable;
@property (nonatomic, copy) NSString *ssid;
@property (nonatomic, copy) NSString *ssid_bcast;
@property (nonatomic, copy) NSString *mode;
@property (nonatomic, copy) NSString *client_mac;
@property (nonatomic, copy) NSString *client_ip;
@property (nonatomic, strong) NIWPA_PSKModel *WPA_PSK;
@property (nonatomic, strong) NIWPA2_PSKModel *WPA2_PSK;
@property (nonatomic, strong) NIMixedModel *Mixed;
@property (nonatomic, strong) NIWEPModel *WEP;
@property (nonatomic, strong) NIWAPI_PSKModel *WAPI_PSK;
@property (nonatomic, strong) NIWPSModel *WPS;
@property (nonatomic, copy) NSString *default_key_type;

-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString isRGWStartXml:(BOOL) isRGWStartXml;
+(instancetype) wlanSecurityWithResponseXmlString:(NSString *)responseXmlString isRGWStartXml:(BOOL) isRGWStartXml;

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
+(instancetype) wlanSecurityWithXMLElement:(GDataXMLElement *) xmlElement;
@end
