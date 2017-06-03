//
//  MainVC.m
//  HairCut
//
//  Created by Leis on 15/6/18.
//  Copyright (c) 2015年 Leis. All rights reserved.
//

#import "MainVC.h"
#import "UIViewController+Shortcut.h"
#import "UIImage+Original.h"
#import "SongListTVC.h"

@interface MainVC ()

@end

@implementation MainVC

- (void) initChildVCs {
    //    Note that a tab bar item image will be automatically rendered as a template image within a tab bar, unless you explicitly set its rendering mode to UIImageRenderingModeAlwaysOriginal. For more information, see Template Images.
    NSMutableArray *vcs = [[NSMutableArray alloc] init];
    
    UIViewController *vc0 = [UIViewController getInitVCInSB:@"Song"];
    vc0.tabBarItem.image = [[UIImage imageNamed:@"first"] originalImage];
    vc0.tabBarItem.selectedImage = [[UIImage imageNamed:@"first"] originalImage];
    vc0.tabBarItem.title = @"歌曲分类";
    UINavigationController *nvc0 = [[UINavigationController alloc] initWithRootViewController:vc0];
    [vcs addObject:nvc0];
    
    SongListTVC *vc1 = [UIViewController getVC:[SongListTVC class] inSB:@"Song"];
    vc1.mode = SongListFromLocal;
    vc1.tabBarItem.image = [[UIImage imageNamed:@"second"] originalImage];
    vc1.tabBarItem.selectedImage = [[UIImage imageNamed:@"second"] originalImage];
    vc1.tabBarItem.title = @"已点歌曲";
    UINavigationController *nvc1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    [vcs addObject:nvc1];
    
    [self setViewControllers:vcs animated:NO];
}

- (void) initAppearance {
    
    // tab bar
    [UITabBar appearance].tintColor = [UIColor colorWithRed:124.0/255.0 green:204/255.0 blue:217/255.0 alpha:1.0];
    [UITabBar appearance].barTintColor = [UIColor whiteColor];
//    [UITabBar appearance].backgroundImage = [[UIImage imageNamed:@"bgBottom"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];    // 实现拉伸效果

    // navi bar
    [UINavigationBar appearance].tintColor = [UIColor blackColor];
    [UINavigationBar appearance].barTintColor = [UIColor whiteColor];
//    [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"bgTop"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forBarMetrics:UIBarMetricsDefault];

    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor clearColor];
    [UINavigationBar appearance].titleTextAttributes = @{
                            NSFontAttributeName : [UIFont systemFontOfSize:17],
                            NSForegroundColorAttributeName:[UIColor blackColor],
                            NSShadowAttributeName:shadow
                            };
    
    [[UIBarButtonItem appearance] setTitleTextAttributes: @{
                                                         NSFontAttributeName : [UIFont systemFontOfSize:12],
                                                         NSForegroundColorAttributeName:[UIColor blackColor],
                                                         NSShadowAttributeName:shadow
                                                         } forState:UIControlStateNormal];
    
//    [UIBarButtonItem appearance].imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void) viewDidLoad {
    [super viewDidLoad];

    [self initChildVCs];
    [self initAppearance];
}

@end

// 去除返回按钮文字
@implementation UINavigationItem (CustomBackButton)
-(UIBarButtonItem *)backBarButtonItem{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:NULL];
//    item.imageInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    return item;
}

@end

