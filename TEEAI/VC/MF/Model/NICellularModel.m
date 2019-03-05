//
//  NICellularModel.m
//  MifiApp
//
//  Created by yueguangkai on 15/11/6.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import "NICellularModel.h"
#import "NIPdpContextListItemModel.h"
#import "NIPdpAutoListItemModel.h"
#import "NIPdpSupportedListItemModel.h"
#import "NIMannualNetworkItemModel.h"

@implementation NICellularModel

-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString
{
    if (self = [super init]) {
        GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:responseXmlString options:0 error:nil];
        GDataXMLElement *element = [document rootElement];
        [self initDatasWithXMLElement:element];
    }
    return self;
}

+(instancetype) cellularWithResponseXmlString:(NSString *)responseXmlString
{
    return [[self alloc]initWithResponseXmlString:responseXmlString];
}

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement
{
    if (self = [super init]) {
        [self initDatasWithXMLElement:xmlElement];
    }
    return self;
}

+(instancetype) cellularWithXMLElement:(GDataXMLElement *) xmlElement
{
    return [[self alloc]initWithXMLElement:xmlElement];
}

-(void) initDatasWithXMLElement:(GDataXMLElement *) xmlElement
{
    NSArray *childrenElements = [xmlElement children];
    for (int i = 0; i < [childrenElements count]; i++) {
        GDataXMLElement *ele = [childrenElements objectAtIndex:i];
        if ([[ele name] isEqualToString:@"disconnectnetwork_action"]) {
            self.disconnectnetwork_action = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"disconnectnetwork"]) {
            self.disconnectnetwork = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"reg_status"]) {
            self.reg_status = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"sim_status"]) {
            self.sim_status = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"pin_status"]) {
            self.pin_status = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"pin_attempts"]) {
            self.pin_attempts = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"puk_attempts"]) {
            self.puk_attempts = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"isp_supported_list"]) {
        
        } else if ([[ele name] isEqualToString:@"ISP_name"]) {
            
        } else if ([[ele name] isEqualToString:@"username"]) {
            
        } else if ([[ele name] isEqualToString:@"password"]) {
            
        } else if ([[ele name] isEqualToString:@"baudrate"]) {
            
        } else if ([[ele name] isEqualToString:@"accessnumber"]) {
            
        } else if ([[ele name] isEqualToString:@"init1"]) {
            
        } else if ([[ele name] isEqualToString:@"init2"]) {
            
        } else if ([[ele name] isEqualToString:@"advanced"]) {
            
        } else if ([[ele name] isEqualToString:@"tft_apply_action"]) {
            self.tft_apply_action = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"pdp_supported_list"]) {
            NSArray *pdpSupportedListElements = ele.children;
            NSMutableArray *pdpSupportedList = [[NSMutableArray alloc]initWithCapacity:pdpSupportedListElements.count];
            for (int j = 0; j <pdpSupportedListElements.count; j++) {
                [pdpSupportedList addObject:[NIPdpSupportedListItemModel pdpSupportedListItemWithXMLElement:[pdpSupportedListElements objectAtIndex:j]]];
            }
            self.pdp_supported_list = pdpSupportedList;
        } else if ([[ele name] isEqualToString:@"rssi"]) {
            self.rssi = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"roaming"]) {
            self.roaming = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"pdp_context_list"]) {
            NSArray *pdpContextListElements = ele.children;
            NSMutableArray *pdpContextList = [[NSMutableArray alloc]initWithCapacity:pdpContextListElements.count];
            for (int j = 0; j <pdpContextListElements.count; j++) {
                [pdpContextList addObject:[NIPdpContextListItemModel pdpContextListItemWithXMLElement:[pdpContextListElements objectAtIndex:j]]];
            }
            self.pdp_auto_list = pdpContextList;
        } else if ([[ele name] isEqualToString:@"tf1_supported_list"]) {
            
        } else if ([[ele name] isEqualToString:@"tf2_supported_list"]) {
            
        } else if ([[ele name] isEqualToString:@"tf3_supported_list"]) {
            
        } else if ([[ele name] isEqualToString:@"tf4_supported_list"]) {
            
        } else if ([[ele name] isEqualToString:@"bgscan_time_action"]) {
            self.bgscan_time_action = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"bgscan_time"]) {
            self.bgscan_time = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"manual_network_start"]) {
            self.manual_network_start = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"search_network"]) {
            self.search_network = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"network_param"]) {
            self.network_param = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"network_param_action"]) {
            self.network_param_action = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"auto_network_action"]) {
            
        } else if ([[ele name] isEqualToString:@"network_select_done"]) {
            
        } else if ([[ele name] isEqualToString:@"auto_network"]) {
            self.auto_network = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"select_NW_Mode"]) {
            self.select_NW_Mode = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"mannual_network_list"]) {
            NSArray *mannualNetworkListElements = ele.children;
            NSMutableArray *mannualNetworkContextList = [[NSMutableArray alloc]initWithCapacity:mannualNetworkListElements.count];
            for (int j = 0; j <mannualNetworkListElements.count; j++) {
                [mannualNetworkContextList addObject:[NIMannualNetworkItemModel mannualNetworkItemWithXMLElement:[mannualNetworkListElements objectAtIndex:j]]];
            }
            self.mannual_network_list = mannualNetworkContextList;
        } else if ([[ele name] isEqualToString:@"NW_mode"]) {
            self.NW_mode = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"prefer_mode"]) {
            self.prefer_mode = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"prefer_mode1"]) {
            self.prefer_mode1 = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"prefer_mode2"]) {
            self.prefer_mode2 = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"NW_mode_action"]) {
            self.NW_mode_action = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"prefer_mode_action"]) {
            self.prefer_mode_action = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"prefer_lte_type"]) {
            self.prefer_lte_type = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"prefer_lte_type_action"]) {
            self.prefer_lte_type_action = ele.stringValue;
        } else if ([[ele name] isEqualToString:@"pdp_auto_list"]) {
            NSArray *pdpAutoListElements = ele.children;
            NSMutableArray *pdpAutoList = [[NSMutableArray alloc]initWithCapacity:pdpAutoListElements.count];
            for (int j = 0; j <pdpAutoListElements.count; j++) {
                [pdpAutoList addObject:[NIPdpAutoListItemModel pdpAutoListItemWithXMLElement:[pdpAutoListElements objectAtIndex:j]]];
            }
            self.pdp_auto_list = pdpAutoList;
        }
    }
}



@end
