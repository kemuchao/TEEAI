//
//  NIHttpUtil.m
//  MifiApp
//
//  Created by yueguangkai on 15/11/4.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import "NIHttpUtil.h"
#import "NSString+Extension.h"
#import "NICommonUtil.h"
#import "NIWifiTool.h"
#import "NIStatus1Model.h"
#import "LanguageModel.h"

#define MIFI_GN_COUNT 1
#define MIFI_AUTH_COUNT_PREX @"00000000"

#pragma Mark realm nonce qop param use by get Authorization header
NSString *gRealm = @"Highwmg";
NSString *gNonce = @"1000";
NSString *gQop = @"auth";

@implementation NIHttpUtil

#pragma mark ********** send get function  *********
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *operation, id responseObj))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NILog(@"get %@ ", url);
    NSString *ip = [NSString stringWithFormat:@"http://%@",[NIWifiTool getRouterIp]];;
    url = [NSString stringWithFormat:@"%@%@",ip,url];
    //step 1 get httpOperation
    AFHTTPRequestOperationManager *httpOperation = [self getAFHTTPRequestOperationManager];;
    //step 2 get auth header string, username and password user for mifi, admin is default
    NSString *username = [NIUerInfoAndCommonSave getValueFromKey:ADMIN_NAME];
    NSString *password = [NIUerInfoAndCommonSave getValueFromKey:ADMIN_PSW];
    NSString *authHeaderStr = [self authHeaderWithRequestType:@"GET" path:@"/cgi/xml_action.cgi" username:username password:password isLogin:NO];
    //step 3 set request header
    [httpOperation.requestSerializer setValue:authHeaderStr forHTTPHeaderField:@"Authorization"];
    //step 4 send request
    [httpOperation GET:url parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObj) {
         if (success) {
             //step 5 callback function
             success(operation, responseObj);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (failure) {
             //step 5 callback function
             failure(operation, error);
         }
     }];
}

#pragma Mark ********** send post function  *********
+ (void)post:(NSString *)url params:(NSDictionary *)params  xmlString:(NSString *) xmlString success:(void (^)(AFHTTPRequestOperation *operation, id responseObj))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
{
    
    NSString *ip = [NSString stringWithFormat:@"http://%@",[NIWifiTool getRouterIp]];;
    url = [NSString stringWithFormat:@"%@%@",ip,url];
    NSLog(@" %@ ", url);
    //step 1 get httpOperation
    AFHTTPRequestOperationManager *mgr = [self getAFHTTPRequestOperationManager];
    //step 2 get auth header string, username and password user for mifi, admin is default
    NSString *username = [NIUerInfoAndCommonSave getValueFromKey:ADMIN_NAME];
    NSString *password = [NIUerInfoAndCommonSave getValueFromKey:ADMIN_PSW];
    NSString *authHeaderStr = [self authHeaderWithRequestType:@"POST" path:@"/cgi/xml_action.cgi" username:username password:password isLogin:NO];
    if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
        authHeaderStr = [self getCPEAuthHeaderWithType:@"POST"];
        NSString *cookie = [NIUerInfoAndCommonSave getValueFromKey:Cookie];
        [mgr.requestSerializer setValue:cookie forHTTPHeaderField:@"Cookie"];
    }
    //step 3 set request header
    [mgr.requestSerializer setValue:authHeaderStr forHTTPHeaderField:@"Authorization"];
    //step 4 send request
    NSLog(@"params = %@",params);
    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (xmlString != nil) {
            NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            //step 5 send application/octet-stream request
            [formData appendPartWithFileData:[xmlString dataUsingEncoding:gbkEncoding] name:@"data" fileName:@"null" mimeType:@"application/octet-stream"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            //step 6 callback function
            success(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            //step 6 callback function
            failure(operation, error);
        }
    }];
}

#pragma Mark ********** send post function  *********
+ (void)postWithIp:(NSString *)url params:(NSDictionary *)params  xmlString:(NSString *) xmlString success:(void (^)(AFHTTPRequestOperation *operation, id responseObj))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
{
    NILog(@"get %@ ", url);

    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.securityPolicy = [AFSecurityPolicy defaultPolicy]; //安全相关
    mgr.reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    mgr.operationQueue = [[NSOperationQueue alloc] init];//初始化一个操作队列 在执行post，get等方法时会将生成的request添加到这个队列
    mgr.shouldUseCredentialStorage = YES;
    
    [mgr POST:url parameters:params
          success:^(AFHTTPRequestOperation *operation,id responseObject) {
              if (success) {
                  //step 6 callback function
                  success(operation, responseObject);
              }
              
          }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
              
              if (failure) {
                  //step 6 callback function
                  failure(operation, error);
              }
              
          }];
}

