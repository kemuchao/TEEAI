//
//  LanguageModel.m
//  MifiManager
//
//  Created by notion on 2018/6/21.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "LanguageModel.h"

@implementation LanguageModel
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
        if ([ele.name isEqualToString:@"error_cause"]) {
            _errorCause = ele.stringValue;
        }else if ([ele.name isEqualToString:@"system"]){
            for (GDataXMLElement *element in ele.children) {
                if ([element.name isEqualToString:@"language"]) {
                    _language = element.stringValue;
                }
            }
        }
    }
}
@end
