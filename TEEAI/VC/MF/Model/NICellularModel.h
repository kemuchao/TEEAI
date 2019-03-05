//
//  NICellularModel.h
//  MifiApp
//
//  Created by yueguangkai on 15/11/6.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
#import "NIPdpAutoListItemModel.h"
@interface NICellularModel : NSObject
@property (nonatomic, copy) NSString *disconnectnetwork_action;
@property (nonatomic, copy) NSString *disconnectnetwork;
@property (nonatomic, copy) NSString *reg_status;
@property (nonatomic, copy) NSString *sim_status;
@property (nonatomic, copy) NSString *pin_status;
@property (nonatomic, copy) NSString *pin_attempts;
@property (nonatomic, copy) NSString *puk_attempts;
@property (nonatomic, copy) NSString *isp_supported_list;
@property (nonatomic, copy) NSString *ISP_name;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *baudrate;
@property (nonatomic, copy) NSString *accessnumber;
@property (nonatomic, copy) NSString *cinit1;
@property (nonatomic, copy) NSString *cinit2;
@property (nonatomic, copy) NSString *advanced;   //no data
@property (nonatomic, copy) NSString *tft_apply_action;

@property (nonatomic, strong) NSArray *pdp_supported_list;

@property (nonatomic, copy) NSString *rssi;
@property (nonatomic, copy) NSString *roaming;
@property (nonatomic, strong) NSArray *pdp_context_list;

@property (nonatomic, copy) NSString *tf1_supported_list;
@property (nonatomic, copy) NSString *tf2_supported_list;
@property (nonatomic, copy) NSString *tf3_supported_list;
@property (nonatomic, copy) NSString *tf4_supported_list;
@property (nonatomic, copy) NSString *bgscan_time_action;
@property (nonatomic, copy) NSString *bgscan_time;
@property (nonatomic, copy) NSString *manual_network_start;
@property (nonatomic, copy) NSString *search_network;
@property (nonatomic, copy) NSString *network_param;
@property (nonatomic, copy) NSString *network_param_action;
@property (nonatomic, copy) NSString *auto_network_action;
@property (nonatomic, copy) NSString *network_select_done;
@property (nonatomic, copy) NSString *auto_network;
@property (nonatomic, copy) NSString *select_NW_Mode;

@property (nonatomic, strong) NSArray *mannual_network_list;//no data

@property (nonatomic, copy) NSString *NW_mode;
@property (nonatomic, copy) NSString *prefer_mode;
@property (nonatomic, copy) NSString *prefer_mode1;
@property (nonatomic, copy) NSString *prefer_mode2;
@property (nonatomic, copy) NSString *NW_mode_action;
@property (nonatomic, copy) NSString *prefer_mode_action;
@property (nonatomic, copy) NSString *prefer_lte_type;
@property (nonatomic, copy) NSString *prefer_lte_type_action;
@property (nonatomic, strong) NSArray *pdp_auto_list;

-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString;
+(instancetype) cellularWithResponseXmlString:(NSString *)responseXmlString;

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
+(instancetype) cellularWithXMLElement:(GDataXMLElement *) xmlElement;
@end
