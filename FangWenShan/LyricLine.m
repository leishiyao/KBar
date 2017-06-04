//
//  LyricLine.m
//  FangWenShan
//
//  Created by Leis on 2017/6/4.
//  Copyright © 2017年 Leis. All rights reserved.
//

#import "LyricLine.h"

@implementation LyricLine

+ (NSArray<LyricLine *> *)parseFromString:(NSString *)string {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    NSArray *arrStr = [string componentsSeparatedByString:@"\n"];
    for (NSString *lineStr in arrStr) {
        
        LyricLine *line = [[LyricLine alloc] init];
        NSArray *arrLine = [lineStr componentsSeparatedByString:@"\t"];
        if (arrLine.count < 2) {
            continue;
        }
        line.time = [arrLine[ 1 ] floatValue] / 1000;
        line.content = arrLine[ 2 ];
        if ([line.content isEqualToString:@"=================="]) {
            line.content = @"Next Song~";
            line.duration = 0.01;
        } else {
            line.duration = [arrLine[ 3 ] floatValue];
        }
        [arr addObject:line];
    }
    return arr;
}

@end
