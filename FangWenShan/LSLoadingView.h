//
//  LSLoadingView.h
//  HairCut
//
//  Created by Leis on 15/11/13.
//  Copyright © 2015年 Leis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSLoadingView : UIView

@property (assign, nonatomic) BOOL dimBackGround;
@property (assign, nonatomic) int liveCount;
- (id) initWithLoadingImgs:(NSArray<UIImage *> *)arrImg;
- (void) show;
- (void) dismiss;
@end

@interface LSLoadingView (AFNetworking)
+ (LSLoadingView *) sharedLoadingView;
- (void)setAnimatingWithStateOfTask:(NSURLSessionTask *)task;

@end