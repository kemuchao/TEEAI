//
//  NIPdpSupportedListItemModel.h
//  IOS_MIFI_APP
//
//  Created by yueguangkai on 15/11/15.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface NIPdpSupportedListItemModel : NSObject
@property (nonatomic, copy) NSString *index;
@property (nonatomic, copy) NSString *rulename;
@property (nonatomic, copy) NSString *connnum;
@property (nonatomic, copy) NSString *pconnnum;
@property (nonatomic, copy) NSString *enable;
@property (nonatomic, copy) NSString *conntype;
@property (nonatomic, copy) NSString *pdefault;
@property (nonatomic, copy) NSString *secondary;
@property (nonatomic, copy) NSString *apn;
@property (nonatomic, copy) NSString *lte_apn;
@property (nonatomic, copy) NSString *iptype;
@property (nonatomic, copy) NSString *qci;
@property (nonatomic, copy) NSString *authtype2g3;
@property (nonatomic, copy) NSString *usr2g3;
@property (nonatomic, copy) NSString *paswd2g3;
@property (nonatomic, copy) NSString *authtype4g;
@property (nonatomic, copy) NSString *usr4g;
@property (nonatomic, copy) NSString *paswd4g;
@property (nonatomic, copy) NSString *hastft;

-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString;
+(instancetype) pdpSupportedListItemWithResponseXmlString:(NSString *)responseXmlString;

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
+(instancetype) pdpSupportedListItemWithXMLElement:(GDataXMLElement *) xmlElement;
@end