#pragma Mark ********** 一个长的数据请求  *********
+ (void)longPostTimeOutInterval:(NSInteger)time url:(NSString *)url params:(NSDictionary *)params  xmlString:(NSString *) xmlString success:(void (^)(AFHTTPRequestOperation *operation, id responseObj))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
{
    NILog(@"get %@ ", url);
    NSString *ip = [NSString stringWithFormat:@"http://%@",[NIWifiTool getRouterIp]];;
    url = [NSString stringWithFormat:@"%@%@",ip,url];
    //step 1 get httpOperation
    AFHTTPRequestOperationManager *mgr = [self getAFHTTPRequestOperationManager];
    mgr.requestSerializer.timeoutInterval = time;
    //step 2 get auth header string, username and password user for mifi, admin is default
    NSString *username = [NIUerInfoAndCommonSave getValueFromKey:ADMIN_NAME];
    NSString *password = [NIUerInfoAndCommonSave getValueFromKey:ADMIN_PSW];
    NSString *authHeaderStr = [self authHeaderWithRequestType:@"POST" path:@"/cgi/xml_action.cgi" username:username password:password isLogin:NO];
    //step 3 set request header
    [mgr.requestSerializer setValue:authHeaderStr forHTTPHeaderField:@"Authorization"];
    //step 4 send request
    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (xmlString != nil) {
            NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            //step 5 send application/octet-stream request
            [formData appendPartWithFileData:[xmlString dataUsingEncoding:gbkEncoding] name:@"data" fileName:@"null" mimeType:@"application/octet-stream"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            //step 6 callback function
            success(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            //step 6 callback function
            failure(operation, error);
        }
    }];
}


