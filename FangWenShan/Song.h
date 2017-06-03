//
//  Song.h
//  FangWenShan
//
//  Created by Leis on 2017/6/3.
//  Copyright © 2017年 Leis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Song : NSObject <NSCoding>

@property (strong, nonatomic) NSString *idCode;
@property (strong, nonatomic) NSString *subCategory;
@property (strong, nonatomic) NSString *albumUrl;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *author;

@property (strong, nonatomic) NSString *strPieceList;
@property (strong, nonatomic) NSArray<Song *> *arrPieces;

+ (NSArray<Song *> *) parseFromResponse:(NSArray *)arr category:(NSString *)category;

+ (NSArray<Song *> *) parseFromRecommended:(NSArray *)arr originalSong:(Song *)originalSong;
//+ (NSArray<Song *> *) parseFromLocal;

@end
