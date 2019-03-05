//
//  CPEWanConfig.m
//  MifiManager
//
//  Created by notion on 2018/7/3.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "CPEWanConfig.h"

@implementation CPEWanConfig
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
    for (int i = 0; i < [childrenElements count]; i++) {
        GDataXMLElement *ele = [childrenElements objectAtIndex:i];
        if ([ele.name isEqualToString:@"profile"]) {
            for (GDataXMLElement *fileName in ele.children) {
                if ([fileName.name isEqualToString:@"actived_profile"]) {
                    _activedProfile = fileName.stringValue;
                }else if ([fileName.name isEqualToString:@"profile_names"]){
                    _profileNames = [fileName.stringValue componentsSeparatedByString:@","];
                }
            }
        }else{
            
        }
    }
    for (GDataXMLElement *ele in childrenElements) {
        _apnArray = [NSMutableArray array];
        for (NSString *apnName in _profileNames) {
            if ([ele.name isEqualToString:apnName]) {
                CPEWanAPNModel *apn = [CPEWanAPNModel intiWithXMLElement:ele];
                apn.apnFileName = ele.name;
                [_apnArray addObject:apn];
                if ([apnName isEqualToString:_activedProfile]) {
                    _activeAPN = apn;
                }
            }
        }
    }
}
@end
