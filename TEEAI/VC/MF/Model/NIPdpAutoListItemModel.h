//
//  NIPdpAutoListItemModel.h
//  MifiApp
//
//  Created by yueguangkai on 15/11/8.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface NIPdpAutoListItemModel : NSObject
@property (nonatomic, copy) NSString *index;
@property (nonatomic, copy) NSString *mmc;
@property (nonatomic, copy) NSString *mnc;
@property (nonatomic, copy) NSString *operator_name;
@property (nonatomic, copy) NSString *apn;
@property (nonatomic, copy) NSString *lte_apn;
@property (nonatomic, copy) NSString *network_type;
@property (nonatomic, copy) NSString *authtype2g3g;
@property (nonatomic, copy) NSString *username2g3g;
@property (nonatomic, copy) NSString *password2g3g;
@property (nonatomic, copy) NSString *authtype4g;
@property (nonatomic, copy) NSString *username4g;
@property (nonatomic, copy) NSString *password4g;
@property (nonatomic, copy) NSString *iptype;
@property (nonatomic, copy) NSString *defaultObject;
-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString;
+(instancetype) pdpAutoListItemWithResponseXmlString:(NSString *)responseXmlString;

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
+(instancetype) pdpAutoListItemWithXMLElement:(GDataXMLElement *) xmlElement;
@end
