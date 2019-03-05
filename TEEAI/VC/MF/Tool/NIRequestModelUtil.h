//
//  NIRequestModelUtil.h
//  IOS_MIFI_APP
//
//  Created by yueguangkai on 15/11/16.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIRequestModelUtil : NSObject
+(NSString *) XMLStringWithParentNodeName:(NSString *)parentNodeName subNodes:(NSArray *)nodes;
+(NSString *) XMLStringWithParentNodesName:(NSArray *)parentNodesName subNodes:(NSArray *)nodes;
+(NSString *) XMLStringWithParentNodesName:(NSArray *)parentNodesName xmlNodesString:(NSString *) string;
@end
