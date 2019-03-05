//
//  NIPinPukModel.h
//  IOS_MIFI_APP
//
//  Created by yueguangkai on 15/12/1.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
@class NIPinPukMEPModel;

@interface NIPinPukModel : NSObject
@property (nonatomic, copy) NSString *pin_attempts;
@property (nonatomic, copy) NSString *puk_attempts;
@property (nonatomic, copy) NSString *pin_enabled;
@property (nonatomic, copy) NSString *cmd_status;
@property (nonatomic, strong) NIPinPukMEPModel *MEP;
-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString isRGWStartXml:(BOOL) isRGWStartXml;
+(instancetype) pinPukWithResponseXmlString:(NSString *)responseXmlString isRGWStartXml:(BOOL) isRGWStartXml;

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
+(instancetype) pinPukWithXMLElement:(GDataXMLElement *) xmlElement;
@end
