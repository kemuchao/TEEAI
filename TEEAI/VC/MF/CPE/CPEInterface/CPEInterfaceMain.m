//
//  CPEInterfaceMain.m
//  MifiManager
//
//  Created by notion on 2018/6/26.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "CPEInterfaceMain.h"
#import "CPERequestXML.h"
#import "CPEResultCommonData.h"
#define MIFI_GN_COUNT 1
#define MIFI_AUTH_COUNT_PREX @"00000000"
#pragma Mark realm nonce qop param use by get Authorization header
@interface CPEInterfaceMain()

@end
NSString *CPEgRealm = @"Highwmg";
NSString *CPEgNonce = @"1000";
NSString *CPEgQop = @"auth";
@implementation CPEInterfaceMain
/**
 通用上传操作
 
 @param requestXML 请求参数
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)uploadCommonWithRequestXML:(NSString *)requestXML Success:(void (^)(CPEResultCommonData *status))success failure:(void (^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause{
    NSString *ip = [NSString stringWithFormat:@"http://%@",[NIWifiTool getRouterIp]];;
    NSString *url = [NSString stringWithFormat:@"%@%@",ip,CPE_REQUEST_COMMON];
    AFHTTPRequestOperationManager *mgr = [self getAFHTTPRequestOperationManager];
    NSString *authHeaderStr = [self getCPEAuthHeaderWithType:@"POST"];
    [mgr.requestSerializer setValue:authHeaderStr forHTTPHeaderField:@"Authorization"];
    [mgr POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (requestXML != nil) {
            NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            //step 5 send application/octet-stream request
            [formData appendPartWithFileData:[requestXML dataUsingEncoding:gbkEncoding] name:@"data" fileName:@"null" mimeType:@"application/octet-stream"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            LanguageModel *model = [LanguageModel initWithResponseXmlString:operation.responseString];
            if (model.errorCause) {
                errorCause(model.errorCause);
            }else{
                CPEResultCommonData *resultData = [CPEResultCommonData initWithResponseXmlString:operation.responseString];
                success(resultData);
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            //step 6 callback function
            failure(error);
        }
    }];
}
/**
 通用上传操作
 
 @param requestXML 请求参数
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)uploadCommonModelWithRequestXML:(NSString *)requestXML Success:(void (^)(CPEResultCommonData *resultDB))success failure:(void (^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause{
    NSString *ip = [NSString stringWithFormat:@"http://%@",[NIWifiTool getRouterIp]];;
    NSString *url = [NSString stringWithFormat:@"%@%@",ip,CPE_REQUEST_COMMON];
    AFHTTPRequestOperationManager *mgr = [self getAFHTTPRequestOperationManager];
    NSString *authHeaderStr = [self getCPEAuthHeaderWithType:@"POST"];
    [mgr.requestSerializer setValue:authHeaderStr forHTTPHeaderField:@"Authorization"];
    [mgr POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (requestXML != nil) {
            NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            //step 5 send application/octet-stream request
            [formData appendPartWithFileData:[requestXML dataUsingEncoding:gbkEncoding] name:@"data" fileName:@"null" mimeType:@"application/octet-stream"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            LanguageModel *model = [LanguageModel initWithResponseXmlString:operation.responseString];
            if (model.errorCause) {
                errorCause(model.errorCause);
            }else{
                CPEResultCommonData *resultData = [CPEResultCommonData initWithResponseXmlString:operation.responseString];
                success(resultData);
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            //step 6 callback function
            failure(error);
        }
    }];
}

+ (void)getWifiDetailSuccess:(void (^)(CPEWiFiDetail *wifiInfo))success failure:(void (^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause{
    NSString *xmlString = [CPERequestXML getXMLWithPath:@"wireless" method:@"wifi_get_detail" addXML:nil];
    NSString *ip = [NSString stringWithFormat:@"http://%@",[NIWifiTool getRouterIp]];;
    NSString *url = [NSString stringWithFormat:@"%@%@",ip,CPE_REQUEST_COMMON];
    AFHTTPRequestOperationManager *mgr = [self getAFHTTPRequestOperationManager];
    NSString *authHeaderStr = [self getCPEAuthHeaderWithType:@"POST"];
    [mgr.requestSerializer setValue:authHeaderStr forHTTPHeaderField:@"Authorization"];
    [mgr POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (xmlString != nil) {
            NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            //step 5 send application/octet-stream request
            [formData appendPartWithFileData:[xmlString dataUsingEncoding:gbkEncoding] name:@"data" fileName:@"null" mimeType:@"application/octet-stream"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            LanguageModel *model = [LanguageModel initWithResponseXmlString:operation.responseString];
            if (model.errorCause) {
                errorCause(model.errorCause);
            }else{
                CPEWiFiDetail *wifiDetail = [CPEWiFiDetail initWithResponseXmlString:operation.responseString];
                success(wifiDetail);
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            //step 6 callback function
            failure(error);
        }
    }];
}
/**
 获取当前SIM信息
 */
