//
//  MessageInfo.m
//  MifiManager
//
//  Created by notion on 2018/3/29.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "MessageInfo.h"

@implementation MessageInfo
+ (instancetype)initWithXMLElement:(GDataXMLElement *)xmlElement{
    return [[self alloc] initWithXMLElement:xmlElement];
}
- (instancetype)initWithXMLElement:(GDataXMLElement *)xmlElement{
    self = [super init];
    [self dealXMLElement:xmlElement];
    return self;
}
- (void)dealXMLElement:(GDataXMLElement *)element{
    
    NSArray *eleArray = [element children];
    for (int i = 0; i<eleArray.count; i++) {
        GDataXMLElement *ele = eleArray[i];
        NSString *eleName = [ele name];
        if ([eleName isEqualToString:@"index"]) {
            self.index = ele.stringValue;
        }else if ([eleName isEqualToString:@"from"]){
            self.from = ele.stringValue;
        }else if ([eleName isEqualToString:@"subject"]){
            self.subject = ele.stringValue;
        }else if ([eleName isEqualToString:@"received"]){
            self.received = ele.stringValue;
        }else if ([eleName isEqualToString:@"status"]){
            self.status = ele.stringValue;
        }else if ([eleName isEqualToString:@"message_type"]){
            self.messageType = ele.stringValue;
        }else if ([eleName isEqualToString:@"class_type"]){
            self.classType = ele.stringValue;
        }
    }
}
@end
