//
//  SongListTCell.m
//  FangWenShan
//
//  Created by Leis on 2017/6/3.
//  Copyright © 2017年 Leis. All rights reserved.
//

#import "SongListTCell.h"
#import "Song.h"
#import "UIImageView+APIClient.h"

@implementation SongListTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSong:(Song *)song {
    _song = song;
//    [_imgView setImageWithUrlStr:song.albumUrl placeHolder:nil];
    _lName.text = _song.name;
    _lAuthor.text = _song.author;
    
}
@end
