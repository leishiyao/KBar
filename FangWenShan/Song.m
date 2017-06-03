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
        _subCategory = [aDecoder decodeObjectForKey:@"subCategory"];
        _idCode = [aDecoder decodeObjectForKey:@"idCode"];
        _strPieceList = [aDecoder decodeObjectForKey:@"strPieceList"];
        _arrPieces = [aDecoder decodeObjectForKey:@"arrPieces"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_albumUrl forKey:@"albumUrl"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_author forKey:@"author"];
    [aCoder encodeObject:_subCategory forKey:@"subCategory"];
    [aCoder encodeObject:_idCode forKey:@"idCode"];
    [aCoder encodeObject:_strPieceList forKey:@"strPieceList"];
    [aCoder encodeObject:_arrPieces forKey:@"arrPieces"];
    
}

+ (NSArray<Song *> *) parseFromResponse:(NSArray *)arr category:(NSString *)category {
    NSMutableArray *arrSong = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dic in arr) {
        Song *song = [Song parseFromDic:dic];
        song.subCategory = category;
        [arrSong addObject:song];
    }
//    Song *song = [[Song alloc] init];
//    song.name = @"梦醒时分";
//    song.author = @"陈淑桦";
//    [arrSong addObject: song];
//    [arrSong addObject: song];
//    [arrSong addObject: song];
    
    return arrSong;
}

+ (NSArray<Song *> *)parseFromRecommended:(NSArray *)arr originalSong:(Song *)originalSong {
    NSMutableArray *arrSong = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dic in arr) {
        Song *song = originalSong;
        song.idCode = dic[ @"id" ];
        
        NSMutableArray *arrSegment = [[NSMutableArray alloc] init];
        for (NSDictionary *dicSegment in dic[ @"songs" ]) {
            Song *segment = [Song parseFromDic:dicSegment];
            [arrSegment addObject:segment];
        }
        song.arrPieces = arrSegment;
        [arrSong addObject:song];
    }
    return arrSong;
}

+ (Song *)parseFromDic:(NSDictionary *)dic {
    Song *song = [[Song alloc] init];
    if (dic[ @"album" ] != nil && [dic[ @"album" ] isKindOfClass:[NSNull class]] == NO) {
        song.albumUrl = dic[ @"album" ];
    }
    song.name = dic[ @"name" ];
    song.author = dic[ @"author" ];
    if (dic[ @"category" ] != nil && [dic[ @"category" ] isKindOfClass:[NSNull class]] == NO) {
        song.subCategory = dic[ @"category" ];
    }
    return song;
}

- (NSString *)strPieceList {
    if (_strPieceList != nil) {
        return _strPieceList;
    }
    NSMutableArray *arrSegment = [[NSMutableArray alloc] init];
    for (Song *segment in _arrPieces) {
        
        [arrSegment addObject:segment.name];
    }
    _strPieceList = [arrSegment componentsJoinedByString:@"+"];
    return _strPieceList;
}

@end