#pragma Mark ********** login function  *********
+ (void)loginWithUsername:(NSString *)username password:(NSString *)password success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
//    NILog(@"username = %@,password = %@", username, password);
    NSString *ip = [NIWifiTool getRouterIp];
    NSString *url = [NSString stringWithFormat:@"http://%@/xml_action.cgi?method=get&module=duster&file=locale",ip];
    if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
        url = [NSString stringWithFormat:@"http://%@/login.cgi",ip];;
    }
    NILog(@"%@", url);
    //step 1 get httpOperation
    AFHTTPRequestOperationManager *httpOperation = [self getAFHTTPRequestOperationManager];
    //step 2 send get login.cgi request
    [httpOperation GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //step 3 get response header get realm nonce qop data and save it
        NSHTTPURLResponse *response = operation.response;
        NSDictionary *headersDict = response.allHeaderFields;
        NSString *authenticate = [headersDict valueForKey:@"WWW-Authenticate"];
        NSArray *authArray = [authenticate componentsSeparatedByString:@" "];
        if ([authArray[0] isEqualToString:@"Digest"]) {
            gRealm = [self getAuthValueWithAuthString:authArray[1]];
            gNonce = [self getAuthValueWithAuthString:authArray[2]];
            gQop = [self getAuthValueWithAuthString:authArray[3]];
            NILog(@"%@%@%@", gRealm, gNonce, gQop);
        }

        NSMutableString *loginUrl = [[NSMutableString alloc]init];
        //step 4 get request url
        NSString *authLoginStr = [self authHeaderWithRequestType:@"GET" path:@"/cgi/protected.cgi" username:username password:password isLogin:YES];
        if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
            authLoginStr = [self authHeaderWithRequestType:@"GET" path:@"/cgi/xml_action.cgi" username:username password:password isLogin:YES];
        }
        [loginUrl appendString:[NSString stringWithFormat:@"http://%@",[NIWifiTool getRouterIp]]];
        [loginUrl appendString:@"/login.cgi?Action="];
        [loginUrl appendString:authLoginStr];
        NILog(@"loginUrl = %@", loginUrl);

        //step 5 get request Authorization string
        NSString *authHeaderStr = [self authHeaderWithRequestType:@"GET" path:@"/cgi/xml_action.cgi" username:username password:password isLogin:NO];
        [httpOperation.requestSerializer setValue:authHeaderStr forHTTPHeaderField:@"Authorization"];

        //step 6 send request login
        [httpOperation GET:loginUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NILog(@"login response = %@",operation.responseString);
            NSDictionary *fileds = [operation.response allHeaderFields];
            NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:fileds forURL:[NSURL URLWithString:url]];
            NSDictionary *requestFields = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
            NSString *cookie = [requestFields objectForKey:@"Cookie"];
            [NIUerInfoAndCommonSave saveValue:cookie key:Cookie];
            
            LanguageModel *languageModel = [LanguageModel initWithResponseXmlString:operation.responseString];
            if (success) {
                success(operation);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+(NSString *) getAuthValueWithAuthString:(NSString *)authString
{
    NSArray *array = [authString componentsSeparatedByString:@"="];
    NSString *tempStr = [array[1] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *tempStr1 = [tempStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"," withString:@""];
    return tempStr2;
}

+(AFHTTPRequestOperationManager *) getAFHTTPRequestOperationManager
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.requestSerializer.timeoutInterval = 10;
    [mgr.requestSerializer setValue:@"-1" forHTTPHeaderField:@"Expires"];
    [mgr.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    [mgr.requestSerializer setValue:@"zh-CN" forHTTPHeaderField:@"Accept-Language"];
    [mgr.requestSerializer setValue:@"platform=mifi" forHTTPHeaderField:@"Cookie"];
    [mgr.requestSerializer setValue:[NIWifiTool getRouterIp] forHTTPHeaderField:@"Peferer"];
    [mgr.requestSerializer setValue:@"no-cache" forHTTPHeaderField:@"Pragma"];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    return mgr;
}


+(NSString *) authHeaderWithRequestType:(NSString *) type path:(NSString *)path username:(NSString *)username password:(NSString *)password isLogin:(BOOL) isLogin{
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSString *HA1 = [[NSString stringWithFormat:@"%@:%@:%@",username,gRealm,password] md5];
    NSString *HA2 = [[NSString stringWithFormat:@"%@:%@",type, path] md5];
    int rand = arc4random() % 100001;
    long date = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *tmp = [[NSString stringWithFormat:@"%d%li",rand, date] md5];
    NSString *AuthCnonce_f = [tmp substringWithRange:NSMakeRange(0, 16)];
    NSString *tmpAuthcount = [NSString stringWithFormat:@"%@%d",MIFI_AUTH_COUNT_PREX, MIFI_GN_COUNT];
    NSString *Authcount = [tmpAuthcount substringWithRange:NSMakeRange(tmpAuthcount.length - 8, 8)];
    NSString *DigestRes = [[NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",HA1,gNonce,Authcount,AuthCnonce_f,gQop,HA2] md5];
    
    [resultString appendString:@"Digest"];
    if (isLogin) {
        [resultString appendString:@"&"];
        [resultString appendFormat:@"username=%@&", username];
        [resultString appendFormat:@"realm=%@&",gRealm];
        [resultString appendFormat:@"nonce=%@&",gNonce];
        [resultString appendFormat:@"response=%@&",DigestRes];
        [resultString appendFormat:@"qop=%@&",gQop];
        [resultString appendFormat:@"cnonce=%@",AuthCnonce_f];
        if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
            [resultString appendFormat:@"&nc=%@",Authcount];
        }
        [resultString appendString:@"&temp=marvell"];
    } else {
        [resultString appendString:@" "];
        [resultString appendFormat:@"username=\"%@\", ", username];
        [resultString appendFormat:@"realm=\"%@\", ",gRealm];
        [resultString appendFormat:@"nonce=\"%@\", ",gNonce];
        [resultString appendFormat:@"uri=\"%@\", ",@"/cgi/xml_action.cgi"];
        [resultString appendFormat:@"response=\"%@\", ",DigestRes];
        [resultString appendFormat:@"qop=%@, ",gQop];
        [resultString appendFormat:@"nc=%@, ", Authcount];
        [resultString appendFormat:@"cnonce=\"%@\"",AuthCnonce_f];
    }
    return resultString;
}

+ (NSString *)getCPEAuthHeaderWithType:(NSString *)type{
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSString *username = [NIUerInfoAndCommonSave getValueFromKey:ADMIN_NAME];
    NSString *password = [NIUerInfoAndCommonSave getValueFromKey:ADMIN_PSW];
    NSString *path = @"/cgi/xml_action.cgi";
    NSString *HA1 = [[NSString stringWithFormat:@"%@:%@:%@",username,gRealm,password] md5];
    NSString *HA2 = [[NSString stringWithFormat:@"%@:%@",type, path] md5];
    int rand = arc4random() % 100001;
    long date = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *tmp = [[NSString stringWithFormat:@"%d%li",rand, date] md5];
    NSString *AuthCnonce_f = [tmp substringWithRange:NSMakeRange(0, 16)];
    NSString *tmpAuthcount = [NSString stringWithFormat:@"%@%d",MIFI_AUTH_COUNT_PREX, MIFI_GN_COUNT];
    NSString *Authcount = [tmpAuthcount substringWithRange:NSMakeRange(tmpAuthcount.length - 8, 8)];
    NSString *DigestRes = [[NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",HA1,gNonce,Authcount,AuthCnonce_f,gQop,HA2] md5];
    
    [resultString appendString:@"Digest"];
    [resultString appendString:@" "];
    [resultString appendFormat:@"username=\"%@\", ", username];
    [resultString appendFormat:@"realm=\"%@\", ",gRealm];
    [resultString appendFormat:@"nonce=\"%@\", ",gNonce];
    [resultString appendFormat:@"uri=\"%@\", ",@"/cgi/xml_action.cgi"];
    [resultString appendFormat:@"response=\"%@\", ",DigestRes];
    [resultString appendFormat:@"qop=%@, ",gQop];
    [resultString appendFormat:@"nc=%@, ", Authcount];
    [resultString appendFormat:@"cnonce=\"%@\"",AuthCnonce_f];
    return resultString;
}

@end
