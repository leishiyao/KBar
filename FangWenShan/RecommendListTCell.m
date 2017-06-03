//
//  RecommendListTCell.m
//  FangWenShan
//
//  Created by Leis on 2017/6/3.
//  Copyright © 2017年 Leis. All rights reserved.
//

#import "RecommendListTCell.h"
#import "Song.h"

@implementation RecommendListTCell

- (void)setSong:(Song *)song {
    _song = song;
    _lTitle.text = [_song strPieceList];
}

@end
