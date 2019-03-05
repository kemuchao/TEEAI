//
//  CPERequestXML.h
//  MifiManager
//
//  Created by notion on 2018/6/21.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
@interface CPERequestXML : NSObject
+ (NSMutableString *)getXMLWithPath:(NSString *)path method:(NSString *)method addXML:(NSString *)addXML;
@end
