//
//  NIPinPukMEPModel.h
//  IOS_MIFI_APP
//
//  Created by yueguangkai on 15/12/1.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface NIPinPukMEPModel : NSObject
@property (nonatomic, copy) NSString *CURRENT_STATUS;
@property (nonatomic, copy) NSString *MEP_ACTION;
@property (nonatomic, copy) NSString *PASSWD;
@property (nonatomic, copy) NSString *PUK_PASSWD;
@property (nonatomic, copy) NSString *ACTION_RESULT;
@property (nonatomic, copy) NSString *PN_STATUS;
@property (nonatomic, copy) NSString *PU_STATUS;
@property (nonatomic, copy) NSString *PP_STATUS;
@property (nonatomic, copy) NSString *PC_STATUS;
@property (nonatomic, copy) NSString *SIMLOCK_STATUS;
@property (nonatomic, copy) NSString *SIM_LEFT_RETRY_NUM;
@property (nonatomic, copy) NSString *NW_LEFT_RETRY_NUM;
@property (nonatomic, copy) NSString *NWSUB_LEFT_RETRY_NUM;
@property (nonatomic, copy) NSString *PS_LEFT_RETRY_NUM;
@property (nonatomic, copy) NSString *CORP_LEFT_RETRY_NUM;
-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString;
+(instancetype) MEPWithResponseXmlString:(NSString *)responseXmlString;

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
+(instancetype) MEPWithXMLElement:(GDataXMLElement *) xmlElement;
@end
