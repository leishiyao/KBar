//
//  UIViewController+Shortcut.m
//  HalfHourLife
//
//  Created by Leis on 15/6/17.
//  Copyright (c) 2015年 Leis. All rights reserved.
//

#import "UIViewController+Shortcut.h"
#import <objc/runtime.h>


@implementation UIViewController(Shortcut)

+ (id) getVC:(Class)vcClassType inSB:(NSString *) sbName {
//    if ([vcClassType isSubclassOfClass:[UIViewController class]]) {
//        <#statements#>
//    }
    return [self getVCNamed:NSStringFromClass(vcClassType) inSB:sbName];
}

+ (id)getInitVCInSB:(NSString *)sbName {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:sbName bundle:[NSBundle mainBundle]];
    UIViewController *vc = nil;
    @try {
        vc = [sb instantiateInitialViewController];
    }
    @catch (NSException *exception) {
        NSLog(@"Get View Controller in sb: %@ Failed!", sbName);
    }
    @finally {
        ;
    }
    
    return vc;
}


+ (id) getVCNamed:(NSString *) vcSBID inSB:(NSString *) storyBoardName {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:storyBoardName bundle:[NSBundle mainBundle]];
    UIViewController *vc = nil;
    @try {
        vc = [sb instantiateViewControllerWithIdentifier:vcSBID];
    }
    @catch (NSException *exception) {
        NSLog(@"Get View Controller %@ in sb: %@ Failed!", vcSBID, storyBoardName);
    }
    @finally {
        ;
    }
    
    return vc;
}

- (void) embedInVC:(UIViewController *) vc view:(UIView *) view {
//    self.tvcService = [self.storyboard instantiateViewControllerWithIdentifier:@"ServiceTVC"];
    
    [vc addChildViewController:self];
    [self.view setFrame:[view bounds]];
    [view addSubview:self.view];
    [self didMoveToParentViewController:vc];
}

- (void) removeFromParentVC {
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

@end

@implementation UINavigationController(Shortcut)

- (NSArray<UIViewController *> *)popToThe:(int)n thPreviousVCAnimated:(BOOL)animated {
    UIViewController *vc = self.childViewControllers[ self.childViewControllers.count - 1 - n ];
    return [self popToViewController:vc animated:YES];
}

@end