+ (void)getSimStatusSuccess:(void (^)(CPESimStatus *simStatus))success failure:(void (^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause{
    NSString *xmlString = [CPERequestXML getXMLWithPath:@"sim" method:@"get_sim_status" addXML:nil];
    NSString *ip = [NSString stringWithFormat:@"http://%@",[NIWifiTool getRouterIp]];;
    NSString *url = [NSString stringWithFormat:@"%@%@",ip,CPE_REQUEST_COMMON];
    AFHTTPRequestOperationManager *mgr = [self getAFHTTPRequestOperationManager];
    NSString *authHeaderStr = [self getCPEAuthHeaderWithType:@"POST"];
    [mgr.requestSerializer setValue:authHeaderStr forHTTPHeaderField:@"Authorization"];
    [mgr POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (xmlString != nil) {
            NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            //step 5 send application/octet-stream request
            [formData appendPartWithFileData:[xmlString dataUsingEncoding:gbkEncoding] name:@"data" fileName:@"null" mimeType:@"application/octet-stream"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            LanguageModel *model = [LanguageModel initWithResponseXmlString:operation.responseString];
            if (model.errorCause) {
                errorCause(model.errorCause);
            }else{
                CPESimStatus *simStatus = [CPESimStatus initWithResponseXmlString:operation.responseString];
                success(simStatus);
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            //step 6 callback function
            failure(error);
        }
    }];
}

/**
 获取网络运营
 */
+ (void)getNetWorkListSuccess:(void(^)(CPENetworkModel *networkListModel))success failure:(void(^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause{
    NSString *xmlString = [CPERequestXML getXMLWithPath:@"util_wan" method:@"search_network" addXML:nil];
    NSString *ip = [NSString stringWithFormat:@"http://%@",[NIWifiTool getRouterIp]];
    NSString *url = [NSString stringWithFormat:@"%@%@",ip,CPE_REQUEST_COMMON];
    AFHTTPRequestOperationManager *mgr = [self getAFHTTPRequestOperationManager];
    mgr.requestSerializer.timeoutInterval = 120;
    NSString *authHeaderStr = [self getCPEAuthHeaderWithType:@"POST"];
    [mgr.requestSerializer setValue:authHeaderStr forHTTPHeaderField:@"Authorization"];
    [mgr POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (xmlString != nil) {
            NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            //step 5 send application/octet-stream request
            [formData appendPartWithFileData:[xmlString dataUsingEncoding:gbkEncoding] name:@"data" fileName:@"null" mimeType:@"application/octet-stream"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            LanguageModel *model = [LanguageModel initWithResponseXmlString:operation.responseString];
            if (model.errorCause) {
                errorCause(model.errorCause);
            }else{
                CPENetworkModel *networkModel = [CPENetworkModel initWithResponseXmlString:operation.responseString];
                if (networkModel.response) {
                    errorCause(networkModel.response);
                }else{
                    success(networkModel);
                }
                
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            //step 6 callback function
            failure(error);
        }
    }];
}

+ (void)getConnectDevicesSuccess:(void (^)(NSArray *clients))success failure:(void (^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause{
    NSString *xmlString = [CPERequestXML getXMLWithPath:@"statistics" method:@"get_conn_clients_info" addXML:nil];
    NSString *ip = [NSString stringWithFormat:@"http://%@",[NIWifiTool getRouterIp]];;
    NSString *url = [NSString stringWithFormat:@"%@%@",ip,CPE_REQUEST_COMMON];
    AFHTTPRequestOperationManager *mgr = [self getAFHTTPRequestOperationManager];
    NSString *authHeaderStr = [self getCPEAuthHeaderWithType:@"POST"];
    [mgr.requestSerializer setValue:authHeaderStr forHTTPHeaderField:@"Authorization"];
    [mgr POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (xmlString != nil) {
            NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            //step 5 send application/octet-stream request
            [formData appendPartWithFileData:[xmlString dataUsingEncoding:gbkEncoding] name:@"data" fileName:@"null" mimeType:@"application/octet-stream"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            LanguageModel *model = [LanguageModel initWithResponseXmlString:operation.responseString];
            if (model.errorCause) {
                errorCause(model.errorCause);
            }else{
                CPEConnectClients *clientsModel = [CPEConnectClients initWithResponseXmlString:operation.responseString];
                success(clientsModel.clientsArray);
            }
            
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            //step 6 callback function
            failure(error);
        }
    }];
}
+ (void)getAllDevicesSuccess:(void (^)(NSArray *clients))success failure:(void (^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause{
    NSString *xmlString = [CPERequestXML getXMLWithPath:@"statistics" method:@"get_all_clients_info" addXML:nil];
    NSString *ip = [NSString stringWithFormat:@"http://%@",[NIWifiTool getRouterIp]];;
    NSString *url = [NSString stringWithFormat:@"%@%@",ip,CPE_REQUEST_COMMON];
    AFHTTPRequestOperationManager *mgr = [self getAFHTTPRequestOperationManager];
    NSString *authHeaderStr = [self getCPEAuthHeaderWithType:@"POST"];
    [mgr.requestSerializer setValue:authHeaderStr forHTTPHeaderField:@"Authorization"];
    [mgr POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (xmlString != nil) {
            NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            //step 5 send application/octet-stream request
            [formData appendPartWithFileData:[xmlString dataUsingEncoding:gbkEncoding] name:@"data" fileName:@"null" mimeType:@"application/octet-stream"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            LanguageModel *model = [LanguageModel initWithResponseXmlString:operation.responseString];
            if (model.errorCause) {
                errorCause(model.errorCause);
            }else{
                CPEAllClients *clientsModel = [CPEAllClients initWithResponseXmlString:operation.responseString];
                success(clientsModel.clientsArray);
            }
            
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            //step 6 callback function
            failure(error);
        }
    }];
}
+ (void)uploadBlockWithRequestXML:(NSString *)requestXML Success:(void (^)(NSString *status))success failure:(void (^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause{
    
    NSString *ip = [NSString stringWithFormat:@"http://%@",[NIWifiTool getRouterIp]];;
    NSString *url = [NSString stringWithFormat:@"%@%@",ip,CPE_REQUEST_COMMON];
    AFHTTPRequestOperationManager *mgr = [self getAFHTTPRequestOperationManager];
    NSString *authHeaderStr = [self getCPEAuthHeaderWithType:@"POST"];
    [mgr.requestSerializer setValue:authHeaderStr forHTTPHeaderField:@"Authorization"];
    [mgr POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (requestXML != nil) {
            NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            //step 5 send application/octet-stream request
            [formData appendPartWithFileData:[requestXML dataUsingEncoding:gbkEncoding] name:@"data" fileName:@"null" mimeType:@"application/octet-stream"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            LanguageModel *model = [LanguageModel initWithResponseXmlString:operation.responseString];
            if (model.errorCause) {
                errorCause(model.errorCause);
            }else{
                CPEResultCommonData *resultData = [CPEResultCommonData initWithResponseXmlString:operation.responseString];
                success(resultData.status);
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            //step 6 callback function
            failure(error);
        }
    }];
    
}

#pragma Mark ********** login function  *********
+ (void)loginWithUsername:(NSString *)username password:(NSString *)password success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    NSString *ip = [NIWifiTool getRouterIp];
    NSString *url =  [NSString stringWithFormat:@"http://%@/login.cgi",ip];
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
            CPEgRealm = [self getAuthValueWithAuthString:authArray[1]];
            CPEgNonce = [self getAuthValueWithAuthString:authArray[2]];
            CPEgQop = [self getAuthValueWithAuthString:authArray[3]];
            NILog(@"%@%@%@", CPEgRealm, CPEgNonce, CPEgQop);
        }
        
        NSMutableString *loginUrl = [[NSMutableString alloc]init];
        //step 4 get request url
        NSString *authLoginStr = [self authHeaderWithRequestType:@"GET" path:@"/cgi/xml_action.cgi" username:username password:password isLogin:YES];
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
            
            
            if (success) {
                LanguageModel *languageModel = [LanguageModel initWithResponseXmlString:operation.responseString];
                if (languageModel.errorCause) {
                    
                }else{
                     success(operation);
                }
               
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

#pragma Mark ********** send post function  *********
+ (void)post:(NSString *)url params:(NSDictionary *)params  xmlString:(NSString *) xmlString success:(void (^)(AFHTTPRequestOperation *operation, id responseObj))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
{
    NILog(@"get %@ ", url);
    NSString *ip = [NSString stringWithFormat:@"http://%@",[NIWifiTool getRouterIp]];;
    url = [NSString stringWithFormat:@"%@%@",ip,url];
    AFHTTPRequestOperationManager *mgr = [self getAFHTTPRequestOperationManager];
    NSString *authHeaderStr = [self getCPEAuthHeaderWithType:@"POST"];
    [mgr.requestSerializer setValue:authHeaderStr forHTTPHeaderField:@"Authorization"];
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
/**
 获取流量套餐设置
 */
+ (void)getCPEContextSuccess:(void(^)(CPEStatisticsStatSetting *wanStat))success failure:(void(^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause{
    NSString *xmlString = [CPERequestXML getXMLWithPath:@"bolt_request" method:@"bolt_get_eng_info_end" addXML:nil];
    NSString *ip = [NSString stringWithFormat:@"http://%@",[NIWifiTool getRouterIp]];;
    NSString *url = [NSString stringWithFormat:@"%@%@",ip,CPE_REQUEST_COMMON];
    AFHTTPRequestOperationManager *mgr = [self getAFHTTPRequestOperationManager];
    NSString *authHeaderStr = [self getCPEAuthHeaderWithType:@"POST"];
    [mgr.requestSerializer setValue:authHeaderStr forHTTPHeaderField:@"Authorization"];
    [mgr POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (xmlString != nil) {
            NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            //step 5 send application/octet-stream request
            [formData appendPartWithFileData:[xmlString dataUsingEncoding:gbkEncoding] name:@"data" fileName:@"null" mimeType:@"application/octet-stream"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            LanguageModel *model = [LanguageModel initWithResponseXmlString:operation.responseString];
            if (model.errorCause) {
                errorCause(model.errorCause);
            }else{
                CPEStatisticsStatSetting *wanSetting = [CPEStatisticsStatSetting initWithResponseXmlString:operation.responseString];
                success(wanSetting);
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            //step 6 callback function
            failure(error);
        }
    }];
}
/**
 获取eng
 */
+ (void)getCPEENGStartSuccess:(void(^)(CPEStatisticsStatSetting *wanStat))success failure:(void(^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause{
    NSString *xmlString = [CPERequestXML getXMLWithPath:@"bolt_request" method:@"bolt_get_context" addXML:nil];
    NSString *ip = [NSString stringWithFormat:@"http://%@",[NIWifiTool getRouterIp]];;
    NSString *url = [NSString stringWithFormat:@"%@%@",ip,CPE_REQUEST_COMMON];
    AFHTTPRequestOperationManager *mgr = [self getAFHTTPRequestOperationManager];
    NSString *authHeaderStr = [self getCPEAuthHeaderWithType:@"POST"];
    [mgr.requestSerializer setValue:authHeaderStr forHTTPHeaderField:@"Authorization"];
    [mgr POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (xmlString != nil) {
            NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            //step 5 send application/octet-stream request
            [formData appendPartWithFileData:[xmlString dataUsingEncoding:gbkEncoding] name:@"data" fileName:@"null" mimeType:@"application/octet-stream"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            LanguageModel *model = [LanguageModel initWithResponseXmlString:operation.responseString];
            if (model.errorCause) {
                errorCause(model.errorCause);
            }else{
                CPEStatisticsStatSetting *wanSetting = [CPEStatisticsStatSetting initWithResponseXmlString:operation.responseString];
                success(wanSetting);
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            //step 6 callback function
            failure(error);
        }
    }];
}
/**
 获取流量套餐设置
 */
+ (void)getWanStatisticsSuccess:(void(^)(CPEStatisticsStatSetting *wanStat))success failure:(void(^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause{
    NSString *xmlString = [CPERequestXML getXMLWithPath:@"statistics" method:@"stat_get_settings" addXML:nil];
    NSString *ip = [NSString stringWithFormat:@"http://%@",[NIWifiTool getRouterIp]];;
    NSString *url = [NSString stringWithFormat:@"%@%@",ip,CPE_REQUEST_COMMON];
    AFHTTPRequestOperationManager *mgr = [self getAFHTTPRequestOperationManager];
    NSString *authHeaderStr = [self getCPEAuthHeaderWithType:@"POST"];
    [mgr.requestSerializer setValue:authHeaderStr forHTTPHeaderField:@"Authorization"];
    [mgr POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (xmlString != nil) {
            NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            //step 5 send application/octet-stream request
            [formData appendPartWithFileData:[xmlString dataUsingEncoding:gbkEncoding] name:@"data" fileName:@"null" mimeType:@"application/octet-stream"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            LanguageModel *model = [LanguageModel initWithResponseXmlString:operation.responseString];
            if (model.errorCause) {
                errorCause(model.errorCause);
            }else{
                CPEStatisticsStatSetting *wanSetting = [CPEStatisticsStatSetting initWithResponseXmlString:operation.responseString];
                success(wanSetting);
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            //step 6 callback function
            failure(error);
        }
    }];
}
/**
 获取月套餐设置已用流量
 */
+ (void)getWanCurMonthSuccess:(void(^)(CPEStatCurMon *monStat))success failure:(void(^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause{
    NSString *xmlString = [CPERequestXML getXMLWithPath:@"statistics" method:@"stat_get_cur_value" addXML:nil];
    NSString *ip = [NSString stringWithFormat:@"http://%@",[NIWifiTool getRouterIp]];;
    NSString *url = [NSString stringWithFormat:@"%@%@",ip,CPE_REQUEST_COMMON];
    AFHTTPRequestOperationManager *mgr = [self getAFHTTPRequestOperationManager];
    NSString *authHeaderStr = [self getCPEAuthHeaderWithType:@"POST"];
    [mgr.requestSerializer setValue:authHeaderStr forHTTPHeaderField:@"Authorization"];
    [mgr POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (xmlString != nil) {
            NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            //step 5 send application/octet-stream request
            [formData appendPartWithFileData:[xmlString dataUsingEncoding:gbkEncoding] name:@"data" fileName:@"null" mimeType:@"application/octet-stream"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            LanguageModel *model = [LanguageModel initWithResponseXmlString:operation.responseString];
            if (model.errorCause) {
                errorCause(model.errorCause);
            }else{
                CPEStatCurMon *monStat = [CPEStatCurMon initWithResponseXmlString:operation.responseString];
                success(monStat);
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            //step 6 callback function
            failure(error);
        }
    }];
}
/**
 获取当前优选模式
 */
+ (void)getNetModeSuccess:(void(^)(CPENetMode *netMode))success failure:(void(^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause{
    NSString *xmlString = [CPERequestXML getXMLWithPath:@"util_wan" method:@"get_network_mode" addXML:nil];
    NSString *ip = [NSString stringWithFormat:@"http://%@",[NIWifiTool getRouterIp]];;
    NSString *url = [NSString stringWithFormat:@"%@%@",ip,CPE_REQUEST_COMMON];
    AFHTTPRequestOperationManager *mgr = [self getAFHTTPRequestOperationManager];
    NSString *authHeaderStr = [self getCPEAuthHeaderWithType:@"POST"];
    [mgr.requestSerializer setValue:authHeaderStr forHTTPHeaderField:@"Authorization"];
    [mgr POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (xmlString != nil) {
            NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            //step 5 send application/octet-stream request
            [formData appendPartWithFileData:[xmlString dataUsingEncoding:gbkEncoding] name:@"data" fileName:@"null" mimeType:@"application/octet-stream"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            LanguageModel *model = [LanguageModel initWithResponseXmlString:operation.responseString];
            if (model.errorCause) {
                errorCause(model.errorCause);
            }else{
                CPENetMode *netMode = [CPENetMode initWithResponseXmlString:operation.responseString];
                success(netMode);
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            //step 6 callback function
            failure(error);
        }
    }];
}
/**
 获取是否漫游
 */
+ (void)getWanSwitchSuccess:(void(^)(CPEWanSwitch *wanSwitch))success failure:(void(^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause{
    NSString *xmlString = [CPERequestXML getXMLWithPath:@"cm" method:@"get_running_switch" addXML:nil];
    NSString *ip = [NSString stringWithFormat:@"http://%@",[NIWifiTool getRouterIp]];;
    NSString *url = [NSString stringWithFormat:@"%@%@",ip,CPE_REQUEST_COMMON];
    AFHTTPRequestOperationManager *mgr = [self getAFHTTPRequestOperationManager];
    NSString *authHeaderStr = [self getCPEAuthHeaderWithType:@"POST"];
    [mgr.requestSerializer setValue:authHeaderStr forHTTPHeaderField:@"Authorization"];
    [mgr POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (xmlString != nil) {
            NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            //step 5 send application/octet-stream request
            [formData appendPartWithFileData:[xmlString dataUsingEncoding:gbkEncoding] name:@"data" fileName:@"null" mimeType:@"application/octet-stream"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            LanguageModel *model = [LanguageModel initWithResponseXmlString:operation.responseString];
            if (model.errorCause) {
                errorCause(model.errorCause);
            }else{
                CPEWanSwitch *wanSwitch = [CPEWanSwitch initWithResponseXmlString:operation.responseString];
                success(wanSwitch);
            }
           
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            //step 6 callback function
            failure(error);
        }
    }];
}
/**
 获取当前流量
 */
+ (void)getCommonDataSuccess:(void(^)(CPEStatisticsCommonData *commonData))success failure:(void(^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause{
    NSString *xmlString = [CPERequestXML getXMLWithPath:@"statistics" method:@"stat_get_common_data" addXML:nil];
    NSString *ip = [NSString stringWithFormat:@"http://%@",[NIWifiTool getRouterIp]];;
    NSString *url = [NSString stringWithFormat:@"%@%@",ip,CPE_REQUEST_COMMON];
    AFHTTPRequestOperationManager *mgr = [self getAFHTTPRequestOperationManager];
    NSString *authHeaderStr = [self getCPEAuthHeaderWithType:@"POST"];
    [mgr.requestSerializer setValue:authHeaderStr forHTTPHeaderField:@"Authorization"];
    [mgr POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (xmlString != nil) {
            NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            //step 5 send application/octet-stream request
            [formData appendPartWithFileData:[xmlString dataUsingEncoding:gbkEncoding] name:@"data" fileName:@"null" mimeType:@"application/octet-stream"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            LanguageModel *model = [LanguageModel initWithResponseXmlString:operation.responseString];
            if (model.errorCause) {
                errorCause(model.errorCause);
            }else{
                CPEStatisticsCommonData *commonData = [CPEStatisticsCommonData initWithResponseXmlString:operation.responseString];
                success(commonData);
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            //step 6 callback function
            failure(error);
        }
    }];
}
/**
 获取APN配置
 */
+ (void)getWanAPNConfigSuccess:(void(^)(CPEWanConfig *wanConfig))success failure:(void(^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause{
    NSString *xmlString = [CPERequestXML getXMLWithPath:@"cm" method:@"get_wan_configs" addXML:nil];
    NSString *ip = [NSString stringWithFormat:@"http://%@",[NIWifiTool getRouterIp]];;
    NSString *url = [NSString stringWithFormat:@"%@%@",ip,CPE_REQUEST_COMMON];
    AFHTTPRequestOperationManager *mgr = [self getAFHTTPRequestOperationManager];
    NSString *authHeaderStr = [self getCPEAuthHeaderWithType:@"POST"];
    [mgr.requestSerializer setValue:authHeaderStr forHTTPHeaderField:@"Authorization"];
    [mgr POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (xmlString != nil) {
            NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            //step 5 send application/octet-stream request
            [formData appendPartWithFileData:[xmlString dataUsingEncoding:gbkEncoding] name:@"data" fileName:@"null" mimeType:@"application/octet-stream"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            LanguageModel *model = [LanguageModel initWithResponseXmlString:operation.responseString];
            if (model.errorCause) {
                errorCause(model.errorCause);
            }else{
                CPEWanConfig *apnConfig = [CPEWanConfig initWithResponseXmlString:operation.responseString];
                success(apnConfig);
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            //step 6 callback function
            failure(error);
        }
    }];
}
/**
 获取短信未读
 */
+ (void)getUnreadMessageSuccess:(void(^)(CPEUnreadSMS *unreadMessage))success failure:(void(^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause{
    NSMutableString *request = [[NSMutableString alloc] initWithString:@"<sms_info>"];
    [request appendString:@"<sms><page_index>1</page_index><list_type>0</list_type></sms>"];
    [request appendString:@"</sms_info>"];
    NSString *xmlString = [CPERequestXML getXMLWithPath:@"sms" method:@"sms.list_by_type" addXML:request];
    NSString *ip = [NSString stringWithFormat:@"http://%@",[NIWifiTool getRouterIp]];;
    NSString *url = [NSString stringWithFormat:@"%@%@",ip,CPE_REQUEST_COMMON];
    AFHTTPRequestOperationManager *mgr = [self getAFHTTPRequestOperationManager];
    NSString *authHeaderStr = [self getCPEAuthHeaderWithType:@"POST"];
    [mgr.requestSerializer setValue:authHeaderStr forHTTPHeaderField:@"Authorization"];
    [mgr POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (xmlString != nil) {
            NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            //step 5 send application/octet-stream request
            [formData appendPartWithFileData:[xmlString dataUsingEncoding:gbkEncoding] name:@"data" fileName:@"null" mimeType:@"application/octet-stream"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            LanguageModel *model = [LanguageModel initWithResponseXmlString:operation.responseString];
            if (model.errorCause) {
                errorCause(model.errorCause);
            }else{
                CPEUnreadSMS *unreadModel = [CPEUnreadSMS initWithResponseXmlString:operation.responseString];
                success(unreadModel);
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            //step 6 callback function
            failure(error);
        }
    }];
}
/**
 获取短信信息，即标注为已读
 */
+ (void)getMessageModelBy:(NSInteger)messageID Success:(void(^)(CPESMSModel *message))success failure:(void(^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause{
    NSMutableString *request = [[NSMutableString alloc] initWithString:@"<sms_info>"];
    [request appendFormat:@"<sms><id>%d</id></sms>",(int)messageID];
    [request appendString:@"</sms_info>"];
    NSString *xmlString = [CPERequestXML getXMLWithPath:@"sms" method:@"sms.get_by_id" addXML:request];
    NSString *ip = [NSString stringWithFormat:@"http://%@",[NIWifiTool getRouterIp]];;
    NSString *url = [NSString stringWithFormat:@"%@%@",ip,CPE_REQUEST_COMMON];
    AFHTTPRequestOperationManager *mgr = [self getAFHTTPRequestOperationManager];
    NSString *authHeaderStr = [self getCPEAuthHeaderWithType:@"POST"];
    [mgr.requestSerializer setValue:authHeaderStr forHTTPHeaderField:@"Authorization"];
    [mgr POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (xmlString != nil) {
            NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            //step 5 send application/octet-stream request
            [formData appendPartWithFileData:[xmlString dataUsingEncoding:gbkEncoding] name:@"data" fileName:@"null" mimeType:@"application/octet-stream"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            LanguageModel *model = [LanguageModel initWithResponseXmlString:operation.responseString];
            if (model.errorCause) {
                errorCause(model.errorCause);
            }else{
                CPESMSModel *messageModel = [CPESMSModel initWithResponseXmlString:operation.responseString];
                success(messageModel);
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            //step 6 callback function
            failure(error);
        }
    }];
}
/**
 获取短信信息，即标注为已读
 */
+ (void)deleteMessageModelBy:(NSInteger)messageID Success:(void(^)(CPESMSModel *message))success failure:(void(^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause{
    NSMutableString *request = [[NSMutableString alloc] initWithString:@"<sms_info>"];
    [request appendFormat:@"<sms><id>%d</id></sms>",(int)messageID];
    [request appendString:@"</sms_info>"];
    NSString *xmlString = [CPERequestXML getXMLWithPath:@"sms" method:@"sms.delete" addXML:request];
    NSString *ip = [NSString stringWithFormat:@"http://%@",[NIWifiTool getRouterIp]];;
    NSString *url = [NSString stringWithFormat:@"%@%@",ip,CPE_REQUEST_COMMON];
    AFHTTPRequestOperationManager *mgr = [self getAFHTTPRequestOperationManager];
    NSString *authHeaderStr = [self getCPEAuthHeaderWithType:@"POST"];
    [mgr.requestSerializer setValue:authHeaderStr forHTTPHeaderField:@"Authorization"];
    [mgr POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (xmlString != nil) {
            NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            //step 5 send application/octet-stream request
            [formData appendPartWithFileData:[xmlString dataUsingEncoding:gbkEncoding] name:@"data" fileName:@"null" mimeType:@"application/octet-stream"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            LanguageModel *model = [LanguageModel initWithResponseXmlString:operation.responseString];
            if (model.errorCause) {
                errorCause(model.errorCause);
            }else{
                CPESMSModel *messageModel = [CPESMSModel initWithResponseXmlString:operation.responseString];
                success(messageModel);
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            //step 6 callback function
            failure(error);
        }
    }];
}
/**
 发送消息
 */
+ (void)uploadMessageWithXML:(NSString *)xmlString Success:(void(^)(CPESMSModel *message))success failure:(void(^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause{
//    NSMutableString *request = [[NSMutableString alloc] initWithString:@"<sms_info>"];
//    [request appendFormat:@"<sms><id>%d</id></sms>",(int)messageID];
//    [request appendString:@"</sms_info>"];
//    NSString *xmlString = [CPERequestXML getXMLWithPath:@"sms" method:@"sms.delete" addXML:request];
    NSString *ip = [NSString stringWithFormat:@"http://%@",[NIWifiTool getRouterIp]];;
    NSString *url = [NSString stringWithFormat:@"%@%@",ip,CPE_REQUEST_COMMON];
    AFHTTPRequestOperationManager *mgr = [self getAFHTTPRequestOperationManager];
    NSString *authHeaderStr = [self getCPEAuthHeaderWithType:@"POST"];
    [mgr.requestSerializer setValue:authHeaderStr forHTTPHeaderField:@"Authorization"];
    [mgr POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (xmlString != nil) {
            NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            //step 5 send application/octet-stream request
            [formData appendPartWithFileData:[xmlString dataUsingEncoding:gbkEncoding] name:@"data" fileName:@"null" mimeType:@"application/octet-stream"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            LanguageModel *model = [LanguageModel initWithResponseXmlString:operation.responseString];
            if (model.errorCause) {
                errorCause(model.errorCause);
            }else{
                CPESMSModel *messageModel = [CPESMSModel initWithResponseXmlString:operation.responseString];
                success(messageModel);
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            //step 6 callback function
            failure(error);
        }
    }];
}
/**
 发送消息
 */
+ (void)uploadUSSDWithXML:(NSString *)xmlString Success:(void(^)(CPEUSSDModel *ussd))success failure:(void(^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause{
    NSString *ip = [NSString stringWithFormat:@"http://%@",[NIWifiTool getRouterIp]];;
    NSString *url = [NSString stringWithFormat:@"%@%@",ip,CPE_REQUEST_COMMON];
    AFHTTPRequestOperationManager *mgr = [self getAFHTTPRequestOperationManager];
    NSString *authHeaderStr = [self getCPEAuthHeaderWithType:@"POST"];
    [mgr.requestSerializer setValue:authHeaderStr forHTTPHeaderField:@"Authorization"];
    [mgr POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (xmlString != nil) {
            NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            //step 5 send application/octet-stream request
            [formData appendPartWithFileData:[xmlString dataUsingEncoding:gbkEncoding] name:@"data" fileName:@"null" mimeType:@"application/octet-stream"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            LanguageModel *model = [LanguageModel initWithResponseXmlString:operation.responseString];
            if (model.errorCause) {
                errorCause(model.errorCause);
            }else{
                CPEUSSDModel *ussdModel = [CPEUSSDModel initWithResponseXmlString:operation.responseString];
                success(ussdModel);
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            //step 6 callback function
            failure(error);
        }
    }];
}
/**
 获取USSD
 */
+ (void)getUSSDSuccess:(void(^)(CPEUSSDModel *ussd))success failure:(void(^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause{
    NSMutableString *xmlString = [CPERequestXML getXMLWithPath:@"ussd" method:@"get_ussd_ind" addXML:nil];
    NSString *ip = [NSString stringWithFormat:@"http://%@",[NIWifiTool getRouterIp]];;
    NSString *url = [NSString stringWithFormat:@"%@%@",ip,CPE_REQUEST_COMMON];
    AFHTTPRequestOperationManager *mgr = [self getAFHTTPRequestOperationManager];
    NSString *authHeaderStr = [self getCPEAuthHeaderWithType:@"POST"];
    [mgr.requestSerializer setValue:authHeaderStr forHTTPHeaderField:@"Authorization"];
    [mgr POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (xmlString != nil) {
            NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            //step 5 send application/octet-stream request
            [formData appendPartWithFileData:[xmlString dataUsingEncoding:gbkEncoding] name:@"data" fileName:@"null" mimeType:@"application/octet-stream"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            LanguageModel *model = [LanguageModel initWithResponseXmlString:operation.responseString];
            if (model.errorCause) {
                errorCause(model.errorCause);
            }else{
                CPEUSSDModel *ussdModel = [CPEUSSDModel initWithResponseXmlString:operation.responseString];
                success(ussdModel);
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            //step 6 callback function
            failure(error);
        }
    }];
}


/**
 提交设备到云端
 */
+ (void)uploadDeviceSuccess:(void(^)(CPEWiFiDetail *wiFiDetail))success failure:(void(^)(NSError *error))failure errorCause:(void(^)(NSString *errorCause))errorCause{

//    NSString *url = @"/api/fit/device";
//    AFHTTPRequestOperationManager *mgr = [self getAFHTTPRequestOperationManager];
//    NSString *authHeaderStr = [self getCPEAuthHeaderWithType:@"POST"];
//    [mgr.requestSerializer setValue:authHeaderStr forHTTPHeaderField:@"Authorization"];
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    
//    dict[@"code"] = 100103
//    
//    token    是    token
//    device    否    0：未知 ；1：Android；2：ios
//    deviceid    否    手机设备唯一标识
//    braceletid    否    手环设备唯一标识
//    hardware    否    手环硬件版本
//    software    否    手环软件版本
//    
//    [mgr POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
}

#pragma mark - 请求头部
+(AFHTTPRequestOperationManager *) getAFHTTPRequestOperationManager
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.requestSerializer.timeoutInterval = 25;
    [mgr.requestSerializer setValue:@"-1" forHTTPHeaderField:@"Expires"];
    [mgr.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    [mgr.requestSerializer setValue:@"en-US,en,zh-CN" forHTTPHeaderField:@"Accept-Language"];
    NSString *cookie = [NIUerInfoAndCommonSave getValueFromKey:Cookie];
    if(cookie){
        [mgr.requestSerializer setValue:cookie forHTTPHeaderField:@"Cookie"];
    }
    [mgr.requestSerializer setValue:[NIWifiTool getRouterIp] forHTTPHeaderField:@"Peferer"];
    [mgr.requestSerializer setValue:@"no-cache" forHTTPHeaderField:@"Pragma"];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    return mgr;
}

#pragma mark - 请求头部
+(AFHTTPRequestOperationManager *) getAFHTTPRequestOperationManagerJson
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
//    mgr.requestSerializer.timeoutInterval = 25;
//    [mgr.requestSerializer setValue:@"-1" forHTTPHeaderField:@"Expires"];
//    [mgr.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
//    [mgr.requestSerializer setValue:@"en-US,en,zh-CN" forHTTPHeaderField:@"Accept-Language"];
//    NSString *cookie = [NIUerInfoAndCommonSave getValueFromKey:Cookie];
//    if(cookie){
//        [mgr.requestSerializer setValue:cookie forHTTPHeaderField:@"Cookie"];
//    }
//    [mgr.requestSerializer setValue:[NIWifiTool getRouterIp] forHTTPHeaderField:@"Peferer"];
//    [mgr.requestSerializer setValue:@"no-cache" forHTTPHeaderField:@"Pragma"];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    return mgr;
}

#pragma mark - 授权条件
+(NSString *) authHeaderWithRequestType:(NSString *) type path:(NSString *)path username:(NSString *)username password:(NSString *)password isLogin:(BOOL) isLogin{
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSString *HA1 = [[NSString stringWithFormat:@"%@:%@:%@",username,CPEgRealm,password] md5];
    NSString *HA2 = [[NSString stringWithFormat:@"%@:%@",type, path] md5];
    int rand = arc4random() % 100001;
    long date = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *tmp = [[NSString stringWithFormat:@"%d%li",rand, date] md5];
    NSString *AuthCnonce_f = [tmp substringWithRange:NSMakeRange(0, 16)];
    NSString *tmpAuthcount = [NSString stringWithFormat:@"%@%d",MIFI_AUTH_COUNT_PREX, MIFI_GN_COUNT];
    NSString *Authcount = [tmpAuthcount substringWithRange:NSMakeRange(tmpAuthcount.length - 8, 8)];
    NSString *DigestRes = [[NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",HA1,CPEgNonce,Authcount,AuthCnonce_f,CPEgQop,HA2] md5];
    
    [resultString appendString:@"Digest"];
    if (isLogin) {
        [resultString appendString:@"&"];
        [resultString appendFormat:@"username=%@&", username];
        [resultString appendFormat:@"realm=%@&",CPEgRealm];
        [resultString appendFormat:@"nonce=%@&",CPEgNonce];
        [resultString appendFormat:@"response=%@&",DigestRes];
        [resultString appendFormat:@"qop=%@&",CPEgQop];
        [resultString appendFormat:@"cnonce=%@",AuthCnonce_f];
        if ([[NIUerInfoAndCommonSave getValueFromKey:VersionName] isEqualToString:VersionCPE]) {
            [resultString appendFormat:@"&nc=%@",Authcount];
        }
        [resultString appendString:@"&temp=marvell"];
    } else {
        [resultString appendString:@" "];
        [resultString appendFormat:@"username=\"%@\", ", username];
        [resultString appendFormat:@"realm=\"%@\", ",CPEgRealm];
        [resultString appendFormat:@"nonce=\"%@\", ",CPEgNonce];
        [resultString appendFormat:@"uri=\"%@\", ",@"/cgi/xml_action.cgi"];
        [resultString appendFormat:@"response=\"%@\", ",DigestRes];
        [resultString appendFormat:@"qop=%@, ",CPEgQop];
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
    NSString *HA1 = [[NSString stringWithFormat:@"%@:%@:%@",username,CPEgRealm,password] md5];
    NSString *HA2 = [[NSString stringWithFormat:@"%@:%@",type, path] md5];
    int rand = arc4random() % 100001;
    long date = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *tmp = [[NSString stringWithFormat:@"%d%li",rand, date] md5];
    NSString *AuthCnonce_f = [tmp substringWithRange:NSMakeRange(0, 16)];
    NSString *tmpAuthcount = [NSString stringWithFormat:@"%@%d",MIFI_AUTH_COUNT_PREX, MIFI_GN_COUNT];
    NSString *Authcount = [tmpAuthcount substringWithRange:NSMakeRange(tmpAuthcount.length - 8, 8)];
    NSString *DigestRes = [[NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",HA1,CPEgNonce,Authcount,AuthCnonce_f,CPEgQop,HA2] md5];
    
    [resultString appendString:@"Digest"];
    [resultString appendString:@" "];
    [resultString appendFormat:@"username=\"%@\", ", username];
    [resultString appendFormat:@"realm=\"%@\", ",CPEgRealm];
    [resultString appendFormat:@"nonce=\"%@\", ",CPEgNonce];
    [resultString appendFormat:@"uri=\"%@\", ",@"/cgi/xml_action.cgi"];
    [resultString appendFormat:@"response=\"%@\", ",DigestRes];
    [resultString appendFormat:@"qop=%@, ",CPEgQop];
    [resultString appendFormat:@"nc=%@, ", Authcount];
    [resultString appendFormat:@"cnonce=\"%@\"",AuthCnonce_f];
    return resultString;
}

+(NSString *) getAuthValueWithAuthString:(NSString *)authString
{
    NSArray *array = [authString componentsSeparatedByString:@"="];
    NSString *tempStr = [array[1] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *tempStr1 = [tempStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"," withString:@""];
    return tempStr2;
}
@end
