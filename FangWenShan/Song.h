//
//  Song.h
//  FangWenShan
//
//  Created by Leis on 2017/6/3.
//  Copyright © 2017年 Leis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Song : NSObject <NSCoding>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *author;

+ (NSArray<Song *> *) parseFromResponse;
//+ (NSArray<Song *> *) parseFromLocal;

@end
