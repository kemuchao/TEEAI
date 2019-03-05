//
//  WanModel.h
//  MifiApp
//
//  Created by yueguangkai on 15/11/5.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
#import "NICellularModel.h"
#import "NIWifiModel.h"


@interface NIWanModel : NSObject
@property (nonatomic, copy) NSString *ip;
@property (nonatomic, copy) NSString *ConnType;
@property (nonatomic, copy) NSString *proto;
@property (nonatomic, copy) NSString *connect_disconnect;
@property (nonatomic, copy) NSString *gateway;
@property (nonatomic, copy) NSString *dns1;
@property (nonatomic, copy) NSString *dns2;
@property (nonatomic, copy) NSString *mask;
@property (nonatomic, copy) NSString *wan_link_status;
@property (nonatomic, copy) NSString *wan_conn_status;
@property (nonatomic, copy) NSString *sys_mode;
@property (nonatomic, copy) NSString *sys_submode;
@property (nonatomic, copy) NSString *data_conn_mode;
@property (nonatomic, copy) NSString *tx_rate;
@property (nonatomic, copy) NSString *rx_rate;
@property (nonatomic, copy) NSString *ISP;
@property (nonatomic, copy) NSString *IMEI;
@property (nonatomic, copy) NSString *ISP_name;
@property (nonatomic, copy) NSString *Battery_charging;
@property (nonatomic, copy) NSString *Battery_charge;
@property (nonatomic, copy) NSString *Battery_voltage;
@property (nonatomic, copy) NSString *Battery_connect;
@property (nonatomic, copy) NSString *connect_mode;
@property (nonatomic, copy) NSString *ICCID;
@property (nonatomic, copy) NSString *IMEI_SV;
@property (nonatomic, copy) NSString *MSISDN;
@property (nonatomic, copy) NSString *network_name;
@property (nonatomic, copy) NSString *auto_apn;
@property (nonatomic, copy) NSString *roaming_network_name;
@property (nonatomic, strong) NICellularModel *cellular;
@property (nonatomic, strong) NIWifiModel *wifi;
@property (nonatomic, copy) NSString *LWG_flag;

@property (nonatomic, copy) NSString *advanced_setting;
@property (nonatomic, copy) NSString *Roaming_disable_auto_dial;
@property (nonatomic, copy) NSString *Roaming_disable_auto_dial_action;
@property (nonatomic, copy) NSString *additional_APN;
@property (nonatomic, copy) NSString *mtu;
@property (nonatomic, copy) NSString *mtu_action;
@property (nonatomic, copy) NSString *auto_apn_action;
@property (nonatomic, copy) NSString *Engineering_mode;
@property (nonatomic, copy) NSString *query_time_interval;
@property (nonatomic, copy) NSString *Roaming_disable_dial;
@property (nonatomic, copy) NSString *Roaming_disable_dial_action;
@property (nonatomic, copy) NSString *IMSI;
@property (nonatomic, copy) NSString *cdns_enable;
@property (nonatomic, copy) NSString *cdns1;
@property (nonatomic, copy) NSString *cdns2;
@property (nonatomic, copy) NSString *mac_enable;
@property (nonatomic, copy) NSString *mac;
@property (nonatomic, copy) NSString *rsrp;
@property (nonatomic, copy) NSString *rssi;
@property (nonatomic, copy) NSString *cellid;
@property (nonatomic, copy) NSString *sinr;


-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString isRGWStartXml:(BOOL) isRGWStartXml;
+(instancetype) wanWithResponseXmlString:(NSString *)responseXmlString isRGWStartXml:(BOOL) isRGWStartXml;

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
+(instancetype) wanWithXMLElement:(GDataXMLElement *) xmlElement;
@end
