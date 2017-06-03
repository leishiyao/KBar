//
//  SongCategoryCCell.m
//  FangWenShan
//
//  Created by Leis on 2017/6/3.
//  Copyright © 2017年 Leis. All rights reserved.
//

#import "SongCategoryCCell.h"
#import "SongCategory.h"

@interface SongCategoryCCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lName;
@property (weak, nonatomic) IBOutlet UILabel *lNum;
@end

@implementation SongCategoryCCell

- (void)setSource:(SongCategory *)source {
    _source = source;
    _imgView.image = [UIImage imageNamed:_source.imgName];
    _lName.text = _source.name;
    _lNum.text = _source.strNumSongs;
}

@end
