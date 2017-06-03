// AFAppDotNetAPIClient.h
//
// Copyright (c) 2012 Mattt Thompson (http://mattt.me/)


#import "APIClient.h"
#import "LSLoadingView.h"
#import "MBProgressHUD+AFNetworking.h"
#import "NSObject+Description.h"
#import "UIViewController+Shortcut.h"

@implementation APIClient

+ (instancetype)sharedClient {
    static APIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:APIServerBaseURLStr]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    
    return _sharedClient;
}

+ (NSURLSessionDataTask *) postToAPI:(NSString *)api
                          withParams:(NSDictionary *)params
                            progress:(void (^)(NSProgress * ))uploadProgress
                          needsCache:(BOOL)needsCache
                         waitingView:(BOOL)needsWaitingView
                           failAlert:(BOOL)needsFailAlert
                         leadToLogin:(BOOL)needsLeadToLogin
                             success:(void (^)(id ret))bSuccess
                                fail:(void (^)(NSError *error))bFail {
#ifdef DEBUG_SERVER
    NSLog(@"POST TO %@", [[[APIClient sharedClient].baseURL absoluteString] stringByAppendingString:api]);
    NSLog(@"PARAMS %@", params);
#endif
    NSURLSessionDataTask *task =
    [[APIClient sharedClient] GET:api
                        parameters:params
                          progress:nil
                           success:
     ^(NSURLSessionDataTask * __unused task, NSDictionary *JSON) {
         if ([JSON isKindOfClass:[NSDictionary class]] == NO) {
             NSLog(@"APIClient:返回值不是JSON");
             return;
         } else {
#ifdef DEBUG_SERVER
             NSLog(@"%@\n%@",[[[APIClient sharedClient].baseURL absoluteString] stringByAppendingString:api], [JSON propertiesDescription]);
#endif
         }
         
         NSInteger status;
         if ([JSON valueForKey:@"code"] != nil) {
             status = [[JSON valueForKey:@"code"] integerValue];
         } else  {
             status = 1;
         }
         
         switch (status) {
             case 1:
             {
                 id postsFromResponse = [JSON valueForKeyPath:@"data"];
                 if (postsFromResponse == nil) {
                     NSError *error = [NSError errorWithDomain:@"服务器返回有误" code:0 userInfo:nil];
                     NSLog(@"%@", error);
                     if (bFail) {
                         bFail(error);
                     }
                 } else {
                     if (bSuccess) {
                         bSuccess(postsFromResponse);
                     }
                 }
                 
                 break;
             }
            default:
             {
//                 NSString *reason = [JSON valueForKey: @"reason"];
//                 NSLog(@"%@", reason);
//                 NSError *error = [NSError errorWithDomain:reason code:[JSON[ @"code" ] integerValue] userInfo:nil];
//                 if (bFail) {
//                     bFail(error);
//                 }
//                 
//                 if (needsFailAlert) {
//                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
//                                                                         message:reason
//                                                                        delegate:nil
//                                                               cancelButtonTitle:@"好的"
//                                                               otherButtonTitles:nil];
//                     [alertView show];
//                 }
                 break;
             }
         }
     } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
         NSLog(@"%@", [error description]);
         if (bFail) {
             bFail(error);
         }
     }];
    if (needsWaitingView) {
        [[LSLoadingView sharedLoadingView] setAnimatingWithStateOfTask:task];
//        [[MBProgressHUD networkHUD] setAnimatingWithStateOfTask:task];
    }
    if (needsFailAlert) {
        [MBProgressHUD showTextAlertForTaskWithErrorOnCompletion:task];
    }
    return task;
}


+ (NSURLSessionDataTask *) postToAPI:(NSString *)api
                          withParams:(NSDictionary *)params
                           userAware:(BOOL)userAware
                             success:(void (^)(id ret))bSuccess
                                fail:(void (^)(NSError *error))bFail {
    return [self postToAPI:api
                withParams:params
                  progress:nil
                needsCache:NO
               waitingView:userAware
                 failAlert:userAware
               leadToLogin:userAware
                   success:bSuccess
                      fail:bFail];
}

+ (NSURLSessionDataTask *) postToAPI:(NSString *)api
                          withParams:(NSDictionary *)params
                             success:(void (^)(id ret))bSuccess
                                fail:(void (^)(NSError *error))bFail {
    return [self postToAPI:api
                withParams:params
                 userAware:YES
                   success:bSuccess
                      fail:bFail];
}

+ (NSURLSessionDataTask *) postToAPI:(NSString *)api
                          withParams:(NSDictionary *)params
                           withBlock:(void (^)(id ret, NSError *error))block {
    return [self postToAPI:api
                withParams:params
                   success:^(id retObj) {
                       if (block) {
                           block(retObj, nil);
                       }
                   } fail:^(NSError *error) {
                       if (block) {
                           block(nil, error);
                       }
                   }];
}

@end
