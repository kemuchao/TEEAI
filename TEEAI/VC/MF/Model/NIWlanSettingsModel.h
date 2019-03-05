//
//  WlanSettingsModel.h
//  MifiApp
//
//  Created by yueguangkai on 15/11/5.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface NIWlanSettingsModel : NSObject
@property (nonatomic, copy) NSString *wlan_enable;
@property (nonatomic, copy) NSString *mac;
@property (nonatomic, copy) NSString *dual_band_support;
@property (nonatomic, copy) NSString *rf_band;
@property (nonatomic, copy) NSString *net_mode;
@property (nonatomic, copy) NSString *channel;
@property (nonatomic, copy) NSString *first_channel;
@property (nonatomic, copy) NSString *last_channel;
@property (nonatomic, copy) NSString *current_channel;
@property (nonatomic, copy) NSString *bandwidth;
@property (nonatomic, copy) NSString *max_clients;
@property (nonatomic, copy) NSString *wifi_sleep_time;
@property (nonatomic, copy) NSString *wifi_sleep_action;
@property (nonatomic, copy) NSString *band40_acs_enable;
@property (nonatomic, copy) NSString *beacon_period;
@property (nonatomic, copy) NSString *dtim_interval;
@property (nonatomic, copy) NSString *sec_channel;
@property (nonatomic, copy) NSString *ap_isolate;
@property (nonatomic, copy) NSString *only_20m;

-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString isRGWStartXml:(BOOL) isRGWStartXml;
+(instancetype) wlanSettingsWithResponseXmlString:(NSString *)responseXmlString isRGWStartXml:(BOOL) isRGWStartXml;

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
+(instancetype) wlanSettingsWithXMLElement:(GDataXMLElement *) xmlElement;
@end
