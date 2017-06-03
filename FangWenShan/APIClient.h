// AFAppDotNetAPIClient.h
//
// Copyright (c) 2012 Mattt Thompson (http://mattt.me/)


#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "Global.h"

#ifdef DEBUG_SERVER

static NSString * const APIServerBaseURLStr = @"http://mmmtapi.yueyishujia.com:8888/";
static NSString * const ImageServerBaseURLStr = @"http://mmmphoto.yueyishujia.com:8112/";

#else   // release

static NSString * const APIServerBaseURLStr = @"http://mmmtapi.yueyishujia.com:8888/";
static NSString * const ImageServerBaseURLStr = @"http://mmmphoto.yueyishujia.com:8112/";

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
                             success:(void (^)(NSDictionary *dicRet))bSuccess
                                fail:(void (^)(NSError *error))bFail;


+ (NSURLSessionDataTask *) postToAPI:(NSString *)api
                          withParams:(id)params
                           userAware:(BOOL)userAware
                             success:(void (^)(NSDictionary *dicRet))bSuccess
                                fail:(void (^)(NSError *error))bFail;

+ (NSURLSessionDataTask *) postToAPI:(NSString *)api
                          withParams:(id)params
                             success:(void (^)(NSDictionary *dicRet))bSuccess
                                fail:(void (^)(NSError *error))bFail;

+ (NSURLSessionDataTask *) postToAPI:(NSString *)api
                          withParams:(NSDictionary *)params
                           withBlock:(void (^)(NSDictionary *dicRet, NSError *error))block;


@end
