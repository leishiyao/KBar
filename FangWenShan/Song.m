//
//  Song.m
//  FangWenShan
//
//  Created by Leis on 2017/6/3.
//  Copyright © 2017年 Leis. All rights reserved.
//

#import "Song.h"

@implementation Song

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self){
        _albumUrl = [aDecoder decodeObjectForKey:@"albumUrl"];
        _name = [aDecoder decodeObjectForKey:@"name"];
        _author = [aDecoder decodeObjectForKey:@"author"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_albumUrl forKey:@"albumUrl"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_author forKey:@"author"];
    
}

+ (NSArray<Song *> *)parseFromResponse {
    NSMutableArray *arrSong = [[NSMutableArray alloc] init];
    
    Song *song = [[Song alloc] init];
    song.name = @"梦醒时分";
    song.author = @"陈淑桦";
    [arrSong addObject: song];
    [arrSong addObject: song];
    [arrSong addObject: song];
    
    return arrSong;
}
@end
