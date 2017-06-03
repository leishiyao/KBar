//
//  NSArray+Save.h
//  FangWenShan
//
//  Created by Leis on 2017/6/3.
//  Copyright © 2017年 Leis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray(Save)

+ (instancetype) loadFromDocument:(NSString *) fileName;
- (void) saveToDocument:(NSString *)fileName;

@end
