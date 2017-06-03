//
//  SongCategory.h
//  FangWenShan
//
//  Created by Leis on 2017/6/3.
//  Copyright © 2017年 Leis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SongCategory : NSObject
@property (strong, nonatomic) NSString *imgName;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *numSongs;
@property (strong, nonatomic) NSString *strNumSongs;

+ (NSArray<SongCategory *> *) parseSourceArray;
@end
