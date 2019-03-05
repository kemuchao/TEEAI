//
//  CPERequest.h
//  MifiManager
//
//  Created by notion on 2018/6/21.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPERequest : NSObject
+ (void)requestWith:(NSString *)path method:(NSString *)method success:(void (^)(AFHTTPRequestOperation *operation, id responseObj))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
