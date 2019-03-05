//
//  CPEClientModel.m
//  MifiManager
//
//  Created by notion on 2018/6/25.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "CPEClientModel.h"
#import "GDataXMLNode.h"
@implementation CPEClientModel

+(instancetype) intiWithXMLElement:(GDataXMLElement *)xmlElement{
    return [[self alloc] initWithXMLElement:xmlElement];
}
-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement
{
    if (self = [super init]) {
        [self initDatasWithXMLElement:xmlElement];
    }
    return self;
}

-(void) initDatasWithXMLElement:(GDataXMLElement *) xmlElement
{
    NSArray *childrenElements = [xmlElement children];
    for (int i = 0; i < [childrenElements count]; i++) {
        GDataXMLElement *ele = [childrenElements objectAtIndex:i];
        if ([ele.name isEqualToString:@"mac"]) {
            _mac = ele.stringValue;
        }else if ([ele.name isEqualToString:@"type"]){
            _type = ele.stringValue;
        }else if ([ele.name isEqualToString:@"ip"]){
            _ip = ele.stringValue;
        }else if ([ele.name isEqualToString:@"name"]){
            _name = ele.stringValue;
        }else if ([ele.name isEqualToString:@"cur_conn_time"]){
            _curConnTime = ele.stringValue;
        }else if ([ele.name isEqualToString:@"status"]){
            _status = ele.stringValue;
        }else if ([ele.name isEqualToString:@"total_conn_time"]){
            _totalConnTime = ele.stringValue;
        }else if ([ele.name isEqualToString:@"last_conn_time"]){
            _lastConnTime = ele.stringValue;
        }else if ([ele.name isEqualToString:@"mon_rx_bytes"]){
            _monRxBytes = ele.stringValue;
        }else if ([ele.name isEqualToString:@"mon_tx_bytes"]){
            _monTxBytes = ele.stringValue;
        }else if ([ele.name isEqualToString:@"mon_total_bytes"]){
            _monTotalBytes = ele.stringValue;
        }else if ([ele.name isEqualToString:@"last_3days_rx_bytes"]){
            _last3DaysRxBytes = ele.stringValue;
        }else if ([ele.name isEqualToString:@"last_3days_tx_bytes"]){
            _last3DaysTxBytes = ele.stringValue;
        }else if ([ele.name isEqualToString:@"last_3days_total_bytes"]){
            _last3DaysTotalBytes = ele.stringValue;
        }else if ([ele.name isEqualToString:@"total_rx_bytes"]){
            _totalRxBytes = ele.stringValue;
        }else if ([ele.name isEqualToString:@"total_tx_bytes"]){
            _totalTxBytes = ele.stringValue;
        }else if ([ele.name isEqualToString:@"total_bytes"]){
            _totalBytes = ele.stringValue;
        }
    }
}
@end
