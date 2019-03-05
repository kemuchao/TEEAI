//
//  URLSetting.h
//  MifiManager
//
//  Created by notion on 2018/3/26.
//  Copyright © 2018年 notion. All rights reserved.
//

#ifndef URLSetting_h
#define URLSetting_h

#define BASE_URL @"https://clienttest.tee.com/"

//CPE
#define CPE_REQUEST_COMMON @"/xml_action.cgi?method=set"

// request url
#define MIFI_BASE_URL @"http://192.168.0.1"
#define MIFI_STATUS1_PATH @"/xml_action.cgi?method=get&module=duster&file=status1"
#define MIFI_WAN_GET_PATH @"/xml_action.cgi?method=get&module=duster&file=wan"
#define MIFI_WAN_SET_PATH @"/xml_action.cgi?method=set&module=duster&file=wan"

//流量统计相关
#define MIFI_STATISTICS_GET_PATH @"/xml_action.cgi?method=get&module=duster&file=statistics"
#define MIFI_STATISTICS_SET_PATH @"/xml_action.cgi?method=set&module=duster&file=statistics"

#define MIFI_RESET_ROUTER_PATH @"/xml_action.cgi?method=get&module=duster&file=reset"
#define MIFI_CLOSE_ROUTER_PATH @"/xml_action.cgi?method=get&module=duster&file=power_off"

//连接设备管理
#define MIFI_GET_DEVICE_MANAGEMENT @"/xml_action.cgi?method=get&module=duster&file=device_management"
#define MIFI_SET_DEVICE_MANAGEMENT @"/xml_action.cgi?method=set&module=duster&file=device_management_all"

#define MIFI_WLAN_SECURITY_PATH @"/xml_action.cgi?method=get&module=duster&file=uapxb_wlan_security_settings"
#define MIFI_SET_WLAN_SECURITY_PATH @"/xml_action.cgi?method=set&module=duster&file=uapxb_wlan_security_settings"
#define MIFI_WLAN_BASIC_PATH @"/xml_action.cgi?method=get&module=duster&file=uapxb_wlan_basic_settings"
#define MIFI_SET_WLAN_BASIC_PATH @"/xml_action.cgi?method=set&module=duster&file=uapxb_wlan_basic_settings"
#define MIFI_REBOOT_PATH @"/xml_action.cgi?method=get&module=duster&file=reset"
#define MIFI_RESET_PATH @"/xml_action.cgi?method=get&module=duster&file=restore_defaults"
#define MIFI_PIN_PUK_PATH @"/xml_action.cgi?method=get&module=duster&file=pin_puk"
#define MIFI_SET_PIN_PUK_PATH @"/xml_action.cgi?method=set&module=duster&file=pin_puk"
#define MIFI_GET_CUSTOM_FW_PATH @"/xml_action.cgi?method=get&module=duster&file=custom_fw"
#define MIFI_SET_CUSTOM_FW_PATH @"/xml_action.cgi?method=set&module=duster&file=custom_fw"
#define MIFI_GET_PORT_FILTER_PATH @"/xml_action.cgi?method=get&module=duster&file=port_filter"
#define MIFI_SET_PORT_FILTER_PATH @"/xml_action.cgi?method=set&module=duster&file=port_filter"
#define MIFI_GET_TIME_SETTING_PATH @"/xml_action.cgi?method=get&module=duster&file=time_setting"
#define MIFI_SET_TIME_SETTING_PATH @"/xml_action.cgi?method=set&module=duster&file=time_setting"
#define MIFI_SET_ADMIN_PATH @"/xml_action.cgi?method=set&module=duster&file=admin"
#define MIFI_GET_LAN_PATH @"/xml_action.cgi?method=get&module=duster&file=lan"
#define MIFI_SET_LAN_PATH @"/xml_action.cgi?method=set&module=duster&file=lan"
#define MIFI_GET_MAC_FILTERS @"/xml_action.cgi?method=get&module=duster&file=uapx_wlan_mac_filters"
#define MIFI_SET_MAC_FILTERS @"/xml_action.cgi?method=set&module=duster&file=uapx_wlan_mac_filters"
#define MIFI_SET_WLAN_MAC_FILTERS @"/xml_action.cgi?method=set&module=duster&file=wlan_mac_filters"

#define MIFI_GET_MESSAGE_PATH @"/xml_action.cgi?method=get&module=duster&file=message"
#define MIFI_SET_MESSAGE_PATH @"/xml_action.cgi?method=set&module=duster&file=message"
//USSD 相关
#define MIFI_GET_USSD_PATH @"/xml_action.cgi?method=get&module=duster&file=ussd"
#define MIFI_SET_USSD_PATH @"/xml_action.cgi?method=set&module=duster&file=ussd"
#pragma mark - 常规命名

#define ADMIN_NAME @"admin_name"
#define ADMIN_PSW @"admin_password"
#define NET_NAME @"net_name"
#define NET_PATH @"net_path"
#define ConnectMIFI @"connecting"
#define DeviceIP @"IP"
#define ROUTEIP @"route_ip"
#define StatusSIM @"sim_status"
#define StatusPIN @"pin_status"
#define NET_STATE_CHANGE @"net_status"
#define DeviceRefresh @"device_change"
#define Cookie @"cookie"

#define VersionName @"version"
#define Version1802 @"1802"
#define VersionCPE @"CPE"

#define CPEResultOK @"OK"
#define CPEResultNeedLogin @"5"
//0 1802
//1 CPE


#define Timer @"timer"

#endif /* URLSetting_h */
