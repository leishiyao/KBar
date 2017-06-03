//
//  MBProgressHUD+AFNetworking.m
//  AnYiAn
//
//  Created by Leis on 15/5/20.
//  Copyright (c) 2015年 Leis. All rights reserved.
//

#import "MBProgressHUD+AFNetworking.h"
#import <Foundation/Foundation.h>
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)

//#import "AFHTTPRequestOperation.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#import "AFURLSessionManager.h"
#endif

@implementation MBProgressHUD (AFNetworking)

static MBProgressHUD *_networkHUD = nil;
+ (MBProgressHUD *) networkHUD {
    if ( [[UIApplication sharedApplication] keyWindow] == nil ) {
        return nil;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _networkHUD = [[MBProgressHUD alloc] initWithView:[[UIApplication sharedApplication] keyWindow]];
        _networkHUD.removeFromSuperViewOnHide = YES;
        _networkHUD.dimBackground = YES;
    });
    
    return _networkHUD;
}

static MBProgressHUD *_textHUD = nil;
+ (MBProgressHUD *) textHUD {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _textHUD = [[MBProgressHUD alloc] initWithView:[[UIApplication sharedApplication] keyWindow]];
        _textHUD.removeFromSuperViewOnHide = YES;
        _textHUD.mode = MBProgressHUDModeText;
        _textHUD.margin = 10.f;
        
    });
    
    return _textHUD;
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
- (void)setAnimatingWithStateOfTask:(NSURLSessionTask *)task {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter removeObserver:self name:AFNetworkingTaskDidResumeNotification object:nil];
    [notificationCenter removeObserver:self name:AFNetworkingTaskDidSuspendNotification object:nil];
    [notificationCenter removeObserver:self name:AFNetworkingTaskDidCompleteNotification object:nil];
    
    if (task) {
        if (task.state != NSURLSessionTaskStateCompleted) {
            if (task.state == NSURLSessionTaskStateRunning) {
                [self startAnimating];
            } else {
                [self stopAnimating];
            }
            
            [notificationCenter addObserver:self selector:@selector(af_startAnimating) name:AFNetworkingTaskDidResumeNotification object:task];
            [notificationCenter addObserver:self selector:@selector(af_stopAnimating) name:AFNetworkingTaskDidCompleteNotification object:task];
            [notificationCenter addObserver:self selector:@selector(af_stopAnimating) name:AFNetworkingTaskDidSuspendNotification object:task];
        }
    }
}
#endif

//
//#pragma mark -
//
//- (void)setAnimatingWithStateOfOperation:(AFURLConnectionOperation *)operation {
//    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
//    
//    [notificationCenter removeObserver:self name:AFNetworkingOperationDidStartNotification object:nil];
//    [notificationCenter removeObserver:self name:AFNetworkingOperationDidFinishNotification object:nil];
//    
//    if (operation) {
//        if (![operation isFinished]) {
//            if ([operation isExecuting]) {
//                [self startAnimating];
//            } else {
//                [self stopAnimating];
//            }
//            
//            [notificationCenter addObserver:self selector:@selector(af_startAnimating) name:AFNetworkingOperationDidStartNotification object:operation];
//            [notificationCenter addObserver:self selector:@selector(af_stopAnimating) name:AFNetworkingOperationDidFinishNotification object:operation];
//        }
//    }
//}

#pragma mark -

- (void)af_startAnimating {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self startAnimating];
    });
}

- (void)af_stopAnimating {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopAnimating];
    });
}

#pragma mark - 

- (void) startAnimating {
    [[[UIApplication sharedApplication] keyWindow] addSubview:_networkHUD];
    [_networkHUD show:YES];

}

- (void) stopAnimating {
    [_networkHUD hide:YES];
}


static void AFGetAlertViewTitleAndMessageFromError(NSError *error, NSString * __autoreleasing *title, NSString * __autoreleasing *message) {
    if (error.localizedDescription && (error.localizedRecoverySuggestion || error.localizedFailureReason)) {
        *title = error.localizedDescription;
        
        if (error.localizedRecoverySuggestion) {
            *message = error.localizedRecoverySuggestion;
        } else {
            *message = error.localizedFailureReason;
        }
    } else if (error.localizedDescription) {
        *title = NSLocalizedStringFromTable(@"Error", @"AFNetworking", @"Fallback Error Description");
        *message = error.localizedDescription;
    } else {
        *title = NSLocalizedStringFromTable(@"Error", @"AFNetworking", @"Fallback Error Description");
        *message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"%@ Error: %ld", @"AFNetworking", @"Fallback Error Failure Reason Format"), error.domain, (long)error.code];
    }
}


+ (void) showTextAlertForTaskWithErrorOnCompletion:(NSURLSessionTask *)task {
    
    __block id observer = [[NSNotificationCenter defaultCenter] addObserverForName:AFNetworkingTaskDidCompleteNotification object:task queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
        
        NSError *error = notification.userInfo[AFNetworkingTaskDidCompleteErrorKey];
        if (error) {
            NSString *title, *message;
            AFGetAlertViewTitleAndMessageFromError(error, &title, &message);
            _textHUD = [[MBProgressHUD alloc] initWithView:[[UIApplication sharedApplication] keyWindow]];
            _textHUD.removeFromSuperViewOnHide = YES;
            _textHUD.mode = MBProgressHUDModeText;
            _textHUD.margin = 10.f;
            [[[UIApplication sharedApplication] keyWindow] addSubview:_textHUD];
            [_textHUD show:YES];
            
            _textHUD.labelText = @"网络不给力，请稍候再试";
            
            
            [_textHUD hide:YES afterDelay:1];
        }
        
        [[NSNotificationCenter defaultCenter] removeObserver:observer name:AFNetworkingTaskDidCompleteNotification object:notification.object];
    }];

}




@end

#endif