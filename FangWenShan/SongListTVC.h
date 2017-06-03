//
//  SongListTVC.h
//  FangWenShan
//
//  Created by Leis on 2017/6/3.
//  Copyright © 2017年 Leis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongListTVC : UITableViewController

typedef NS_ENUM(NSUInteger, SongListTVCMode) {
    SongListFromCategory = 0,
    SongListFromLocal
};

@property (strong, nonatomic) NSString *strSongCategory;
@property (assign, nonatomic) SongListTVCMode mode;

@end
