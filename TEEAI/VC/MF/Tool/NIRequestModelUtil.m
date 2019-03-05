//
//  NIRequestModelUtil.m
//  IOS_MIFI_APP
//
//  Created by yueguangkai on 15/11/16.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import "NIRequestModelUtil.h"
#import "NINodeModel.h"

@implementation NIRequestModelUtil
+(NSString *) XMLStringWithParentNodeName:(NSString *)parentNodeName subNodes:(NSArray *)nodes
{
    NSMutableString *result = [[NSMutableString alloc]init];
    [result appendString:@"<?xml version=\"1.0\" encoding=\"US-ASCII\"?><RGW>"];
    [result appendFormat:@"<%@>", parentNodeName];
    for (NINodeModel *subNode in nodes) {
        [result appendFormat:@"<%@>%@</%@>",subNode.nodename, subNode.value, subNode.nodename];
    }
    [result appendFormat:@"</%@>", parentNodeName];
    [result appendString:@"</RGW>"];
    return [result copy];
}

+(NSString *) XMLStringWithParentNodesName:(NSArray *)parentNodesName subNodes:(NSArray *)nodes
{
    NSMutableString *result = [[NSMutableString alloc]init];
    [result appendString:@"<?xml version=\"1.0\" encoding=\"US-ASCII\"?><RGW>"];
    for (NSString *node in parentNodesName) {
        if ([node isEqualToString:@"Item"]) {
            [result appendFormat:@"<%@ index='0'>", node];
        } else {
            [result appendFormat:@"<%@>", node];
        }
    }
    for (NINodeModel *subNode in nodes) {
        [result appendFormat:@"<%@>%@</%@>",subNode.nodename, subNode.value, subNode.nodename];
    }
    for (int i = 0; i < parentNodesName.count; i++) {
        [result appendFormat:@"</%@>", parentNodesName[parentNodesName.count - 1 - i]];
    }
    [result appendString:@"</RGW>"];
    return [result copy];
}


+(NSString *) XMLStringWithParentNodesName:(NSArray *)parentNodesName xmlNodesString:(NSString *) string
{
    NSMutableString *result = [[NSMutableString alloc]init];
    [result appendString:@"<?xml version=\"1.0\" encoding=\"US-ASCII\"?><RGW>"];
    for (NSString *node in parentNodesName) {
        if ([node isEqualToString:@"Item"]) {
            [result appendFormat:@"<%@ index='0'>", node];
        } else {
            [result appendFormat:@"<%@>", node];
        }
    }
    [result appendFormat:@"%@",string];
    for (int i = 0; i < parentNodesName.count; i++) {
        [result appendFormat:@"</%@>", parentNodesName[parentNodesName.count - 1 - i]];
    }
    [result appendString:@"</RGW>"];
    return [result copy];
}
@end
