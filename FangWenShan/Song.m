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
        _name = [aDecoder decodeObjectForKey:@"name"];
        _author = [aDecoder decodeObjectForKey:@"author"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_author forKey:@"author"];
    
}

+ (NSArray<Song *> *)parseFromResponse {
    NSMutableArray *arrSong = [[NSMutableArray alloc] init];

    return arrSong;
}
@end
