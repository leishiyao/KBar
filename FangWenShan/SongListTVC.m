//
//  SongListTVC.m
//  FangWenShan
//
//  Created by Leis on 2017/6/3.
//  Copyright © 2017年 Leis. All rights reserved.
//

#import "SongListTVC.h"
#import "SongListTCell.h"
#import "APIClient.h"
#import "Song.h"
#import "RecorderVC.h"
#import "UIViewController+Shortcut.h"
#import "RecommendListTVC.h"

@interface SongListTVC ()

@property (strong, nonatomic) NSArray<Song *> *arrSong;
@end

@implementation SongListTVC

- (void) initAppearance {
    if ( _mode == SongListFromCategory ) {
        self.navigationItem.title = _strSongCategory;
    } else if ( _mode == SongListFromLocal ) {
        self.navigationItem.title = @"本地歌单";
    }
    self.tableView.tableFooterView = [[UIView alloc] init];
    
}

- (void) loadData {
    NSMutableDictionary *params = [@{@"categoryName":_strSongCategory} mutableCopy];
    [APIClient postToAPI:@"1" withParams:params success:^(NSArray *arr) {
        _arrSong = [Song parseFromResponse:arr category:_strSongCategory];
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        ;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAppearance];
    [self loadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _arrSong.count;
}

#pragma mark Table View Data Source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SongListTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SongListTCell" forIndexPath:indexPath];
    
    cell.song = _arrSong[ indexPath.row ];
    
    return cell;
}

#pragma mark Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_mode == SongListFromCategory) {
        RecommendListTVC *vc = [UIViewController getVC:[RecommendListTVC class] inSB:@"Song"];
        vc.song = _arrSong[ indexPath.row ];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (_mode == SongListFromLocal) {
    
        RecorderVC *vc = [UIViewController getVC:[RecorderVC class] inSB:@"Song"];
//  TODO
    
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
