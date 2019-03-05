//
//  Statistics.m
//  MifiManager
//
//  Created by notion on 2018/4/4.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "Statistics.h"

@implementation Statistics
+(instancetype) initWithResponseXmlString:(NSString *)responseXmlString isRGWStartXml:(BOOL) isRGWStartXml{
    return [[self alloc] initWithResponseXmlString:responseXmlString isRGWStartXml:isRGWStartXml];
}
-(instancetype) initWithResponseXmlString:(NSString *)responseXmlString isRGWStartXml:(BOOL) isRGWStartXml{
    self = [super init];
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithXMLString:responseXmlString options:0 error:nil];
    GDataXMLElement *element = [document rootElement];
    [self dealXMLElement:element];
    return self;
}

- (void)dealXMLElement:(GDataXMLElement *)element{
    NSArray *eleArray = [element children];
    GDataXMLElement *statistics = [eleArray objectAtIndex:0];
    NSArray *statisticsArray = [statistics children];
    for (GDataXMLElement *ele in statisticsArray) {
        if ([[ele name] isEqualToString:@"WanStatistics"]) {
            WanStatistics *wanStatistics = [WanStatistics initWithXMLElement:ele];
            _wanStatistics = wanStatistics;
        }else if ([[ele name] isEqualToString:@"WlanStatistics"]){
            WlanStatistics *wlanStatistics = [WlanStatistics initWithXMLElement:ele];
            _wlanStatistics = wlanStatistics;
        }
    }
}
@end
