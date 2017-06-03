// AFAppDotNetAPIClient.h
//
// Copyright (c) 2012 Mattt Thompson (http://mattt.me/)


#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "Global.h"

#ifdef DEBUG_SERVER

static NSString * const APIServerBaseURLStr = @"http://192.168.16.169:8887/ktv/";
static NSString * const ImageServerBaseURLStr = @"http://192.168.16.169:8888/ktv/";

#else   // release

static NSString * const APIServerBaseURLStr = @"http://wecomfort.f3322.org:8887/ktv/";
static NSString * const ImageServerBaseURLStr = @"http://wecomfort.f3322.org:8888/ktv/";

#endif

@interface APIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

+ (NSURLSessionDataTask *) postToAPI:(NSString *)api
                          withParams:(NSDictionary *)params
                            progress:(void (^)(NSProgress * ))uploadProgress
                          needsCache:(BOOL)needsCache
                         waitingView:(BOOL)needsWaitingView
                           failAlert:(BOOL)needsFailAlert
                         leadToLogin:(BOOL)needsLeadToLogin
                             success:(void (^)(id ret))bSuccess
                                fail:(void (^)(NSError *error))bFail;


+ (NSURLSessionDataTask *) postToAPI:(NSString *)api
                          withParams:(id)params
                           userAware:(BOOL)userAware
                             success:(void (^)(id ret))bSuccess
                                fail:(void (^)(NSError *error))bFail;

+ (NSURLSessionDataTask *) postToAPI:(NSString *)api
                          withParams:(id)params
                             success:(void (^)(id ret))bSuccess
                                fail:(void (^)(NSError *error))bFail;

+ (NSURLSessionDataTask *) postToAPI:(NSString *)api
                          withParams:(NSDictionary *)params
                           withBlock:(void (^)(id ret, NSError *error))block;


@end
