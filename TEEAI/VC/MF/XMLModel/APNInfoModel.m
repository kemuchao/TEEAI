//
//  APNInfoModel.m
//  MifiManager
//
//  Created by notion on 2018/4/26.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "APNInfoModel.h"

@implementation APNInfoModel
+ (instancetype)initWithXMLElement:(GDataXMLElement *)xmlElement{
    return [[self alloc] initWithXMLElement:xmlElement];
}
- (instancetype)initWithXMLElement:(GDataXMLElement *)xmlElement{
    self = [super init];
    [self dealXMLElement:xmlElement];
    return self;
}
- (void)dealXMLElement:(GDataXMLElement *)element{
    NSLog(@"device_%@",element);
    NSArray *eleArray = [element children];
    for (int i = 0; i<eleArray.count; i++) {
        GDataXMLElement *ele = eleArray[i];
        NSString *eleName = [ele name];
        if ([eleName isEqualToString:@"rulename"]) {
            self.ruleName = ele.stringValue;
        }else if ([eleName isEqualToString:@"connnum"]){
            self.connnum = ele.stringValue;
        }else if ([eleName isEqualToString:@"pconnnum"]){
            self.pconnum = ele.stringValue;
        }else if ([eleName isEqualToString:@"enable"]){
            self.enable = ele.stringValue;
        }else if ([eleName isEqualToString:@"conntype"]){
            self.conntype = ele.stringValue;
        }else if ([eleName isEqualToString:@"default"]){
            self.defaultObject = ele.stringValue;
        }else if ([eleName isEqualToString:@"secondary"]){
            self.secondary = ele.stringValue;
        }else if ([eleName isEqualToString:@"spn"]){
            self.spn = ele.stringValue;
        }else if ([eleName isEqualToString:@"lte_spn"]){
            self.lteSpn = ele.stringValue;
        }else if ([eleName isEqualToString:@"iptype"]){
            self.ipType = ele.stringValue;
        }else if ([eleName isEqualToString:@"qci"]){
            self.qci = ele.stringValue;
        }else if ([eleName isEqualToString:@"authtype2g3"]){
            self.authType2g3 = ele.stringValue;
        }else if ([eleName isEqualToString:@"usr2g3"]){
            self.usr2g3 = ele.stringValue;
        }else if ([eleName isEqualToString:@"paswd2g3"]){
            self.paswd2g3 = ele.stringValue;
        }else if ([eleName isEqualToString:@"authtype4g"]){
            self.authType4g = ele.stringValue;
        }else if ([eleName isEqualToString:@"usr4g"]){
            self.usr4g = ele.stringValue;
        }else if ([eleName isEqualToString:@"paswd4g"]){
            self.paswd4g = ele.stringValue;
        }else if ([eleName isEqualToString:@"hastft"]){
            self.hastft = ele.stringValue;
        }
    }
}
@end
