//
//  MBProgressHUD+AFNetworking.h
//  AnYiAn
//
//  Created by Leis on 15/5/20.
//  Copyright (c) 2015年 Leis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

#import <Availability.h>

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)

#import <UIKit/UIKit.h>

@class AFURLConnectionOperation;

@interface MBProgressHUD (AFNetworking)

+ (MBProgressHUD *) networkHUD;
+ (void) showTextAlertForTaskWithErrorOnCompletion:(NSURLSessionTask *)task;

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
- (void)setAnimatingWithStateOfTask:(NSURLSessionTask *)task;

//- (void)setAnimatingWithStateOfOperation:(AFURLConnectionOperation *)operation;


#endif


@end

#endif