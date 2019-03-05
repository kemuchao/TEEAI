//
//  CPEUnreadSMS.m
//  MifiManager
//
//  Created by notion on 2018/7/3.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "CPEUnreadSMS.h"

@implementation CPEUnreadSMS
-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString
{
    if (self = [super init]) {
        GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:responseXmlString options:0 error:nil];
        GDataXMLElement *element = [document rootElement];
        [self initDatasWithXMLElement:element];
    }
    return self;
}

+(instancetype) initWithResponseXmlString:(NSString *)responseXmlString
{
    return [[self alloc]initWithResponseXmlString:responseXmlString];
}

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement
{
    if (self = [super init]) {
        [self initDatasWithXMLElement:xmlElement];
    }
    return self;
}

-(void) initDatasWithXMLElement:(GDataXMLElement *) xmlElement
{
    NSArray *childrenElements = [xmlElement children];
    _unreadNum = 0;
    for (int i = 0; i < [childrenElements count]; i++) {
        GDataXMLElement *ele = [childrenElements objectAtIndex:i];
        if ([ele.name isEqualToString:@"sms"]) {
            _messageArray = [NSMutableArray array];
            for (GDataXMLElement *list in ele.children) {
                if ([list.name isEqualToString:@"node_list"]) {
                    for (int i = 0; i<list.children.count; i++) {
                        GDataXMLElement *item = [list.children objectAtIndex:i];
                        CPESMSModel *messageModel = [CPESMSModel intiWithXMLElement:item];
                        if (messageModel.read.intValue == 0) {
                            _unreadNum ++;
                        }
                        [_messageArray addObject:messageModel];
                    }
                }
            }
            
        }
    }
}
@end
