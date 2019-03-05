////
//  DeviceManagement.m
//  MifiManager
//
//  Created by notion on 2018/3/28.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "DeviceManagement.h"

@implementation DeviceManagement
-(instancetype) initWithResponseXmlString:(NSString *) responseXmlString isRGWStartXml:(BOOL) isRGWStartXml{
    self = [super init];
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithXMLString:responseXmlString options:0 error:nil];
    GDataXMLElement *xmlElement = [document rootElement];
    _deviceArray = [NSMutableArray array];
    [self dealXMLElement:xmlElement];
    return self;
}
+(instancetype) initWithResponseXmlString:(NSString *)responseXmlString isRGWStartXml:(BOOL) isRGWStartXml{
    return [[self alloc] initWithResponseXmlString:responseXmlString isRGWStartXml:isRGWStartXml];
}

-(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement{
    self = [super init];
    [self dealXMLElement:xmlElement];
    return self;
}
+(instancetype) initWithXMLElement:(GDataXMLElement *) xmlElement{
    return [[self alloc] initWithXMLElement:xmlElement];
}

- (void)dealXMLElement:(GDataXMLElement *)xmlElement{
    NSArray *childrenElements = [xmlElement children];
    for (int i = 0; i < [childrenElements count]; i++) {
        GDataXMLElement *ele = [childrenElements objectAtIndex:i];
        NSLog(@"element_%@",ele);
        if ([[ele name] isEqualToString:@"device_management"]) {
            NSArray *devices = [ele children];
            for (int item=0; item<devices.count; item++) {
                GDataXMLElement *listElement = devices[item];
                if ([[listElement name] isEqualToString:@"client_list"]) {
                    NSArray *deviceArray = [listElement elementsForName:@"Item"];
                    for (int index = 0; index <deviceArray.count; index++) {
                        DeviceInfo *device = [DeviceInfo initWithXMLElement:deviceArray[index]];
                       [_deviceArray addObject:device];
                    }
                }
                
            }
        } else {
            
        }
    }
}
@end
