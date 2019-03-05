//
//  NIStorageModel.h
//  MifiApp
//
//  Created by yueguangkai on 15/11/6.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface NIStorageModel : NSObject
@property (nonatomic, copy) NSString *enabled;

-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString;
+(instancetype) storageWithResponseXmlString:(NSString *)responseXmlString;

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement;
+(instancetype) storageWithXMLElement:(GDataXMLElement *) xmlElement;
@end
