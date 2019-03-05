//
//  NIHttpUtil.h
//  MifiApp
//
//  Created by yueguangkai on 15/11/4.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "NIJsonReadTool.h"

@interface NIHttpUtil : NSObject


/**
 *  send GET request
 *
 *  @param url url
 *  @param params params
 *  @param success success block
 *  @param failure failure block
 */
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *operation, id responseObj))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  send POST request
 *
 *  @param url url
 *  @param params params
 *  @param success success block
 *  @param failure failure block
 */
+ (void)post:(NSString *)url params:(NSDictionary *)params xmlString:(NSString *) xmlString success:(void (^)(AFHTTPRequestOperation *operation, id responseObj))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  send POST request
 *  url需要带上ip地址
 *  @param url url
 *  @param params params
 *  @param success success block
 *  @param failure failure block
 */
+ (void)postWithIp:(NSString *)url params:(NSDictionary *)params  xmlString:(NSString *) xmlString success:(void (^)(AFHTTPRequestOperation *operation, id responseObj))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 一个长的数据请求

 @param time 时间
 @param url 地址
 @param params 参数
 @param xmlString 参数
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)longPostTimeOutInterval:(NSInteger)time url:(NSString *)url params:(NSDictionary *)params  xmlString:(NSString *) xmlString success:(void (^)(AFHTTPRequestOperation *operation, id responseObj))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 *  login
 *
 *  @param username username
 *  @param password psw
 *  @param success success block
 *  @param failure failure block
 */
+ (void)loginWithUsername:(NSString *)username password:(NSString *)password success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

@end
