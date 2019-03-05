//
//  CPENetListItem.h
//  MifiManager
//
//  Created by notion on 2018/7/3.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
@interface CPENetListItem : NSObject
@property (nonatomic, strong) NSString *ispName;
@property (nonatomic, strong) NSString *plmn;
@property (nonatomic, strong) NSString *act;
+(instancetype) intiWithXMLElement:(GDataXMLElement *)xmlElement;
@end
