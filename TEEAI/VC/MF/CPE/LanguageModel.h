//
//  LanguageModel.h
//  MifiManager
//
//  Created by notion on 2018/6/21.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
@interface LanguageModel : NSObject
@property (nonatomic, strong) NSString *errorCause;
@property (nonatomic, strong) NSString *language;
+(instancetype) initWithResponseXmlString:(NSString *)responseXmlString;
@end
