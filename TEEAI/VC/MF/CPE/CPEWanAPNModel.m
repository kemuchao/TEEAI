//
//  CPEWanAPNModel.m
//  MifiManager
//
//  Created by notion on 2018/7/3.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "CPEWanAPNModel.h"

@implementation CPEWanAPNModel
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
    for (GDataXMLElement *element in childrenElements) {
        for (GDataXMLElement *defaultItem in element.children) {
            if ([defaultItem.name isEqualToString:@"default"]) {
                for (GDataXMLElement *apnItem in defaultItem.children) {
                    if ([apnItem.name isEqualToString:@"connection_num"]) {
                        _connetionNum = apnItem.stringValue;
                    }else if ([apnItem.name isEqualToString:@"type"]){
                        _type = apnItem.stringValue;
                    }else if ([apnItem.name isEqualToString:@"autp_apn"]){
                        _autoAPN = apnItem.stringValue;
                    }else if ([apnItem.name isEqualToString:@"connect_mode"]){
                        _connectMode = apnItem.stringValue;
                    }else if ([apnItem.name isEqualToString:@"lte_default"]){
                        _lteDefault = apnItem.stringValue;
                    }else if ([apnItem.name isEqualToString:@"data_on_roaming"]){
                        _dataOnRoaming = apnItem.stringValue;
                    }else if ([apnItem.name isEqualToString:@"pdp_name"]){
                        _pdpName = apnItem.stringValue;
                    }else if ([apnItem.name isEqualToString:@"enable"]){
                        _enable = apnItem.stringValue;
                    }else if ([apnItem.name isEqualToString:@"ip_type"]){
                        _ipType = apnItem.stringValue;
                    }else if ([apnItem.name isEqualToString:@"apn"]){
                        _apn = apnItem.stringValue;
                    }else if ([apnItem.name isEqualToString:@"lte_apn"]){
                        _lteApn = apnItem.stringValue;
                    }else if ([apnItem.name isEqualToString:@"usr_2g3g"]){
                        _usr2g3g = apnItem.stringValue;
                    }else if ([apnItem.name isEqualToString:@"pswd_2g3g"]){
                        _pswd2g3g = apnItem.stringValue;
                    }else if ([apnItem.name isEqualToString:@"authtype_2g3g"]){
                        _authtype2g3g = apnItem.stringValue;
                    }else if ([apnItem.name isEqualToString:@"usr_4g"]){
                        _usr4g = apnItem.stringValue;
                    }else if ([apnItem.name isEqualToString:@"pswd_4g"]){
                        _pswd4g = apnItem.stringValue;
                    }else if ([apnItem.name isEqualToString:@"authtype_4g"]){
                        _authtype4g = apnItem.stringValue;
                    }else if ([apnItem.name isEqualToString:@"mtu"]){
                        _mtu = apnItem.stringValue;
                    }else if ([apnItem.name isEqualToString:@"modifiable"]){
                        _modifiable = apnItem.stringValue;
                    }
                }
            }
        }
    }
}
@end
