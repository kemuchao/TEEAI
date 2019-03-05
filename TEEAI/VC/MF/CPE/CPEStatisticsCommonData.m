//
//  CPEStatisticsCommonData.m
//  MifiManager
//
//  Created by notion on 2018/6/22.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "CPEStatisticsCommonData.h"
#import "GDataXMLNode.h"
@implementation CPEStatisticsCommonData
-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString
{
    if (self = [super init]) {
        GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:responseXmlString options:0 error:nil];
        GDataXMLElement *element = [document rootElement];
        [self initDatasWithXMLElement:element];
    }
    return self;
}

+(instancetype) initWithResponseXmlString:(NSString *)responseXmlString
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

-(void) initDatasWithXMLElement:(GDataXMLElement *) xmlElement
{
    NSArray *childrenElements = [xmlElement children];
    for (int i = 0; i < [childrenElements count]; i++) {
        GDataXMLElement *ele = [childrenElements objectAtIndex:i];
        if ([[ele name] isEqualToString:@"statistics"]) {
            NSArray *bytesArray = [ele children];
            for (int j=0; j<bytesArray.count; j++) {
                GDataXMLElement *element = [bytesArray objectAtIndex:j];
                if ([element.name isEqualToString:@"rx_bytes"]) {
                    _rxBytes = element.stringValue;
                }else if ([element.name isEqualToString:@"tx_bytes"]) {
                    _txBytes = element.stringValue;
                }else if ([element.name isEqualToString:@"rx_tx_bytes"]) {
                    _rxTxBytes = element.stringValue;
                }else if ([element.name isEqualToString:@"error_bytes"]) {
                    _errorBytes = element.stringValue;
                }else if ([element.name isEqualToString:@"total_rx_bytes"]) {
                    _totalRxBytes = element.stringValue;
                }else if ([element.name isEqualToString:@"total_tx_bytes"]) {
                    _totalTxBytes = element.stringValue;
                }else if ([element.name isEqualToString:@"total_rx_tx_bytes"]) {
                    _totalRxTxBytes = element.stringValue;
                }else if ([element.name isEqualToString:@"total_error_bytes"]) {
                    _totalErrorBytes = element.stringValue;
                }else{
                    
                }
            }
        }
    }
}
@end
