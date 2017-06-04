//
//  LyricLine.h
//  FangWenShan
//
//  Created by Leis on 2017/6/4.
//  Copyright © 2017年 Leis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricLine : NSObject

@property (assign, nonatomic) NSTimeInterval time;
@property (strong, nonatomic) NSString *content;
@property (assign, nonatomic) NSTimeInterval duration;

+ (NSArray<LyricLine *> *) parseFromString:(NSString *)string;
@end
