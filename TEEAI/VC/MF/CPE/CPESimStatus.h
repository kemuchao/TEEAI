//
//  CPESimStatus.h
//  MifiManager
//
//  Created by notion on 2018/6/22.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPESimStatus : NSObject
@property (nonatomic, strong) NSString *simStatus;
@property (nonatomic, strong) NSString *pinStatus;
@property (nonatomic, strong) NSString *pinAttempts;
@property (nonatomic, strong) NSString *pukAttempts;
@property (nonatomic, strong) NSString *mepSimAttempts;
@property (nonatomic, strong) NSString *mepNwAttempts;
@property (nonatomic, strong) NSString *mepSubNwAttempts;
@property (nonatomic, strong) NSString *mepSpAttempts;
@property (nonatomic, strong) NSString *mepCorpAttempts;
@property (nonatomic, strong) NSString *pinEnabled;
@property (nonatomic, strong) NSString *pnStatus;
@property (nonatomic, strong) NSString *puStatus;
@property (nonatomic, strong) NSString *ppStatus;
@property (nonatomic, strong) NSString *pcStatus;
@property (nonatomic, strong) NSString *psStatus;
@property (nonatomic, strong) NSString *settingResponse;
+(instancetype) initWithResponseXmlString:(NSString *)responseXmlString;
@end
