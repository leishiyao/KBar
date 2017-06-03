//
//  NSArray+Save.m
//  FangWenShan
//
//  Created by Leis on 2017/6/3.
//  Copyright © 2017年 Leis. All rights reserved.
//

#import "NSArray+Save.h"

@implementation NSArray(Save)

+ (instancetype) loadFromDocument:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    id arr = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return arr;
}

- (void) saveToDocument:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    [NSKeyedArchiver archiveRootObject:self toFile:filePath];
}


@end
