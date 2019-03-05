//
//  CPERequestXML.m
//  MifiManager
//
//  Created by notion on 2018/6/21.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "CPERequestXML.h"

@implementation CPERequestXML
+ (NSMutableString *)getXMLWithPath:(NSString *)path method:(NSString *)method addXML:(NSString *)addXML{
    NSMutableString *result = [[NSMutableString alloc]init];
    [result appendString:@"<?xml version=\"1.0\" encoding=\"US-ASCII\"?><RGW><param>"];
    [result appendFormat:@"<method>call</method>"];
    [result appendFormat:@"<session>000</session>"];
    [result appendFormat:@"<obj_path>%@</obj_path>",path];
    [result appendFormat:@"<obj_method>%@</obj_method>",method];
    [result appendString:@"</param>"];
    if (addXML) {
        [result appendString:addXML];
    }
    [result appendFormat:@"</RGW>"];
    return [result copy];
}
@end
