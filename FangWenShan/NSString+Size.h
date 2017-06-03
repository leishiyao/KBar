//
//  UILabel+APIClient.h
//  WeComfort
//
//  Created by Leis on 15/12/24.
//
//

#import <UIKit/UIKit.h>

@interface NSString(Size)

- (CGSize) calculateSizeWithFontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize;

-(NSString *) utf8ToUnicode:(NSString *)string;
- (NSString *)unicodeToUTF8;
@end
