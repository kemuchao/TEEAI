//
//  CPENetworkModel.h
//  MifiManager
//
//  Created by notion on 2018/7/3.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
#import "CPENetListItem.h"
@interface CPENetworkModel : NSObject
@property (nonatomic, strong) NSMutableArray *netArray;
@property (nonatomic, strong) NSString *response;
+(instancetype) initWithResponseXmlString:(NSString *)responseXmlString;
@end
