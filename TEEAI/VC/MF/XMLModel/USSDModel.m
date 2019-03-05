
//
//  USSDModel.m
//  MifiManager
//
//  Created by notion on 2018/5/3.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "USSDModel.h"

@implementation USSDModel
+(instancetype) initWithResponseXmlString:(NSString *)responseXmlString{
    return [[self alloc] initWithResponseXmlString:responseXmlString];
}
-(instancetype) initWithResponseXmlString:(NSString *)responseXmlString{
    self = [super init];
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithXMLString:responseXmlString options:0 error:nil];
    GDataXMLElement *element = [document rootElement];
    [self dealXMLElement:element];
    return self;
}

- (void)dealXMLElement:(GDataXMLElement *)element{
    NSArray *nodeArray = [element children];
    for (GDataXMLElement *ele in nodeArray) {
        if ([ele.name isEqualToString:@"flag"]) {
            NSArray *flagArray = [ele children];
            for (GDataXMLElement *flag in flagArray) {
                if ([flag.name isEqualToString:@"ussd_type"]) {
                    self.type = flag.stringValue;
                }else if ([flag.name isEqualToString:@"ussd_str"]){
                    self.str = flag.stringValue;
                }
            }
        }
    }
}
@end
