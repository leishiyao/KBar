//
//  BarberCVC.m
//  HairCut
//
//  Created by Leis on 15/6/18.
//  Copyright (c) 2015年 Leis. All rights reserved.
//

#import "SongCategoryCVC.h"
#import "KRLCollectionViewGridLayout.h"
#import "UIViewController+Shortcut.h"
#import "StrAlertFactory.h"
#import "SongCategoryCCell.h"
#import "SongCategory.h"
#import "SongListTVC.h"
#import "UIViewController+Shortcut.h"

@interface SongCategoryCVC ()
@property (strong, nonatomic) NSArray<SongCategory*> *arrSource;
@end

@implementation SongCategoryCVC

- (void) initCollectionView {
    KRLCollectionViewGridLayout *layout = (KRLCollectionViewGridLayout *)self.collectionView.collectionViewLayout;
    layout.numberOfItemsPerLine = 2;
    layout.aspectRatio = 1;
    const int kSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(kSpacing, kSpacing, kSpacing, kSpacing);
    layout.interitemSpacing = kSpacing;
    layout.lineSpacing = kSpacing;
}

- (void) initSource {
    _arrSource = [SongCategory parseSourceArray];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSource];
    [self initCollectionView];
    
}


#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _arrSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SongCategoryCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SongCategoryCCell" forIndexPath:indexPath];
    cell.source = _arrSource[ indexPath.row ];
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SongListTVC *vc = [UIViewController getVC:[SongListTVC class] inSB:@"Song"];
    vc.strSongCategory = _arrSource[ indexPath.row ].name;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
