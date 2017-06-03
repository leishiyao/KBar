//
//  SongCategory.m
//  FangWenShan
//
//  Created by Leis on 2017/6/3.
//  Copyright © 2017年 Leis. All rights reserved.
//

#import "SongCategory.h"
#import "NSString+Size.h"
@implementation SongCategory

- (void)setNumSongs:(NSNumber *)numSongs {
    _numSongs = numSongs;
    _strNumSongs = [NSString stringWithFormat:@"约%@首歌曲", numSongs];
    
}

+ (NSArray *)parseSourceArray {
    NSString* path  = [[NSBundle mainBundle] pathForResource:@"song_category" ofType:@"json"];
    //将文件内容读取到字符串中，注意编码NSUTF8StringEncoding 防止乱码，
    NSString* jsonString = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //将字符串写到缓冲区。
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    //解析json数据，使用系统方法 JSONObjectWithData:  options: error:
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    NSMutableArray *arrSource = [[NSMutableArray alloc] init];
    int i;
    for (NSDictionary *dic in arr) {
        NSArray *arrSubCat = dic[ @"list" ];
        i = 0;
        for (NSString *strSubCat in arrSubCat) {
            SongCategory *category = [[SongCategory alloc] init];
            category.imgName = [NSString stringWithFormat:@"song_cat_%d", 47 + (i++ % 35)];
            category.name = [strSubCat unicodeToUTF8];
            category.numSongs = @100;
            [arrSource addObject:category];
        }
    }
    return arrSource;
}

@end
