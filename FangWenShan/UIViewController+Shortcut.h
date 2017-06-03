//
//  UIViewController+Shortcut.h
//  HalfHourLife
//
//  Created by Leis on 15/6/17.
//  Copyright (c) 2015年 Leis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController(Shortcut)

+ (id) getVC:(Class)vcClassType inSB:(NSString *) sbName;
+ (id) getInitVCInSB:(NSString *) sbName;
+ (id) getVCNamed:(NSString *) vcSBID inSB:(NSString *) storyBoardName;

//+ (id) getVCInCurSB:(NSString *) vcName;

- (void) embedInVC:(UIViewController *) vc view:(UIView *) view;
- (void) removeFromParentVC;
@end

@interface UINavigationController(Shortcut)

- (NSArray<UIViewController *> *)popToThe:(int)n thPreviousVCAnimated:(BOOL)animated;

@end